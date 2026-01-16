import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../table/data_table.dart';

class CouponTabletScreen extends StatelessWidget {
  const CouponTabletScreen({super.key});

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
                      searchOnChanged: (query) => controller.searchQuery(query),

                      primaryButton: AdminScreenGuard(
                        permission: Permission.couponCreate,
                        behavior: GuardBehavior.disable,
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(RSRoutes.createCoupon),
                          child: const Text('Create New Coupon'),
                        ),
                      ),

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
