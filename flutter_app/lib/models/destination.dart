class Destination {
  final String id;
  final String name;
  final String province;
  final String description;
  final double rating;
  final int pricePerDay; // USD, sample data

  const Destination({
    required this.id,
    required this.name,
    required this.province,
    required this.description,
    required this.rating,
    required this.pricePerDay,
  });
}