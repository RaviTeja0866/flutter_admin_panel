import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/all_brands/responsive_screens/brands_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/all_brands/responsive_screens/brands_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/all_brands/responsive_screens/brands_tablet.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(desktop: BrandsDesktopScreen(), tablet: BrandsTabletScreen(), mobile: BrandsMobileScreen());
  }
}
