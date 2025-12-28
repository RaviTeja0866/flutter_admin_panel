import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';

class RSLoaderAnimation extends StatelessWidget {
  const RSLoaderAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔒 ABSOLUTE BLOCK FOR WEB
    if (kIsWeb) {
      return const Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      );
    }

    // ✅ Lottie ONLY for mobile / desktop
    return Center(
      child: Lottie.asset(
        RSImages.defaultLoaderAnimation,
        height: 200,
        width: 200,
      ),
    );
  }
}
