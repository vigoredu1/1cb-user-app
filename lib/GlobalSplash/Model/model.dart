class LogoModel {
  final String? logoId;
  final String? vendorId;
  final String? logoUrl;
  final String? email;
  final String? mobile;
  final String? address;
  final String? copyRights;
  final String? deliveryCharges;
  final String? createdAt;
  final String? updatedAt;
  final String? currentTheme;
  final String? currentMobileTheme;
  final String? appName;

  LogoModel({
    this.logoId,
    this.vendorId,
    this.logoUrl,
    this.email,
    this.mobile,
    this.address,
    this.copyRights,
    this.deliveryCharges,
    this.createdAt,
    this.updatedAt,
    this.currentTheme,
    this.currentMobileTheme,
    this.appName,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    String? asString(dynamic value) => value?.toString();

    return LogoModel(
      logoId: asString(json['logoId']),
      vendorId: asString(json['vendorId']),
      logoUrl: asString(json['logoUrl']),
      email: asString(json['email']),
      mobile: asString(json['mobile']),
      address: asString(json['address']),
      copyRights: asString(json['copyRights']),
      deliveryCharges: asString(json['deliveryCharges']),
      createdAt: asString(json['created_at']),
      updatedAt: asString(json['updated_at']),
      currentTheme: asString(json['currentTheme']),
      currentMobileTheme: asString(json['currentMobileTheme']),
      appName: asString(json['appName'] ?? json['data.appName']),
    );
  }
}
