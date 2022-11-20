// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TVShow _$TVShowFromJson(Map<String, dynamic> json) => TVShow(
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String,
      firstAirDate: parseMovieDateFromString(json['first_air_date'] as String?),
      genre_ids:
          (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      id: json['id'] as int,
      originalLanguage: json['original_language'] as String,
      name: json['name'] as String,
      backdropPath: json['backdrop_path'] as String?,
      popularity: (json['popularity'] as num).toDouble(),
      voteAverage: (json['vote_average'] as num).toDouble(),
    );

Map<String, dynamic> _$TVShowToJson(TVShow instance) => <String, dynamic>{
      'poster_path': instance.posterPath,
      'overview': instance.overview,
      'first_air_date': instance.firstAirDate?.toIso8601String(),
      'genre_ids': instance.genre_ids,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'name': instance.name,
      'backdrop_path': instance.backdropPath,
      'popularity': instance.popularity,
      'vote_average': instance.voteAverage,
    };
