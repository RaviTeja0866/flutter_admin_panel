import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/edit_shop_category/widgets/edit_shop_category_form.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../controllers/shop_category/edit_shop_category_controller.dart';

class EditShopCategoryTabletScreen extends StatelessWidget {
  const EditShopCategoryTabletScreen({
    super.key,
    required this.shopCategoryId,
  });

  final String shopCategoryId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditShopCategoryController());

    // 🔑 Load category once (safe on rebuild)
    controller.loadCategory(shopCategoryId);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RSBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update ShopCategory',
                breadcrumbItems: [
                  RSRoutes.shopCategory,
                  'Update ShopCategory',
                ],
                onBack: () {
                  Get.offNamed(RSRoutes.shopCategory);
                },

              ),

              SizedBox(height: RSSizes.spaceBtwSections),

              Obx(() {
                if (controller.category.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return EditShopCategoryForm(
                  shopCategory: controller.category.value!,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
