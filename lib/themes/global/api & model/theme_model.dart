class ThemeModel {
  Meta meta;
  dynamic error;
  Data data;

  ThemeModel({
    required this.meta,
    required this.error,
    required this.data,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      meta: Meta.fromJson(json['meta']),
      error: json['error'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String logoId;
  String vendorId;
  String logoUrl;
  String email;
  String mobile;
  String address;
  dynamic copyRights;
  String deliveryCharges;
  DateTime createdAt;
  DateTime updatedAt;
  String currentTheme;

  Data({
    required this.logoId,
    required this.vendorId,
    required this.logoUrl,
    required this.email,
    required this.mobile,
    required this.address,
    required this.copyRights,
    required this.deliveryCharges,
    required this.createdAt,
    required this.updatedAt,
    required this.currentTheme,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      logoId: json['logo_id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
      copyRights: json['copy_rights'],
      deliveryCharges: json['delivery_charges'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      currentTheme: json['current_theme'] ?? '',
    );
  }
}

class Meta {
  dynamic paginationInfo;

  Meta({required this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      paginationInfo: json['pagination_info'],
    );
  }
}
