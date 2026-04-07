class PageServiceModel {
  String? id;
  String? vendorId;
  String? tabId;
  String? title;
  String? content;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  PageServiceModel({
    this.id,
    this.vendorId,
    this.tabId,
    this.title,
    this.content,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PageServiceModel.fromJson(Map<String, dynamic> json) {
    return PageServiceModel(
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
