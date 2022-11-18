// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tmdb/domain/entity/movie_details.dart';

class MovieDetailsLocal {
  final MovieDetails details;
  final bool isFavorite;
  MovieDetailsLocal({
    required this.details,
    required this.isFavorite,
  });
}
