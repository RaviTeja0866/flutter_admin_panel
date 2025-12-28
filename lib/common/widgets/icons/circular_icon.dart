import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class RSCircularIcon extends StatelessWidget {
  /// A Custom Circular Icon Widget with a background Color
  ///
  /// properties are
  ///
  /// Container [width], [height], & [backgroundColor].
  ///
  /// Icons's [size], [color], & [onPressed]
  const RSCircularIcon({
    super.key,
    this.width,
    this.height,
    this.size = RSSizes.lg,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? size, // Default to `size` if width is not provided
      height: height ?? size, // Default to `size` if height is not provided
      decoration: BoxDecoration(
        color: backgroundColor, // Apply background color
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          iconSize: size, // Adjust icon size for better fit
          padding: EdgeInsets.zero, // Remove default padding
          constraints: const BoxConstraints(), // Remove default constraints
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }
}
