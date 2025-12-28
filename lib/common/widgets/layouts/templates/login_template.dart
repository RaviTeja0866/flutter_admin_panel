import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/spacing_styles.dart';

//Template for the login layout
class RSLoginTemplate extends StatelessWidget {
  const RSLoginTemplate({
    super.key, required this.child,
  });

  // The widget to be displayed inside the login template
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Container(
            padding: RSSpacingStyle.paddingWithAppBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RSSizes.cardRadiusLg),
              color: RSHelperFunctions.isDarkMode(context) ? RSColors.black : Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
