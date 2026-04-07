import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/GlobalSplash/Model/model.dart';

class LogoService {
  static const String _baseUrl = 'https://api.1clickbuilder.com/api/logo/logo/';

  static Future<LogoModel> getLogoData({
    http.Client? client,
    String domain = 'sandhyasales.com',
  }) async {
    final url = Uri.parse('$_baseUrl$domain');
    final http.Client httpClient = client ?? http.Client();

    try {
      final response = await httpClient.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch logo data (${response.statusCode})');
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Unexpected logo API response');
      }

      final dynamic data = decoded['data'];
      final Map<String, dynamic> payload =
          data is Map<String, dynamic> ? data : decoded;

      return LogoModel.fromJson(payload);
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }
}
