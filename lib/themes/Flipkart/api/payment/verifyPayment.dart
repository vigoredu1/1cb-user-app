import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/utility/plugin_list.dart';

Future<bool> verifyPayment(String orderId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token')?.trim();

    if (token == null || token.isEmpty) {
      debugPrint('verifyPayment: missing auth token');
      return false;
    }

    final response = await http.put(
      Uri.parse('https://api.1clickbuilder.com/api/order/verify-payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'orderId': orderId,
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return false;
    }

    return _isVerificationSuccessful(decoded);
  } catch (error) {
    debugPrint('verifyPayment error: $error');
    return false;
  }
}

bool _isVerificationSuccessful(Map<String, dynamic> payload) {
  final error = payload['error'];
  if (error != null && error != false && error != '') {
    return false;
  }

  final candidates = <dynamic>[
    payload,
    payload['data'],
    payload['result'],
  ];

  for (final candidate in candidates) {
    if (candidate is! Map<String, dynamic>) {
      continue;
    }

    final bool? explicitBool = _readBoolean(candidate);
    if (explicitBool != null) {
      return explicitBool;
    }

    final String? status = _readStatus(candidate);
    if (status != null) {
      if (_successStatuses.contains(status)) {
        return true;
      }
      if (_failureStatuses.contains(status)) {
        return false;
      }
    }
  }

  return false;
}

bool? _readBoolean(Map<String, dynamic> data) {
  const keys = ['verified', 'success', 'isVerified', 'isPaid', 'paid'];
  for (final key in keys) {
    final value = data[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
  }
  return null;
}

String? _readStatus(Map<String, dynamic> data) {
  const keys = ['status', 'paymentStatus', 'payment_status', 'orderStatus'];
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim().toLowerCase();
    }
  }
  return null;
}

const Set<String> _successStatuses = {
  'paid',
  'success',
  'successful',
  'verified',
  'completed',
  'captured',
};

const Set<String> _failureStatuses = {
  'failed',
  'failure',
  'pending',
  'processing',
  'unpaid',
  'cancelled',
  'canceled',
};
