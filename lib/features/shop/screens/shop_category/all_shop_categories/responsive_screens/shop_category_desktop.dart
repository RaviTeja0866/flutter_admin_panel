
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/all_shop_categories/table/data_table.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../../../../controllers/shop_category/shop_category_controller.dart';

class ShopCategoryDesktopScreen extends StatelessWidget {
  const ShopCategoryDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShopCategoryController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Shop Category', breadcrumbItems: ['Shop  Category']),
              SizedBox(height: RSSizes.spaceBtwItems),

              //Table Body
              Obx(() {
                // show Loader
                if(controller.isLoading.value) return RSLoaderAnimation();

                return RSRoundedContainer(
                  child: Column(
                    children: [
                      RSTableHeader(buttonText: 'Create New ShopCategory', onPressed: () => Get.toNamed(RSRoutes.createShopCategory)),
                      SizedBox(height: RSSizes.spaceBtwItems),

                      // Table
                      ShopCategoryTable(),
                    ],
                  ),
                );
              })


            ],
          ),
        ),
      ),
    );
  }
}
