class MarineSpecie {
  final String scientificName;
  final String commonName;
  final String order;
  final String threatStatus;

  String? description;
  String imageUrl;

  MarineSpecie({
    required this.scientificName,
    required this.commonName,
    required this.order,
    required this.threatStatus,
    this.description,
    required this.imageUrl,
  });
}