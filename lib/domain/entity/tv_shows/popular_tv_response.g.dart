// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_tv_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularTVResponse _$PopularTVResponseFromJson(Map<String, dynamic> json) =>
    PopularTVResponse(
      page: json['page'] as int,
      tv: (json['results'] as List<dynamic>)
          .map((e) => TVShow.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['total_results'] as int,
      totalPages: json['total_pages'] as int,
    );

Map<String, dynamic> _$PopularTVResponseToJson(PopularTVResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.tv.map((e) => e.toJson()).toList(),
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
    };
