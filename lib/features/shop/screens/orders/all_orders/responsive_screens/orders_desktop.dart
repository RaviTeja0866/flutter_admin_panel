import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/all_orders/table/data_table.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';

class OrdersDesktopScreen extends StatelessWidget {
  const OrdersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Orders', breadcrumbItems: ['Orders']),
              SizedBox(height: RSSizes.spaceBtwSections),

              RSRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    RSTableHeader(
                      onPressed: () => Get.toNamed(RSRoutes.exchange),
                      buttonText: "Exchange",

                      showSecondButton: true,                 // enable
                      secondButtonOnPressed: () => Get.toNamed(RSRoutes.returns),
                      secondButtonText: "Return",

                      searchController: controller.searchController,
                      searchOnChanged: controller.searchQuery,
                    ),


                    SizedBox(height: RSSizes.spaceBtwItems),

                      //Table
                    Obx(
                        () {
                          if(controller.isLoading.value) return RSLoaderAnimation();

                          return OrderTable();
                        }
                    )
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
