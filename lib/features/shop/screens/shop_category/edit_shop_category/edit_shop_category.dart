import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/models/shop_category.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/edit_shop_category/responsive_screens/edit_shop_category_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/edit_shop_category/responsive_screens/edit_shop_category_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/edit_shop_category/responsive_screens/edit_shop_category_tablet.dart';

class EditShopCategory extends StatelessWidget {
  const EditShopCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final shopCategory = Get.arguments;
    return RSSiteTemplate(
      desktop: EditShopCategoryDesktopScreen(shopCategory: shopCategory),
      tablet: EditShopCategoryTabletScreen(shopCategory: shopCategory),
      mobile: EditShopCategoryMobileScreen(shopCategory: shopCategory),
    );
  }
}
