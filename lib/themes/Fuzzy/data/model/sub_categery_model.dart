class SubCategory {
  final String id;
  final String vendorId;
  final String name;
  final String category; // Ye selected category id ke barabar hoga.
  final String? displayType;
  final String? description;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryName;

  SubCategory({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.category,
    this.displayType,
    this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      vendorId: json['vendorId'],
      name: json['name'],
      category: json['category'],
      displayType: json['display_type'],
      description: json['description'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: json['category_name'],
    );
  }
}
