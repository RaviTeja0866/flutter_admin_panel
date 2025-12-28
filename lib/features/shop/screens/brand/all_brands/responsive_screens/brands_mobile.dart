import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../../../../controllers/brand/brand_controller.dart';
import '../table/data_table.dart';

class BrandsMobileScreen extends StatelessWidget {
  const BrandsMobileScreen({super.key});

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
                    RSTableHeader(buttonText: 'Create New Brand', onPressed: () => Get.toNamed(RSRoutes.createBrand)),
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
