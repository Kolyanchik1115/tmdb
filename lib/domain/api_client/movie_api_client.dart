// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tmdb/config/configuration.dart';
import 'package:tmdb/domain/api_client/network_client.dart';
import 'package:tmdb/domain/entity/movies/movie_details.dart';
import 'package:tmdb/domain/entity/movies/popular_movie_response.dart';
import 'package:tmdb/domain/entity/tv_shows/popular_tv_response.dart';

abstract class MovieApiClient {
  Future<PopularMovieResponse> popularMovie(
    int page,
    String locale,
    String apiKey,
  );
  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
    String apiKey,
  );
  Future<PopularTVResponse> popularTVMovie(
    int page,
    String locale,
    String apiKey,
  );
  Future<PopularTVResponse> searchTVShow(
    int page,
    String locale,
    String query,
    String apiKey,
  );
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  );
  Future<bool> isFavoriteMovie(
    int movieId,
    String sessionId,
  );
}

class MovieApiClientDefault implements MovieApiClient {
  final NetworkClient networkClient;
  const MovieApiClientDefault(this.networkClient);

  @override
  Future<PopularMovieResponse> popularMovie(
    int page,
    String locale,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<PopularTVResponse> popularTVMovie(
    int page,
    String locale,
    String apiKey,
  ) async {
    PopularTVResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTVResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/tv/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  @override
  Future<PopularTVResponse> searchTVShow(
    int page,
    String locale,
    String query,
    String apiKey,
  ) async {
    PopularTVResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularTVResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/search/tv',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  @override
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  @override
  Future<bool> isFavoriteMovie(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}
