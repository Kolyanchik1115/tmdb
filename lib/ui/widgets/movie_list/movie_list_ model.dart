// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb/domain/entity/movie.dart';
import 'package:tmdb/domain/entity/popular_movie_response.dart';
import 'package:tmdb/domain/library/localized_model.dart';
import 'package:tmdb/domain/library/paginator.dart';
import 'package:tmdb/ui/naviagation/main_navigation_routes_name.dart';

class MovieListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

abstract class MovieMovieListViewModelMoviesProvider {
  Future<PopularMovieResponse> popularMovie(int page, String locale);
  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query);
}

class MovieListViewModel extends ChangeNotifier {
  final MovieMovieListViewModelMoviesProvider moviesProvider;
  final _localeStorage = LocalizedModelStorage();

  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;

  Timer? searchDebounce;

  var _movies = <MovieListRowData>[];
  String? _searchQuery;

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;

  MovieListViewModel(this.moviesProvider) {
    _popularMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await moviesProvider.popularMovie(page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result = await moviesProvider.searchMovie(
          page, _localeStorage.localeTag, _searchQuery ?? '');

      return PaginatorLoadResult(
          data: result.movies,
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
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();

    final query = _searchQuery;
    if (query == null) {}
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map((_makeRowData)).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map((_makeRowData)).toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releseDate = movie.releaseDate;
    final releseDateTitle =
        releseDate != null ? _dateFormat.format(releseDate) : '';

    return MovieListRowData(
      id: movie.id,
      posterPath: movie.posterPath,
      title: movie.title,
      releaseDate: releseDateTitle,
      overview: movie.overview,
    );
  }

  void onMovieTab(BuildContext context, int index) {
    final id = movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRoutesNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showMovieAtIndex(int index) {
    if (index < movies.length - 1) return;
    _loadNextPage();
  }
}
