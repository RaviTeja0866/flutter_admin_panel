
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/all_shop_categories/responsive_screens/shop_category_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/all_shop_categories/responsive_screens/shop_category_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/all_shop_categories/responsive_screens/shop_category_tablet.dart';

class ShopCategoryScreen extends StatelessWidget {
  const ShopCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: ShopCategoryDesktopScreen(),
      tablet: ShopCategoryTabletScreen(),
      mobile: ShopCategoryMobileScreen(),
    );
  }
}
