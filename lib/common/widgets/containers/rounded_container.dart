import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class RSRoundedContainer extends StatelessWidget {
  const RSRoundedContainer(
      {super.key,
        this.width,
        this.height,
        this.padding = const EdgeInsets.all(RSSizes.md),
        this.radius = RSSizes.cardRadiusLg,
        this.child,
        this.showShadow = true,
        this.showBorder = false,
        this.borderColor = RSColors.borderPrimary,
        this.backgroundColor = RSColors.white,
        this.margin, this.onTap});

  final double? width;
  final double? height;
  final double radius;
  final Widget? child;
  final bool showBorder;
  final bool showShadow;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder ? Border.all(color: borderColor) : null,
          boxShadow: [
            if(showShadow)
              BoxShadow(
                color: RSColors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
          ],
        ),
        child: child,
      ),
    );
  }
}
