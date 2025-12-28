import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: RSColors.darkGrey,
    suffixIconColor: RSColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: RSSizes.fontSizeMd, color: RSColors.textPrimary, fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(fontSize: RSSizes.fontSizeSm, color: RSColors.textSecondary, fontFamily: 'Urbanist'),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(color: RSColors.textSecondary, fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.borderPrimary),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.borderPrimary),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.borderSecondary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: RSColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: RSColors.darkGrey,
    suffixIconColor: RSColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: RSSizes.fontSizeMd, color: RSColors.white, fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(fontSize: RSSizes.fontSizeSm, color: RSColors.white, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(color: RSColors.white.withOpacity(0.8), fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RSColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: RSColors.error),
    ),
  );
}
