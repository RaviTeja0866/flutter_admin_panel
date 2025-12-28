import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/all_returns/responsive_screens/returns_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/all_returns/responsive_screens/returns_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/all_returns/responsive_screens/returns_tablet.dart';

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: ReturnsDesktopScreen(),
      tablet: ReturnsTabletScreen(),
      mobile: ReturnsMobileScreen(),
    );
  }
}
