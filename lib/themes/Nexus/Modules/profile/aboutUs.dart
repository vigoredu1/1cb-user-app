class AboutResponse {
  final String title;
  final String content;

  AboutResponse({
    required this.title,
    required this.content,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      title: json['data']['title'] ?? '',
      content: json['data']['content'] ?? '',
    );
  }
}
