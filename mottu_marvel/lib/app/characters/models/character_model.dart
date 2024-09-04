import '../../utils/functions.dart';
import 'contents_model.dart';
import 'thumbnail_model.dart';

class CharacterModel {
  final int id;
  final String name;
  final String description;
  final ThumbnailModel thumbnail;
  final Contents comics;
  final Contents series;
  final Contents stories;
  final Contents events;

  CharacterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.comics,
    required this.series,
    required this.stories,
    required this.events,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        thumbnail: ThumbnailModel.fromJson(json["thumbnail"]),
        comics: Contents.fromJson(json["comics"]),
        series: Contents.fromJson(json["series"]),
        stories: Contents.fromJson(json["stories"]),
        events: Contents.fromJson(json["events"]),
      );

  List<int> getComicIds() => comics.items.map((item) => int.parse(getLastUrlParameter(item.resourceUri))).toList();

  List<int> getSeriesIds() => series.items.map((item) => int.parse(getLastUrlParameter(item.resourceUri))).toList();

  List<int> getStoryIds() => stories.items.map((item) => int.parse(getLastUrlParameter(item.resourceUri))).toList();

  List<int> getEventIds() => events.items.map((item) => int.parse(getLastUrlParameter(item.resourceUri))).toList();
}
