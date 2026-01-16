import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_mobile.dart';

import '../../../controllers/product/edit_product_controller.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = Get.parameters['id'];

    if (productId == null) {
      return const Scaffold(
        body: Center(child: Text('Invalid Product ID')),
      );
    }

    final controller = Get.put(EditProductController());
    controller.loadProduct(productId);

    return const RSSiteTemplate(
      desktop: EditProductDesktopScreen(),
      tablet: EditProductMobileScreen(),
      mobile: EditProductMobileScreen(),
    );
  }
}
