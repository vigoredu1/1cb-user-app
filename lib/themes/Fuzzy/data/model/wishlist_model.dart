class WishlistModel {
  Meta? meta;
  WishlistError? error;
  dynamic data;

  WishlistModel({this.meta, this.error, this.data});

  WishlistModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    error = json['error'] != null ? WishlistError.fromJson(json['error']) : null;
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (meta != null) json['meta'] = meta!.toJson();
    if (error != null) json['error'] = error!.toJson();
    json['data'] = data;
    return json;
  }
}
class WishlistError {
  String? error;
  String? message;

  WishlistError({this.error, this.message});

  WishlistError.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['error'] = error ?? '';
    json['message'] = message ?? '';
    return json;
  }
}
class Meta {
  dynamic paginationInfo;

  Meta({this.paginationInfo});

  Meta.fromJson(Map<String, dynamic> json) {
    paginationInfo = json['paginationInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['paginationInfo'] = paginationInfo;
    return json;
  }
}
