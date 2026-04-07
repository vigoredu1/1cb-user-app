class VendorIdModel {
   String? vendorId;
   String? logoUrl;

  VendorIdModel({ this.vendorId,  this.logoUrl});
      VendorIdModel.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendorId'];
    logoUrl = json['logoUrl'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendorId'] = vendorId ?? '';
    data['logoUrl'] = logoUrl ?? '';


    return data;
  }
}



