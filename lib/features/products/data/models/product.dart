class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageCover,
    required this.images,
    required this.rating,
    required this.ratingCount,
    required this.sold,
  });
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageCover;
  final List<String> images;
  final num rating;
  final int ratingCount;
  final int sold;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    price: json['price'] as num? ?? 0,
    imageCover: json['imageCover'] as String? ?? '',
    images: List<String>.from(json['images'] as List? ?? const []),
    rating: json['ratingsAverage'] as num? ?? 0,
    ratingCount: json['ratingsQuantity'] as int? ?? 0,
    sold: json['sold'] as int? ?? 0,
  );
}
