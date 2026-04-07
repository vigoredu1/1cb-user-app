import 'dart:convert';

/// ================= HELPER =================
List<T> parseList<T>(
  dynamic value,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (value is List) return value.map((e) => fromJson(e)).toList();
  if (value is Map<String, dynamic>) return [fromJson(value)];
  return [];
}

/// ================= RESPONSE =================
ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

class ProductResponse {
  final Meta? meta;
  final dynamic error;
  final List<ProductData>? data;

  ProductResponse({this.meta, this.error, this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        meta: json["meta"] != null ? Meta.fromJson(json["meta"]) : null,
        error: json["error"],
        data: json["data"] is List
            ? List<ProductData>.from(
                json["data"].map((x) => ProductData.fromJson(x)),
              )
            : [],
      );
}

/// ================= META =================
class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        paginationInfo: json["paginationInfo"],
      );
}

/// ================= PRODUCT DATA =================
class ProductData {
  final Product? product;
  final List<ShippingDetail>? shipping_details;
  final List<dynamic>? reviews;
  final List<WholesalerAddress>? wholesalerAddress;
  final List<ResalerAddress>? resalerAddress;

  ProductData({
    this.product,
    this.shipping_details,
    this.reviews,
    this.wholesalerAddress,
    this.resalerAddress,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        product:
            json["product"] != null ? Product.fromJson(json["product"]) : null,
        shipping_details: parseList(
          json["shipping_details"],
          (e) => ShippingDetail.fromJson(e),
        ),
        reviews: json["reviews"] is List ? json["reviews"] : [],
        wholesalerAddress: parseList(
          json["wholesalerAddress"],
          (e) => WholesalerAddress.fromJson(e),
        ),
        resalerAddress: parseList(
          json["resalerAddress"],
          (e) => ResalerAddress.fromJson(e),
        ),
      );
}

/// ================= PRODUCT =================
class Product {
  final String? id;
  final String? vendor_id;
  final String? title;
  final String? sku;
  final String? product_type;
  final String? category_id;
  final String? description;
  final dynamic product_image;
  final int? price;
  final int? cost_price;
  final int? sale_price;
  final int? retail_price;
  final String? inventory_status;
  final String? availability;
  final String? global_trade_item_number;
  final dynamic manufacturer_part_number;
  final String? brand_name;
  final dynamic product_upc_ean;
  final int? is_shipping_free;
  final dynamic page_title;
  final dynamic meta_keywords;
  final dynamic meta_description;
  final dynamic product_url;
  final String? delivery_event_name;
  final dynamic delivery_from_date;
  final dynamic delivery_to_date;
  final String? created_at;
  final String? updated_at;
  final dynamic subCategory;
  final int? is_imported;
  final String? imported_from_vendor;
  final String? shippingPrice;
  final String? imported_product_reference;
  final int? currentStock;
  final int? lowStock;
  final List<String>? sizes;
  final List<String>? color_images;
  final int? people_viewed;
  final dynamic about;
  final String? taxesAndCharges;
  final String? unit;
  final dynamic taxOptions;
  final int? packagingCharges;
  final int? isPackagingCharges;
  final int? status;
  final int? isFeaturedProduct;
  final String? increaseParsentage;
  final String? internationalshippingPrice;
  final String? currency;
  final dynamic VideoUrl;
  final String? vendorstatus;
  final dynamic editor;
  final dynamic videos;
  final String? categoryName;
  final dynamic subCategoryName;
  final int? mrpPrice;
  final int? discountPrice;
  final String? productName;
  final dynamic productUrl;
  final int? sellingPrice;
  final String? productId;
  final int? totalReviews;
  final int? rating;
  final List<ProductImage>? images;
  final List<dynamic>? tags;

