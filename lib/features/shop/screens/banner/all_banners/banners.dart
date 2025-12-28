import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/all_banners/responsive_screens/banner_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/all_banners/responsive_screens/banner_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/all_banners/responsive_screens/banner_tablet.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: BannerDesktopScreen(),
        tablet: BannerTabletScreen(),
        mobile: BannerMobileScreen(),
    );
  }
}
