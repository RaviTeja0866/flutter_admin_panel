
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/responsive_screens/create_shop_category_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/responsive_screens/create_shop_category_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/responsive_screens/create_shop_category_tablet.dart';

class CreateShopCategoryScreen extends StatelessWidget {
  const CreateShopCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: CreateShopCategoryDesktopScreen(),
      tablet: CreateShopCategoryTabletScreen(),
      mobile: CreateShopCategoryMobileScreen(),
    );
  }
}
