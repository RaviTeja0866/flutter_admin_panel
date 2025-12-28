import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/all_coupons/table/data_table.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

class CouponMobileScreen extends StatelessWidget {
  const CouponMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Coupons', breadcrumbItems: ['Coupons']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Table Body
              RSRoundedContainer(
                child: Column(
                  children: [
                    RSTableHeader(
                      buttonText: 'Create New Coupon',
                      onPressed: () => Get.toNamed(RSRoutes.createCoupon),  // Navigate to the create coupon page
                      searchController: controller.searchController,
                      searchOnChanged: (query) => controller.searchQuery(query),  // Filter coupons by search query
                    ),
                    SizedBox(height: RSSizes.spaceBtwItems),

                    // Table displaying coupons
                    Obx(() {
                      if (controller.isLoading.value) {
                        return RSLoaderAnimation();  // Show loader animation when data is loading
                      }
                      return CouponTable();  // Custom table widget to display the list of coupons
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
