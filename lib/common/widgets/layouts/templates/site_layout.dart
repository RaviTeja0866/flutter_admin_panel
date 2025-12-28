import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/responsive/responsive_design.dart';
import 'package:roguestore_admin_panel/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:roguestore_admin_panel/common/widgets/responsive/screens/tablet_layout.dart';

import '../../responsive/screens/desktop_layout.dart';

///Template For overall Site Layout, responsive to different screen sizes
class RSSiteTemplate extends StatelessWidget {
  const RSSiteTemplate({super.key, this.desktop, this.tablet, this.mobile, this.useLayout = true, });

  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;

  //Flag to determine whether to use the Layout
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RSResponsiveWidget(
        desktop: useLayout ? DesktopLayout(body: desktop) : desktop ?? Container(),
        tablet: useLayout ? TabletLayout(body: tablet ?? desktop): tablet ?? desktop ?? Container(),
        mobile: useLayout ? MobileLayout(body: mobile ?? desktop): mobile ?? desktop ?? Container(),
      ),
    );
  }
}
