import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/all_size_guide/responisve_screens/size_guide_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/all_size_guide/responisve_screens/size_guide_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/all_size_guide/responisve_screens/size_guide_tablet.dart';

class SizeGuideScreen extends StatelessWidget {
  const SizeGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: SizeGuideDesktopScreen(),
      tablet: SizeGuideTabletScreen(),
      mobile: SizeGuideMobileScreen(),
    );
  }
}
