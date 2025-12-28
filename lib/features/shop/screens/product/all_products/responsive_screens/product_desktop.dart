import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/all_products/table/data_table.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';

class ProductDesktopScreen extends StatelessWidget {
  const ProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
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
              Obx( () {
                //Show Loader
                if(controller.isLoading.value)  return RSLoaderAnimation();

                 return RSRoundedContainer(
                  child: Column(
                    children: [
                      RSTableHeader(buttonText: 'Add Product', onPressed: () => Get.toNamed(RSRoutes.createProduct), searchOnChanged: (query) => controller.searchQuery(query),),
                      SizedBox(height: RSSizes.spaceBtwItems),

                      // Table
                     ProductTable(),
                    ],
                  ),
                );},
              ),
            ],
          ),

        ),
      ),
    );
  }
}
