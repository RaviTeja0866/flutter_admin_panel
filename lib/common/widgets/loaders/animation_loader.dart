import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// A widget for displaying an animated loading indicator with optional text and action button
class RSAnimationLoaderWidget extends StatelessWidget {
  /// Default constructor for the RSAnimationLoaderWidget
  ///
  ///Parameters:
  /// -Text: the text to  be displayed below the animation.
  /// -Animation: the path to Lottie animations file.
  /// -ShowAction: whether to show an actionButton below the text.
  /// -onActionPressed: Callback function to br executed when the action button is pressed.
  const RSAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.height,
    this.width,
    this.style
  });

  final String text;
  final TextStyle? style;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;

        return Center(
          child: SingleChildScrollView( // 🔑 prevents overflow
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  animation,
                  height: height ?? maxHeight * 0.5, // 🔑 bounded
                  width: width,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: RSSizes.defaultSpace),
                Text(
                  text,
                  style: style ?? Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (showAction) ...[
                  const SizedBox(height: RSSizes.defaultSpace),
                  SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      onPressed: onActionPressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: RSColors.dark,
                      ),
                      child: Text(
                        actionText!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: RSColors.light),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

}
