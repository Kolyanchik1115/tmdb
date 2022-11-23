import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb/domain/entity/tv_shows/tv_show.dart';

part 'popular_tv_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularTVResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<TVShow> tv;
  final int totalResults;
  final int totalPages;

  PopularTVResponse(
      {required this.page,
      required this.tv,
      required this.totalResults,
      required this.totalPages});

  factory PopularTVResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularTVResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PopularTVResponseToJson(this);
}
