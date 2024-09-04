class Contents {
  final List<ContentsItem> items;

  Contents({
    required this.items,
  });

  factory Contents.fromJson(Map<String, dynamic> json) => Contents(
        items: List<ContentsItem>.from(json["items"].map((x) => ContentsItem.fromJson(x))),
      );
}

class ContentsItem {
  final String resourceUri;
  final String name;

  ContentsItem({
    required this.resourceUri,
    required this.name,
  });

  factory ContentsItem.fromJson(Map<String, dynamic> json) => ContentsItem(
        resourceUri: json["resourceURI"],
        name: json["name"],
      );
}
