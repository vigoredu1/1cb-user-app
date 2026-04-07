import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PhonePeIntentLauncher {
  static const MethodChannel _channel = MethodChannel(
    'com.mab.one_click_builder/phonepe_intent',
  );

  static Future<bool> launch(String paymentUrl) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    try {
      final launched = await _channel.invokeMethod<bool>(
        'launchPhonePeIntent',
        <String, dynamic>{'paymentUrl': paymentUrl},
      );
      return launched ?? false;
    } on PlatformException catch (error) {
      debugPrint('PhonePe intent launch failed: $error');
      return false;
    }
  }
}
