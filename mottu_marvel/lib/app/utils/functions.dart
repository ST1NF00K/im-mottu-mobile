String getLastUrlParameter(String url) {
  final uri = Uri.parse(url);
  final pathSegments = uri.pathSegments;
  return pathSegments.isNotEmpty ? pathSegments.last : '';
}
