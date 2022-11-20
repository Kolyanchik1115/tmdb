// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tmdb/config/configuration.dart';
import 'package:tmdb/domain/api_client/account_api_client.dart';
import 'package:tmdb/domain/api_client/movie_api_client.dart';
import 'package:tmdb/domain/data_providers/session_data_provider.dart';
import 'package:tmdb/domain/entity/popular_movie_response.dart';
import 'package:tmdb/domain/entity/popular_tv_response.dart';
import 'package:tmdb/domain/local_entity/movie_details_local.dart';
import 'package:tmdb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:tmdb/ui/widgets/movie_list/movie_list_%20model.dart';
import 'package:tmdb/ui/widgets/tv_shows_list/tv_show_model.dart';

class MovieService
    implements
        MovieDetailsModelMovieProvider,
        MovieMovieListViewModelMoviesProvider,
        TVListViewModelMoviesProvider {
  final MovieApiClient movieApiClient;
  final SessionDataProvider sessionDataProvider;
  final AccountApiClient accountApiClient;

  MovieService({
    required this.movieApiClient,
    required this.sessionDataProvider,
    required this.accountApiClient,
  });

  @override
  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      movieApiClient.popularMovie(
        page,
        locale,
        Configuration.apiKey,
      );
  @override
  Future<PopularTVResponse> popularTVShow(int page, String locale) async =>
      movieApiClient.popularTVMovie(
        page,
        locale,
        Configuration.apiKey,
      );

  @override
  Future<PopularMovieResponse> searchMovie(
          int page, String locale, String query) async =>
      movieApiClient.searchMovie(
        page,
        locale,
        query,
        Configuration.apiKey,
      );
  @override
  Future<PopularTVResponse> searchTVShow(
          int page, String locale, String query) async =>
      movieApiClient.searchTVShow(
        page,
        locale,
        query,
        Configuration.apiKey,
      );

  @override
  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    final movieDetails = await movieApiClient.movieDetails(movieId, locale);
    final sessionId = await sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await movieApiClient.isFavorite(movieId, sessionId);
    }
    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  @override
  Future<void> updateFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final sessionId = await sessionDataProvider.getSessionId();
    final accountId = await sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }

  MovieService copyWith({
    MovieApiClient? movieApiClient,
    SessionDataProvider? sessionDataProvider,
    AccountApiClient? accountApiClient,
  }) {
    return MovieService(
      movieApiClient: movieApiClient ?? this.movieApiClient,
      sessionDataProvider: sessionDataProvider ?? this.sessionDataProvider,
      accountApiClient: accountApiClient ?? this.accountApiClient,
    );
  }

  @override
  String toString() =>
      'MovieService(movieApiClient: $movieApiClient, sessionDataProvider: $sessionDataProvider, accountApiClient: $accountApiClient)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieService &&
        other.movieApiClient == movieApiClient &&
        other.sessionDataProvider == sessionDataProvider &&
        other.accountApiClient == accountApiClient;
  }

  @override
  int get hashCode =>
      movieApiClient.hashCode ^
      sessionDataProvider.hashCode ^
      accountApiClient.hashCode;
}