  Product({
    this.id,
    this.vendor_id,
    this.title,
    this.sku,
    this.product_type,
    this.category_id,
    this.description,
    this.product_image,
    this.price,
    this.cost_price,
    this.sale_price,
    this.retail_price,
    this.inventory_status,
    this.availability,
    this.global_trade_item_number,
    this.manufacturer_part_number,
    this.brand_name,
    this.product_upc_ean,
    this.is_shipping_free,
    this.page_title,
    this.meta_keywords,
    this.meta_description,
    this.product_url,
    this.delivery_event_name,
    this.delivery_from_date,
    this.delivery_to_date,
    this.created_at,
    this.updated_at,
    this.subCategory,
    this.is_imported,
    this.imported_from_vendor,
    this.shippingPrice,
    this.imported_product_reference,
    this.currentStock,
    this.lowStock,
    this.sizes,
    this.color_images,
    this.people_viewed,
    this.about,
    this.taxesAndCharges,
    this.unit,
    this.taxOptions,
    this.packagingCharges,
    this.isPackagingCharges,
    this.status,
    this.isFeaturedProduct,
    this.increaseParsentage,
    this.internationalshippingPrice,
    this.currency,
    this.VideoUrl,
    this.vendorstatus,
    this.editor,
    this.videos,
    this.categoryName,
    this.subCategoryName,
    this.mrpPrice,
    this.discountPrice,
    this.productName,
    this.productUrl,
    this.sellingPrice,
    this.productId,
    this.totalReviews,
    this.rating,
    this.images,
    this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"]?.toString(),
        vendor_id: json["vendor_id"]?.toString(),
        title: json["title"]?.toString(),
        sku: json["sku"]?.toString(),
        product_type: json["product_type"]?.toString(),
        category_id: json["category_id"]?.toString(),
        description: json["description"]?.toString(),
        product_image: json["product_image"],
        price: json["price"],
        cost_price: json["cost_price"],
        sale_price: json["sale_price"],
        retail_price: json["retail_price"],
        inventory_status: json["inventory_status"]?.toString(),
        availability: json["availability"]?.toString(),
        global_trade_item_number: json["global_trade_item_number"]?.toString(),
        manufacturer_part_number: json["manufacturer_part_number"],
        brand_name: json["brand_name"]?.toString(),
        product_upc_ean: json["product_upc_ean"],
        is_shipping_free: json["is_shipping_free"],
        page_title: json["page_title"],
        meta_keywords: json["meta_keywords"],
        meta_description: json["meta_description"],
        product_url: json["product_url"],
        delivery_event_name: json["delivery_event_name"]?.toString(),
        delivery_from_date: json["delivery_from_date"],
        delivery_to_date: json["delivery_to_date"],
        created_at: json["created_at"]?.toString(),
        updated_at: json["updated_at"]?.toString(),
        subCategory: json["subCategory"],
        is_imported: json["is_imported"],
        imported_from_vendor: json["imported_from_vendor"]?.toString(),
        shippingPrice: json["shippingPrice"]?.toString(),
        imported_product_reference:
            json["imported_product_reference"]?.toString(),
        currentStock: json["currentStock"],
        lowStock: json["lowStock"],
        sizes: json["sizes"] is String
            ? List<String>.from(jsonDecode(json["sizes"]))
            : json["sizes"] is List
                ? List<String>.from(json["sizes"])
                : null,
        color_images: json["color_images"] is String
            ? List<String>.from(jsonDecode(json["color_images"]))
            : json["color_images"] is List
                ? List<String>.from(json["color_images"])
                : null,
        people_viewed: json["people_viewed"],
        about: json["about"],
        taxesAndCharges: json["taxesAndCharges"]?.toString(),
        unit: json["unit"]?.toString(),
        taxOptions: json["taxOptions"],
        packagingCharges: json["packagingCharges"],
        isPackagingCharges: json["isPackagingCharges"],
        status: json["status"],
        isFeaturedProduct: json["isFeaturedProduct"],
        increaseParsentage: json["increaseParsentage"]?.toString(),
        internationalshippingPrice:
            json["internationalshippingPrice"]?.toString(),
        currency: json["currency"]?.toString(),
        VideoUrl: json["VideoUrl"],
        vendorstatus: json["vendorstatus"]?.toString(),
        editor: json["editor"],
        videos: json["videos"],
        categoryName: json["categoryName"]?.toString(),
        subCategoryName: json["subCategoryName"],
        mrpPrice: json["mrpPrice"],
        discountPrice: json["discountPrice"],
        productName: json["productName"]?.toString(),
        productUrl: json["productUrl"],
        sellingPrice: json["sellingPrice"],
        productId: json["productId"]?.toString(),
        totalReviews: json["totalReviews"],
        rating: json["rating"],
        images: json["images"] is List
            ? List<ProductImage>.from(
                json["images"].map((x) => ProductImage.fromJson(x)),
              )
            : null,
        tags: json["tags"] is List ? json["tags"] : null,
      );
}

/// ================= PRODUCT IMAGE =================
class ProductImage {
  final String? id;
  final String? image;
  final List<ProductSize>? sizes;
  final List<String>? colors;
  final String? stock;
  final String? price;

  ProductImage({
    this.id,
    this.image,
    this.sizes,
    this.colors,
    this.stock,
    this.price,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"]?.toString(),
        image: json["image"]?.toString(),
        sizes: json["sizes"] is List
            ? List<ProductSize>.from(
                json["sizes"].map((x) => ProductSize.fromJson(x)),
              )
            : null,
        colors:
            json["colors"] is List ? List<String>.from(json["colors"]) : null,
        stock: json["stock"]?.toString(),
        price: json["price"]?.toString(),
      );
}

/// ================= PRODUCT SIZE =================
class ProductSize {
  final String? stock;
  final String? price;
  final String? Size;

  ProductSize({this.stock, this.price, this.Size});

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
        stock: json["stock"]?.toString(),
        price: json["price"]?.toString(),
        Size: json["Size"]?.toString(),
      );
}

/// ================= SHIPPING DETAILS =================
class ShippingDetail {
  final String? product_id;
  final String? location_name;
  final String? shipping_charge;

  ShippingDetail({this.product_id, this.location_name, this.shipping_charge});

  factory ShippingDetail.fromJson(Map<String, dynamic> json) => ShippingDetail(
        product_id: json["product_id"]?.toString(),
        location_name: json["location_name"]?.toString(),
        shipping_charge: json["shipping_charge"]?.toString(),
      );
}

/// ================= WHOLESALER =================
class WholesalerAddress {
  final String? userId;
  final List<String>? originCountry;
  final List<String>? originState;
  final List<String>? originCity;
  final List<String>? originPostalCode;

  WholesalerAddress({
    this.userId,
    this.originCountry,
    this.originState,
    this.originCity,
    this.originPostalCode,
  });

  static List<String>? _safeList(dynamic value) {
    if (value == null) return null;

    // If backend sends JSON string
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (e) {
        return null;
      }
    }

    // If backend sends direct list
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    // If backend sends int, bool, map, etc
    return null;
  }

  factory WholesalerAddress.fromJson(Map<String, dynamic> json) =>
      WholesalerAddress(
        userId: json["userId"]?.toString(),
        originCountry: _safeList(json["originCountry"]),
        originState: _safeList(json["originState"]),
        originCity: _safeList(json["originCity"]),
        originPostalCode: _safeList(json["originPostalCode"]),
      );
}

/// ================= RESALER =================
class ResalerAddress {
  final String? id;
  final dynamic country;

  ResalerAddress({this.id, this.country});

  factory ResalerAddress.fromJson(Map<String, dynamic> json) => ResalerAddress(
        id: json["id"]?.toString(),
        country: json["country"],
      );
}
