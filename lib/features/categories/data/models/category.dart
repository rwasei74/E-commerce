class Category {
  const Category({required this.id, required this.name, required this.image});

  final String id;
  final String name;
  final String image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as String? ?? json['_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    image: json['image'] as String? ?? '',
  );
}
