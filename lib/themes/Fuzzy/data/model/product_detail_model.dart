class ProductDetail {
  final String id;
  final String vendorId;
  final String title;
  final String sku;
  final String productType;
  final String categoryId;
  final String description;
  final String productUrl;
  final double price;
  final double costPrice;
  final double salePrice;
  final double retailPrice;
  final String inventoryStatus;
  final String availability;
  final String brandName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String subCategory;
  final List<String> images;

  ProductDetail({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.sku,
    required this.productType,
    required this.categoryId,
    required this.description,
    required this.productUrl,
    required this.price,
    required this.costPrice,
    required this.salePrice,
    required this.retailPrice,
    required this.inventoryStatus,
    required this.availability,
    required this.brandName,
    required this.createdAt,
    required this.updatedAt,
    required this.subCategory,
    required this.images,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    // Parse the list of images if available.
    List<String> imageList = [];
    if (json['images'] != null) {
      imageList = List<String>.from(json['images']);
    }
    return ProductDetail(
      id: json['id'],
      vendorId: json['vendor_id'],
      title: json['title'],
      sku: json['sku'] ?? '',
      productType: json['product_type'] ?? '',
      categoryId: json['category_id'] ?? '',
      description: json['description'] ?? '',
      productUrl: json['product_url'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      costPrice: double.tryParse(json['cost_price'].toString()) ?? 0.0,
      salePrice: double.tryParse(json['sale_price'].toString()) ?? 0.0,
      retailPrice: double.tryParse(json['retail_price'].toString()) ?? 0.0,
      inventoryStatus: json['inventory_status'] ?? '',
      availability: json['availability'] ?? '',
      brandName: json['brand_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      subCategory: json['subCategory'] ?? '',
      images: imageList,
    );
  }
}
