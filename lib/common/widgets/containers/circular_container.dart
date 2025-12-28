import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class RSCircularContainer extends StatelessWidget {
  const RSCircularContainer({
    super.key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding,
    this.margin,
    this.backgroundColor = RSColors.white,
    this.showBorder = false,
    this.borderColor = RSColors.borderPrimary,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double radius;
  final bool showBorder;
  final Color borderColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
