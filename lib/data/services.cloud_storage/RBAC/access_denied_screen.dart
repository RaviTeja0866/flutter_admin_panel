import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: RSColors.white, // light admin background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Large hero image
              SizedBox(
                height: size.height * 0.55, // 👈 controls dominance
                child: Image.asset(
                  'assets/images/content/403.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: RSSizes.defaultSpace),

              // 🔹 Icon + Title (same line)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 26,
                  ),
                  SizedBox(width: RSSizes.sm),
                  Text(
                    'Unauthorized',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 🔹 Description
              const Text(
                'The page you’re trying to access has restricted access.\n'
                    'Please refer to your system administrator.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: RSSizes.defaultSpace),

              // 🔹 CTA
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Go Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
