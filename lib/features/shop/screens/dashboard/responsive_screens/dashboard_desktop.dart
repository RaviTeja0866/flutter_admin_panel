import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/order_status_graph.dart';
import '../widgets/weekly_sales.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text('Dashboard',
                  style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Obx(
                    () => RSDashboardCard(
                      stats: 25,
                      headingIcon: Iconsax.note,
                      headingIconColor: Colors.blue,
                      headingIconBgColor: Colors.blue.withOpacity(0.1),
                      title: 'sales total',
                      subTitle:
                          '₹${controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount).toStringAsFixed(2)}',
                    ),
                  )),
                  SizedBox(width: RSSizes.spaceBtwItems),
                  Expanded(
                      child: Obx(
                    () => RSDashboardCard(
                      stats: 45,
                      headingIcon: Iconsax.external_drive,
                      headingIconColor: RSColors.success,
                      headingIconBgColor: RSColors.success.withOpacity(0.1),
                      icon: Iconsax.arrow_down,
                      color: RSColors.error,
                      title: 'Average Order Value',
                      subTitle:
                          '₹${(controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) / controller.orderController.allItems.length).toStringAsFixed(2)}',
                    ),
                  )),
                  SizedBox(width: RSSizes.spaceBtwItems),
                  Expanded(
                      child: Obx(
                    () => RSDashboardCard(
                      stats: 25,
                      headingIcon: Iconsax.box,
                      headingIconColor: Colors.deepPurple,
                      headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                      title: 'Total Orders',
                      subTitle: controller.orderController.allItems.length.toString(),
                    ),
                  )),
                  SizedBox(width: RSSizes.spaceBtwItems),
                  Expanded(
                      child: Obx(
                    () => RSDashboardCard(
                      stats: 25,
                      headingIcon: Iconsax.user,
                      headingIconColor: Colors.deepOrange,
                      headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                      title: 'Visitors',
                      subTitle: controller.customerController.allItems.length
                          .toString(),
                    ),
                  )),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        /// Bar Graph
                        RSWeeklySalesGraph(),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        /// Orders
                        RSRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recent Orders',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              SizedBox(height: RSSizes.spaceBtwSections),
                              DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: RSSizes.spaceBtwSections),

                  /// Pie Chart
                  Expanded(
                    child: OrderStatusPieChart(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
