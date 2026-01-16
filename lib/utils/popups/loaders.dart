import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

class RSLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  // -------------------------------
  // Base Toast Snackbar
  // -------------------------------
  static _showToast({
    required String message,
    required Color color,
    required IconData icon,
    int duration = 3,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox(),
      messageText: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(Get.context!)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 20),
      backgroundColor: color,
      borderRadius: 30,
      duration: Duration(seconds: duration),
      isDismissible: true,
      shouldIconPulse: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }


  // -------------------------------
  // Success Toast
  // -------------------------------
  static success({required String message, int duration = 3}) {
    _showToast(
      message: message,
      color: RSColors.success,
      icon: Iconsax.check,
      duration: duration,
    );
  }

  // -------------------------------
  // Warning Toast
  // -------------------------------
  static warning({required String message, int duration = 3}) {
    _showToast(
      message: message,
      color: RSColors.warning,
      icon: Iconsax.warning_2,
      duration: duration,
    );
  }

  // -------------------------------
  // Error Toast
  // -------------------------------
  static error({required String message, int duration = 3}) {
    _showToast(
      message: message,
      color: RSColors.error,
      icon: Iconsax.warning_2,
      duration: duration,
    );
  }

  // -------------------------------
  // Info Toast
  // -------------------------------
  static info({required String message, int duration = 3}) {
    _showToast(
      message: message,
      color: RSColors.info,
      icon: Iconsax.info_circle,
      duration: duration,
    );
  }
}
