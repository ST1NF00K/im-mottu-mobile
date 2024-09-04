class ThumbnailModel {
  final String path;
  final String extension;

  String get fullPath => '$path.$extension';

  ThumbnailModel({
    required this.path,
    required this.extension,
  });

  factory ThumbnailModel.fromJson(Map<String, dynamic> json) => ThumbnailModel(
        path: json['path'],
        extension: json['extension'],
      );
}
