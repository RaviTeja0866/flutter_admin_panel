import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../constants/colors.dart';

class RSCircularLoader extends StatelessWidget {
  const RSCircularLoader(
      {super.key,
        this.foregroundColor = RSColors.white,
        this.backgroundColor = RSColors.primary
      });

  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RSSizes.lg),
      decoration: BoxDecoration(
        color: backgroundColor, // Background color of the loader
       shape: BoxShape.circle,
      ),
      child: Center(
        child: CircularProgressIndicator(color: foregroundColor, backgroundColor: Colors.transparent),
      )
    );
  }
}
