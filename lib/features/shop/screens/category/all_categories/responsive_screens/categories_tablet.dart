import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../table/data_table.dart';

class CategoriesTabletScreen extends StatelessWidget {
  const CategoriesTabletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller  = Get.put(CategoryController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Categories', breadcrumbItems: ['Categories']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Table Body
              // Show Loader
              RSRoundedContainer(
                child: Column(
                  children: [
                    RSTableHeader(
                      searchOnChanged: (query) => controller.searchQuery(query),

                      primaryButton: AdminScreenGuard(
                        permission: Permission.categoryCreate,
                        behavior: GuardBehavior.disable,
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(RSRoutes.createCategory),
                          child: const Text('Create New Category'),
                        ),
                      ),

                    ),
                    SizedBox(height: RSSizes.spaceBtwItems),

                    // Table
                    Obx(() {
                      if(controller.isLoading.value)  return RSLoaderAnimation();
                      return CategoryTable();
                    }),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
