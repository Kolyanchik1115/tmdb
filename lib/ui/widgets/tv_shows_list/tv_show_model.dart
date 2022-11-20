// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb/domain/entity/popular_tv_response.dart';
import 'package:tmdb/domain/entity/tv_show.dart';
import 'package:tmdb/domain/library/localized_model.dart';
import 'package:tmdb/domain/library/paginator.dart';
import 'package:tmdb/ui/naviagation/main_navigation_routes_name.dart';

class TVListRowData {
  final int id;
  final String? posterPath;
  final String name;
  final String releaseDate;
  final String overview;

  TVListRowData({
    required this.id,
    required this.posterPath,
    required this.name,
    required this.releaseDate,
    required this.overview,
  });
}

abstract class TVListViewModelMoviesProvider {
  Future<PopularTVResponse> popularTVShow(int page, String locale);
  Future<PopularTVResponse> searchTVShow(int page, String locale, String query);
}

class TVListViewModel extends ChangeNotifier {
  final TVListViewModelMoviesProvider tvProvider;
  final _localeStorage = LocalizedModelStorage();

  late final Paginator<TVShow> _popularTVPaginator;
  late final Paginator<TVShow> _searchTVPaginator;

  Timer? searchDebounce;

  var _show = <TVListRowData>[];
  String? _searchQuery;

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  List<TVListRowData> get tv => List.unmodifiable(_show);
  late DateFormat _dateFormat;

  TVListViewModel(this.tvProvider) {
    _popularTVPaginator = Paginator<TVShow>((page) async {
      final result =
          await tvProvider.popularTVShow(page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.tv,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchTVPaginator = Paginator<TVShow>((page) async {
      final result = await tvProvider.searchTVShow(
          page, _localeStorage.localeTag, _searchQuery ?? '');

      return PaginatorLoadResult(
          data: result.tv,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  Future<void> setupLocale(Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularTVPaginator.reset();
    await _searchTVPaginator.reset();
    _show.clear();
    await _loadNextPage();

    final query = _searchQuery;
    if (query == null) {}
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchTVPaginator.loadNextPage();
      _show = _searchTVPaginator.data.map((_makeRowData)).toList();
    } else {
      await _popularTVPaginator.loadNextPage();
      _show = _popularTVPaginator.data.map((_makeRowData)).toList();
    }
    notifyListeners();
  }

  TVListRowData _makeRowData(TVShow tv) {
    final releseDate = tv.firstAirDate;
    final releseDateTitle =
        releseDate != null ? _dateFormat.format(releseDate) : '';

    return TVListRowData(
      id: tv.id,
      posterPath: tv.posterPath,
      name: tv.name,
      releaseDate: releseDateTitle,
      overview: tv.overview,
    );
  }

  void onMovieTab(BuildContext context, int index) {
    final id = tv[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRoutesNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> searchTV(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _show.clear();
      if (isSearchMode) {
        await _searchTVPaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showMovieAtIndex(int index) {
    if (index < tv.length - 1) return;
    _loadNextPage();
  }
}
