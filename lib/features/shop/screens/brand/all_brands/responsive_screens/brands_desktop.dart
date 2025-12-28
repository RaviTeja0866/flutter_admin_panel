import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class BrandsDesktopScreen extends StatelessWidget {
  const BrandsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BreadCrumbs
            RSBreadcrumbsWithHeading(heading: 'Brands', breadcrumbItems: ['Brands']),
            SizedBox(height: RSSizes.spaceBtwSections),

            // Table Body
            RSRoundedContainer(
              child: Column(
                children: [
                  // Table Header
                  RSTableHeader(
                      buttonText: 'Create New Brand',
                      onPressed: () => Get.toNamed(RSRoutes.createBrand),
                      searchOnChanged: (query) =>controller.searchQuery(query)),
                  SizedBox(height: RSSizes.spaceBtwItems),

                  // Table
                    Obx(() {
                      //show loader
                      if(controller.isLoading.value) return RSLoaderAnimation();
                     return BrandTable();
                    }),
                ],
              ),
            )
          ],
        ),
        ),
      ),
    );
  }
}
