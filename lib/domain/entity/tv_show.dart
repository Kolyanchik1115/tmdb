// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'package:tmdb/domain/entity/movies/movie_date_parser.dart';

part 'tv_show.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TVShow {
  final String? posterPath;
  final String overview;
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime? firstAirDate;
  final List<int> genre_ids;
  final int id;
  final String originalLanguage;
  final String name;
  final String? backdropPath;
  final double popularity;
  final double voteAverage;
  TVShow({
    required this.posterPath,
    required this.overview,
    required this.firstAirDate,
    required this.genre_ids,
    required this.id,
    required this.originalLanguage,
    required this.name,
    required this.backdropPath,
    required this.popularity,
    required this.voteAverage,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) => _$TVShowFromJson(json);
  Map<String, dynamic> toJson() => _$TVShowToJson(this);
}
