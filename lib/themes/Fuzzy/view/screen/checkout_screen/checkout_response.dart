class CheckoutResponseModel {
  String? error;
  CheckoutData? data;

  CheckoutResponseModel({this.error, this.data});

  CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? CheckoutData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final dataMap = <String, dynamic>{};
    dataMap['error'] = error;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class CheckoutData {
  String? message;
  String? paymentSessionId;
  String? orderId;

  CheckoutData({this.message, this.paymentSessionId, this.orderId});

  CheckoutData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    paymentSessionId = json['paymentSessionId'];
    orderId = json['orderId'];
    print("orderId");
    print(paymentSessionId);
    print(orderId);
    print(message);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message ?? '',
      'paymentSessionId': paymentSessionId,
      'orderId': orderId ?? '',
    };
  }
}
