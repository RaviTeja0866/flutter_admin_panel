import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/customer/all_customers/table/data_table.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class CustomerDesktopScreen extends StatelessWidget {
  const CustomerDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Customers',
                breadcrumbItems: ['Customers'],
                returnToPreviousScreen: true,
                onBack: () {
                  Get.offNamed(RSRoutes.customers);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              RSRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    RSTableHeader(
                      showLeftWidget: false,
                      searchController: controller.searchController,
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    SizedBox(height: RSSizes.spaceBtwItems),

                    Obx(() {
                      if (controller.isLoading.value)
                        return RSLoaderAnimation();
                      return CustomerTable();
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
