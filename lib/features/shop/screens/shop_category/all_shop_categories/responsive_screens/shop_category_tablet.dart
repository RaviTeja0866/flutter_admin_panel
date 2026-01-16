import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/shop_category/shop_category_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../utils/constants/enums.dart';
import '../table/data_table.dart';

class ShopCategoryTabletScreen extends StatelessWidget {
  const ShopCategoryTabletScreen({super.key});

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
                      RSTableHeader(
                        searchOnChanged: (query) => controller.searchQuery(query),

                        primaryButton: AdminScreenGuard(
                          permission: Permission.shopCategoryCreate,
                          behavior: GuardBehavior.disable,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(RSRoutes.createShopCategory),
                            child: const Text('Create New ShopCategory'),
                          ),
                        ),

                      ),
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
