import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/all_products/responsive_screens/product_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/all_products/responsive_screens/product_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/all_products/responsive_screens/product_tablet.dart';

import '../../../controllers/product/product_controller.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return RSSiteTemplate(
        desktop: ProductDesktopScreen(),
        tablet: ProductTabletScreen(),
        mobile: ProductMobileScreen());
  }
}
