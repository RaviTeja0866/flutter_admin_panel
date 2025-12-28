import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class ProductTabletScreen extends StatelessWidget {
  const ProductTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    RSTableHeader(buttonText: 'Add Product', onPressed: () => Get.toNamed(RSRoutes.createProduct)),
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
