class Product {
  final String id;
  final String categoryId;
  final String subcategoryId;
  final String title;
  final String description;
  final String productUrl;
  final double price;
  final String brandName;
  final List<String> images;

  Product({
    required this.id,
    required this.categoryId,
    required this.subcategoryId,
    required this.title,
    required this.description,
    required this.productUrl,
    required this.price,
    required this.brandName,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // "json" here refers to the product object inside "data"
    List<String> imagesList = [];
    if (json['images'] != null) {
      imagesList = List<String>.from(json['images']);
    }
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      subcategoryId: json['subCategory'],
      title: json['title'],
      description: json['description'],
      productUrl: json['product_url'] ?? "",
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      brandName: json['brand_name'] ?? "",
      images: imagesList,
    );
  }
}
