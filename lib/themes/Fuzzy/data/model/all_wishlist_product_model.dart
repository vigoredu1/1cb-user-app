class ProductWishlistModel {
  Meta? meta;
  dynamic error;
  Data? data;

  ProductWishlistModel({this.meta, this.error, this.data});

  ProductWishlistModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['meta'] = meta?.toJson();
    map['error'] = error;
    map['data'] = data?.toJson();
    return map;
  }
}

class Meta {
  dynamic paginationInfo;

  Meta({this.paginationInfo});

  Meta.fromJson(Map<String, dynamic> json) {
    paginationInfo = json['paginationInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['paginationInfo'] = paginationInfo;
    return map;
  }
}

class Data {
  String? wishlistId;
  String? userId;
  int? totalItem;
  List<WishlistProduct>? products;

  Data({this.wishlistId, this.userId, this.totalItem, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    wishlistId = json['wishlistId'];
    userId = json['userId'];
    totalItem = json['totalItem'];
    if (json['products'] != null) {
      products = List<WishlistProduct>.from(
          json['products'].map((x) => WishlistProduct.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['wishlistId'] = wishlistId ?? '';
    map['userId'] = userId ?? '';
    map['totalItem'] = totalItem ?? 0;
    map['products'] = products?.map((x) => x.toJson()).toList() ?? [];
    return map;
  }
}

class WishlistProduct {
  String? id;
  String? vendorId;
  String? title;
  String? sku;
  String? productType;
  String? categoryId;
  String? description;
  dynamic productImage;
  int? price;
  int? costPrice;
  int? salePrice;
  String? taxesAndCharges;
  String? unit;
  int? retailPrice;
  String? inventoryStatus;
  String? availability;
  String? globalTradeItemNumber;
  String? manufacturerPartNumber;
  String? brandName;
  String? productUpcEan;
  int? isShippingFree;
  dynamic pageTitle;
  dynamic metaKeywords;
  dynamic metaDescription;
  String? productUrl;
  String? deliveryEventName;
  DateTime? deliveryFromDate;
  DateTime? deliveryToDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? subCategory;
  String? categoryName;
  String? subCategoryName;
  List<Image>? images; // ✅ List<Image> का उपयोग करें
  String? taxOptions;

  WishlistProduct({
    this.id,
    this.vendorId,
    this.title,
    this.sku,
    this.productType,
    this.categoryId,
    this.description,
    this.productImage,
    this.price,
    this.costPrice,
    this.salePrice,
    this.taxesAndCharges,
    this.unit,
    this.retailPrice,
    this.inventoryStatus,
    this.availability,
    this.globalTradeItemNumber,
    this.manufacturerPartNumber,
    this.brandName,
    this.productUpcEan,
    this.isShippingFree,
    this.pageTitle,
    this.metaKeywords,
    this.metaDescription,
    this.productUrl,
    this.deliveryEventName,
    this.deliveryFromDate,
    this.deliveryToDate,
    this.createdAt,
    this.updatedAt,
    this.subCategory,
    this.categoryName,
    this.subCategoryName,
    this.images,
    this.taxOptions,
  });

  WishlistProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendorId'];
    title = json['title'];
    sku = json['sku'];
    productType = json['productType'];
    categoryId = json['categoryId'];
    description = json['description'];
    productImage = json['productImage'];
    price = json['price'];
    costPrice = json['costPrice'];
    salePrice = json['salePrice'];
    taxesAndCharges = json['taxesAndCharges'];
    unit = json['unit'];
    retailPrice = json['retailPrice'];
    inventoryStatus = json['inventoryStatus'];
    availability = json['availability'];
    globalTradeItemNumber = json['globalTradeItemNumber'];
    manufacturerPartNumber = json['manufacturerPartNumber'];
    brandName = json['brandName'];
    productUpcEan = json['productUpcEan'];
    isShippingFree = json['isShippingFree'];
    pageTitle = json['pageTitle'];
    metaKeywords = json['metaKeywords'];
    metaDescription = json['metaDescription'];
    productUrl = json['productUrl'];
    deliveryEventName = json['deliveryEventName'];
    deliveryFromDate = json['deliveryFromDate'] != null
        ? DateTime.tryParse(json['deliveryFromDate'])
        : null;
    deliveryToDate = json['deliveryToDate'] != null
        ? DateTime.tryParse(json['deliveryToDate'])
        : null;
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'])
        : null;
    subCategory = json['subCategory'];
    categoryName = json['categoryName'];
    subCategoryName = json['subCategoryName'];
    if (json['images'] != null) {
      images = List<Image>.from(
          json['images'].map((x) => Image.fromJson(x)));
    }    taxOptions = json['taxOptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id ?? '';
    map['vendorId'] = vendorId ?? '';
    map['title'] = title ?? '';
    map['sku'] = sku ?? '';
    map['productType'] = productType ?? '';
    map['categoryId'] = categoryId ?? '';
    map['description'] = description ?? '';
    map['productImage'] = productImage;
    map['price'] = price ?? 0;
    map['costPrice'] = costPrice ?? 0;
    map['salePrice'] = salePrice ?? 0;
    map['taxesAndCharges'] = taxesAndCharges ?? '';
    map['unit'] = unit ?? '';
    map['retailPrice'] = retailPrice ?? 0;
    map['inventoryStatus'] = inventoryStatus ?? '';
    map['availability'] = availability ?? '';
    map['globalTradeItemNumber'] = globalTradeItemNumber ?? '';
    map['manufacturerPartNumber'] = manufacturerPartNumber ?? '';
    map['brandName'] = brandName ?? '';
    map['productUpcEan'] = productUpcEan ?? '';
    map['isShippingFree'] = isShippingFree ?? 0;
    map['pageTitle'] = pageTitle;
    map['metaKeywords'] = metaKeywords;
    map['metaDescription'] = metaDescription;
    map['productUrl'] = productUrl ?? '';
    map['deliveryEventName'] = deliveryEventName ?? '';
    map['deliveryFromDate'] = deliveryFromDate?.toIso8601String();
    map['deliveryToDate'] = deliveryToDate?.toIso8601String();
    map['createdAt'] = createdAt?.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['subCategory'] = subCategory ?? '';
    map['categoryName'] = categoryName ?? '';
    map['subCategoryName'] = subCategoryName ?? '';
    map['images'] = images?.map((x) => x.toJson()).toList() ?? [];    map['taxOptions'] = taxOptions;
    return map;
  }

}
class Image {
  String? id;
  String? image;
  String? colors;
  String? sizes;
  dynamic stock;
  dynamic price;
  DateTime? createdAt;
  DateTime? updatedAt;

  Image({
    this.id,
    this.image,
    this.colors,
    this.sizes,
    this.stock,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    colors = json['colors'];
    sizes = json['sizes'];
    stock = json['stock'];
    price = json['price'];
    createdAt = json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id ?? '';
    map['image'] = image ?? '';
    map['colors'] = colors ?? '';
    map['sizes'] = sizes ?? '';
    map['stock'] = stock;
    map['price'] = price;
    map['createdAt'] = createdAt?.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    return map;
  }
}