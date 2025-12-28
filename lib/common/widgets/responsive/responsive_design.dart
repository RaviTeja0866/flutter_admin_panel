import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

///widget for displaying different layouts based on screen sizes
class RSResponsiveWidget extends StatelessWidget {
  const RSResponsiveWidget({super.key, required this.desktop, required this.tablet, required this.mobile});

  final Widget desktop;
  final Widget tablet;
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
        if (constraints.maxWidth >= RSSizes.desktopScreenSize) {
          return desktop;
        } else if (constraints.maxWidth <  RSSizes.desktopScreenSize && constraints.maxWidth >=  RSSizes.tabletScreenSize) {
          return tablet;
        } else {
          return mobile;
        }
      });
  }
}