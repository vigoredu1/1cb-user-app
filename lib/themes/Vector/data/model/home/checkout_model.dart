class OrderCreateModel {
  Order? order;
  List<OrderItem>? orderItems;
  IngAddress? billingAddress;
  IngAddress? shippingAddress;

  OrderCreateModel({
    this.order,
    this.orderItems,
    this.billingAddress,
    this.shippingAddress,
  });

  OrderCreateModel.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['orderItems'] != null) {
      orderItems = <OrderItem>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
      });
    }
    billingAddress = json['billingAddress'] != null
        ? IngAddress.fromJson(json['billingAddress'])
        : null;
    shippingAddress = json['shippingAddress'] != null
        ? IngAddress.fromJson(json['shippingAddress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (order != null) data['order'] = order!.toJson();
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    if (billingAddress != null) {
      data['billingAddress'] = billingAddress!.toJson();
    }
    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.toJson();
    }
    return data;
  }
}

class IngAddress {
  String? name;
  String? mobileNumber;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? streetAddress;

  IngAddress({
    this.name,
    this.mobileNumber,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.streetAddress,
  });

  IngAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNumber = json['mobile_number'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zip_code'];
    streetAddress = json['street_address'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name ?? '';
    data['mobile_number'] = mobileNumber ?? '';
    data['country'] = country ?? '';
    data['state'] = state ?? '';
    data['city'] = city ?? '';
    data['zip_code'] = zipCode ?? '';
    data['street_address'] = streetAddress ?? '';
    return data;
  }
}

class Order {
  String? vendorId;
  String? paymentMethod;
  String? shippingMethod;
  String? status;
  int? discount;
  int? ship;
  String? orderType;

  Order({
    this.vendorId,
    this.paymentMethod,
    this.shippingMethod,
    this.status,
    this.discount,
    this.ship,
    this.orderType,
  });

  Order.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    paymentMethod = json['payment_method'];
    shippingMethod = json['shipping_method'];
    status = json['status'];
    discount = json['discount'];
    ship = json['ship'];
    orderType = json['orderType'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['vendor_id'] = vendorId ?? '';
    data['payment_method'] = paymentMethod ?? '';
    data['shipping_method'] = shippingMethod ?? '';
    data['status'] = status ?? '';
    data['discount'] = discount ?? 0;
    data['ship'] = ship ?? 0;
    data['orderType'] = orderType ?? '';
    return data;
  }
}

class OrderItem {
  String? productId;
  int? quantity;
  int? price;

  OrderItem({
    this.productId,
    this.quantity,
    this.price,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId ?? '';
    data['quantity'] = quantity ?? 0;
    data['price'] = price ?? 0;
    return data;
  }
}
