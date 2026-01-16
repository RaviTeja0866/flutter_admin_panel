import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_controller.dart';
import '../table/data_table.dart';

class ProductMobileScreen extends StatelessWidget {
  const ProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Products', breadcrumbItems: ['Products']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Table Body
              RSRoundedContainer(
                child: Column(
                  children: [
                    RSTableHeader(
                      searchOnChanged: (query) => controller.searchQuery(query),

                      primaryButton: AdminScreenGuard(
                        permission: Permission.productCreate,
                        behavior: GuardBehavior.disable,
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(RSRoutes.createProduct),
                          child: const Text('Add Product'),
                        ),
                      ),

                    ),
                    SizedBox(height: RSSizes.spaceBtwItems),

                    // Table
                    ProductTable(),
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
