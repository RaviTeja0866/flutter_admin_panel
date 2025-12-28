import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../common/widgets/containers/circular_container.dart';
import '../../../../../utils/constants/enums.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Status', style: Theme
              .of(context)
              .textTheme
              .headlineSmall),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Graph
          Obx(
                () =>
            controller.orderStatusData.isNotEmpty ? SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: controller.orderStatusData.entries.map((entry) {
                    final status = entry.key;
                    final count = entry.value;

                    return PieChartSectionData(
                      radius: 100,
                      title: count.toString(),
                      value: count.toDouble(),
                      color: RSHelperFunctions.getOrderStatusColor(status),
                      titleStyle: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // Handle Touch events here if needed
                    },
                    enabled: true,
                  ),
                ),
              ),
            )
                : const SizedBox(height: 400, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [RSLoaderAnimation()])),
          ),

          // Show status and Color Meta
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => DataTable(columns: const [
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Orders')),
                DataColumn(label: Text('Total')),
              ],
                rows: controller.orderStatusData.entries.map((entry) {
                  final OrderStatus status = entry.key;
                  final int count = entry.value;
                  final totalAmount = controller.totalAmounts[status] ?? 0;
                  return DataRow(cells: [
                    DataCell(
                        Row(
                          children: [
                            RSCircularContainer(width: 20,
                                height: 20,
                                backgroundColor: RSHelperFunctions
                                    .getOrderStatusColor(status)),
                            Expanded(child: Text(
                                controller.getDisplayStatusName(status))),
                          ],
                        )
                    ),
                    DataCell(Text(count.toString())),
                    DataCell(Text('₹${totalAmount.toStringAsFixed(2)}')),
                  ]);
                }).toList(),
              
              ),
            ),
          )
        ],
      ),
    );
  }
}
