import 'thumbnail_model.dart';

class CharacterModel {
  final int id;
  final String name;
  final String description;
  final ThumbnailModel thumbnail;

  CharacterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        thumbnail: ThumbnailModel.fromJson(json['thumbnail']),
      );
}
