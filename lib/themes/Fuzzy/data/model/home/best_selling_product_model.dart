class BestSellerModel {
  Meta? meta;
  dynamic error;
  List<Datum>? data;

  BestSellerModel({this.meta, this.error, this.data});

  BestSellerModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    error = json['error'];
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(Datum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (meta != null) map['meta'] = meta!.toJson();
    map['error'] = error;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Datum {
  Product? product;
  List<Variant>? variants;
  List<ShippingDetail>? shippingDetails;

  Datum({this.product, this.variants, this.shippingDetails});

  Datum.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['variants'] != null) {
      variants = <Variant>[];
      json['variants'].forEach((v) {
        variants!.add(Variant.fromJson(v));
      });
    }
    if (json['shippingDetails'] != null) {
      shippingDetails = <ShippingDetail>[];
      json['shippingDetails'].forEach((v) {
        shippingDetails!.add(ShippingDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (product != null) map['product'] = product!.toJson();
    if (variants != null) {
      map['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (shippingDetails != null) {
      map['shippingDetails'] = shippingDetails!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Product {
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
  int? isImported;
  dynamic importedFromVendor;
  String? shippingPrice;
  dynamic importedProductReference;
  int? currentStock;
  int? lowStock;
  dynamic sizes;
  dynamic colorImages;
  int? peopleViewed;
  String? about;
  String? taxesAndCharges;
  String? unit;
  String? taxOptions;
  int? packagingCharges;
  int? isPackagingCharges;
  int? status;
  int? isFeaturedProduct;
  String? categoryName;
  String? subCategoryName;
  String? totalQuantity;
  List<ProductImage>? images;

  Product({
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
    this.isImported,
    this.importedFromVendor,
    this.shippingPrice,
    this.importedProductReference,
    this.currentStock,
    this.lowStock,
    this.sizes,
    this.colorImages,
    this.peopleViewed,
    this.about,
    this.taxesAndCharges,
    this.unit,
    this.taxOptions,
    this.packagingCharges,
    this.isPackagingCharges,
    this.status,
    this.isFeaturedProduct,
    this.categoryName,
    this.subCategoryName,
    this.totalQuantity,
    this.images,
  });

  Product.fromJson(Map<String, dynamic> json) {
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
        ? DateTime.parse(json['deliveryFromDate'])
        : null;
    deliveryToDate = json['deliveryToDate'] != null
        ? DateTime.parse(json['deliveryToDate'])
        : null;
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    subCategory = json['subCategory'];
    isImported = json['isImported'];
    importedFromVendor = json['importedFromVendor'];
    shippingPrice = json['shippingPrice'];
    importedProductReference = json['importedProductReference'];
    currentStock = json['currentStock'];
    lowStock = json['lowStock'];
    sizes = json['sizes'];
    colorImages = json['colorImages'];
    peopleViewed = json['peopleViewed'];
    about = json['about'];
    taxesAndCharges = json['taxesAndCharges'];
    unit = json['unit'];
    taxOptions = json['taxOptions'];
    packagingCharges = json['packagingCharges'];
    isPackagingCharges = json['isPackagingCharges'];
    status = json['status'];
    isFeaturedProduct = json['isFeaturedProduct'];
    categoryName = json['categoryName'];
    subCategoryName = json['subCategoryName'];
    totalQuantity = json['totalQuantity'];
    if (json['images'] != null) {
      images = <ProductImage>[];
      json['images'].forEach((v) {
        images!.add(ProductImage.fromJson(v));
      });
    }

    // images = json['images'] != null ? List<String>.from(json['images']) : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['productUrl'] = productUrl;
    map['deliveryEventName'] = deliveryEventName ?? '';
    map['deliveryFromDate'] = deliveryFromDate?.toIso8601String();
    map['deliveryToDate'] = deliveryToDate?.toIso8601String();
    map['createdAt'] = createdAt?.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['subCategory'] = subCategory ?? '';
    map['isImported'] = isImported ?? 0;
    map['importedFromVendor'] = importedFromVendor;
    map['shippingPrice'] = shippingPrice ?? '';
    map['importedProductReference'] = importedProductReference;
    map['currentStock'] = currentStock ?? 0;
    map['lowStock'] = lowStock ?? 0;
    map['sizes'] = sizes;
    map['colorImages'] = colorImages;
    map['peopleViewed'] = peopleViewed ?? 0;
    map['about'] = about ?? '';
    map['taxesAndCharges'] = taxesAndCharges ?? '';
    map['unit'] = unit;
    map['taxOptions'] = taxOptions;
    map['packagingCharges'] = packagingCharges ?? 0;
    map['isPackagingCharges'] = isPackagingCharges ?? 0;
    map['status'] = status ?? 0;
    map['isFeaturedProduct'] = isFeaturedProduct ?? 0;
    map['categoryName'] = categoryName ?? '';
    map['subCategoryName'] = subCategoryName ?? '';
    map['totalQuantity'] = totalQuantity ?? '';
    map['images'] = images ?? [];
    if (images != null) {
      map['images'] = images!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ProductImage {
  String? id;
  String? productId;
  String? image;
  String? sizes;

  ProductImage({this.id, this.productId, this.image, this.sizes});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    image = json['image'];
    sizes = json['sizes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'productId': productId ?? '',
      'image': image ?? '',
      'sizes': sizes ?? '',
    };
  }
}


class ShippingDetail {
  String? locationName;
  String? shippingCharge;

  ShippingDetail({this.locationName, this.shippingCharge});

  ShippingDetail.fromJson(Map<String, dynamic> json) {
    locationName = json['locationName'];
    shippingCharge = json['shippingCharge'];
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName ?? '',
      'shippingCharge': shippingCharge ?? '',
    };
  }
}

class Variant {
  String? variantName;
  String? variantValue;

  Variant({this.variantName, this.variantValue});

  Variant.fromJson(Map<String, dynamic> json) {
    variantName = json['variantName'];
    variantValue = json['variantValue'];
  }

  Map<String, dynamic> toJson() {
    return {
      'variantName': variantName ?? '',
      'variantValue': variantValue ?? '',
    };
  }
}

class Meta {
  dynamic paginationInfo;

  Meta({this.paginationInfo});

  Meta.fromJson(Map<String, dynamic> json) {
    paginationInfo = json['paginationInfo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'paginationInfo': paginationInfo,
    };
  }
}
