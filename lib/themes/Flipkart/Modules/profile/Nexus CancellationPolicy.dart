class CancellationPolicyResponse {
  final CancellationPolicyData? data;

  CancellationPolicyResponse({this.data});

  factory CancellationPolicyResponse.fromJson(Map<String, dynamic> json) {
    return CancellationPolicyResponse(
      data: json['data'] != null
          ? CancellationPolicyData.fromJson(json['data'])
          : null,
    );
  }
}

class CancellationPolicyData {
  final String id;
  final String vendorId;
  final String tabId;
  final String? title;
  final String content;
  final String? imageUrl;
  final String createdAt;
  final String updatedAt;

  CancellationPolicyData({
    required this.id,
    required this.vendorId,
    required this.tabId,
    this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CancellationPolicyData.fromJson(Map<String, dynamic> json) {
    return CancellationPolicyData(
      id: json['id'],
      vendorId: json['vendorId'],
      tabId: json['tabId'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
