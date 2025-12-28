import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? message,
  Widget? customContent,                       // ← ADDED
  required String positiveButtonText,
  required String negativeButtonText,
  required VoidCallback onPositivePressed,
  required VoidCallback onNegativePressed,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    pageBuilder: (_, __, ___) => const SizedBox(),
    transitionBuilder: (context, animation, secondary, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Opacity(
          opacity: animation.value,
          child: Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RSSizes.borderRadiusMd),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    // MESSAGE OR CUSTOM CONTENT
                    if (customContent != null) customContent!,
                    if (customContent == null && message != null)
                      Text(message,
                          style: Theme.of(context).textTheme.bodyMedium),

                    SizedBox(height: 24),

                    // BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: onNegativePressed,
                          child: Text(
                            negativeButtonText,
                            style: TextStyle(
                              color: RSColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: onPositivePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RSColors.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: Text(
                            positiveButtonText,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
  );
}
