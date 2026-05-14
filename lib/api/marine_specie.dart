class MarineSpecie {
  final String scientificName;
  final String commonName;
  final String order;
  final String threatStatus;

  String description;
  String imageUrl;
  bool isFavorite;

  MarineSpecie({
    required this.scientificName,
    required this.commonName,
    required this.order,
    required this.threatStatus,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });
}