import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(color: RSColors.iconPrimary, size: RSSizes.iconMd),
    actionsIconTheme: IconThemeData(color: RSColors.iconPrimary, size: RSSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: RSColors.black, fontFamily: 'Urbanist'),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: RSColors.dark,
    surfaceTintColor: RSColors.dark,
    iconTheme: IconThemeData(color: RSColors.black, size: RSSizes.iconMd),
    actionsIconTheme: IconThemeData(color: RSColors.white, size: RSSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: RSColors.white, fontFamily: 'Urbanist'),
  );
}