package com.mab.one_click_builder

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.mab.one_click_builder/phonepe_intent"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "launchPhonePeIntent" -> {
                    val paymentUrl = call.argument<String>("paymentUrl")
                    result.success(launchPhonePeIntent(paymentUrl))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun launchPhonePeIntent(paymentUrl: String?): Boolean {
        if (paymentUrl.isNullOrBlank()) {
            return false
        }

        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(paymentUrl)).apply {
                `package` = PHONEPE_PACKAGE_NAME
                addCategory(Intent.CATEGORY_BROWSABLE)
            }

            if (intent.resolveActivity(packageManager) == null) {
                false
            } else {
                startActivity(intent)
                true
            }
        } catch (_: Exception) {
            false
        }
    }

    companion object {
        private const val PHONEPE_PACKAGE_NAME = "com.phonepe.app"
    }
}
