import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: RSColors.light,
      backgroundColor: RSColors.primary,
      disabledForegroundColor: RSColors.darkGrey,
      disabledBackgroundColor: RSColors.buttonDisabled,
      side: const BorderSide(color: RSColors.primary),
      padding: const EdgeInsets.symmetric(vertical: RSSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RSSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: RSColors.textWhite, fontWeight: FontWeight.w500, fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: RSColors.light,
      backgroundColor: RSColors.primary,
      disabledForegroundColor: RSColors.darkGrey,
      disabledBackgroundColor: RSColors.darkerGrey,
      side: const BorderSide(color: RSColors.primary),
      padding: const EdgeInsets.symmetric(vertical: RSSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RSSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: RSColors.textWhite, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );
}
