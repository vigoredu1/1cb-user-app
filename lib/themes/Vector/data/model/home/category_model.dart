class Category {
  final String id;
  final String vendorId;
  final String name;
  final String? description;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.vendorId,
    required this.name,
    this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      vendorId: json['vendor_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
