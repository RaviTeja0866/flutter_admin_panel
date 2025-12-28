import 'package:flutter/material.dart';

class RSSectionHeading extends StatelessWidget {
  const RSSectionHeading({super.key, this.textColor, this.rightSideWidget, required this.title,
  });

  final Color? textColor;
  final Widget? rightSideWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
        style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
        if (rightSideWidget!= null) rightSideWidget!
      ],
    );
  }
}
