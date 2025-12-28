import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/icons/circular_icon.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/dashboard/dashboard_controller.dart';

class RSWeeklySalesGraph extends StatelessWidget {
  const RSWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RSCircularIcon(
                  icon: Iconsax.graph,
                backgroundColor: Colors.brown.withOpacity(0.1),
                color: Colors.brown,
                size: RSSizes.md,
              ),
              SizedBox(width: RSSizes.spaceBtwItems),
              Text('Weekly Sales', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Graph
          Obx(
            () => controller.weeklySales.isNotEmpty
                ?  SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                    titlesData: buildFlTitlesData(controller.weeklySales),
                    borderData: FlBorderData(
                        show: true,
                        border: Border(
                          top: BorderSide.none,
                          right: BorderSide.none,
                        )),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      horizontalInterval: 200,
                    ),
                    barGroups: controller.weeklySales
                        .asMap()
                        .entries
                        .map((entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            width: 30,
                            toY: entry.value,
                            color: RSColors.primary,
                            borderRadius: BorderRadius.circular(RSSizes.sm),
                          ),
                        ]))
                        .toList(),
                    groupsSpace: RSSizes.spaceBtwItems,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => RSColors.secondary),
                      touchCallback: RSDeviceUtils.isDesktopScreen(context) ? (barTouchEvent, barTouchResponse) {} : null,
                    )
                ),
              ),
            )
                : SizedBox(height: 400, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [RSLoaderAnimation()])),
          ),
        ],
      ),
    );
  }
  FlTitlesData buildFlTitlesData(List <double> weeklySales) {
    //calculate step height for the left pricing
    double maxOrder = weeklySales.reduce((a,b) => a > b ? a: b).toDouble();
    double stepHeight = (maxOrder / 10).ceilToDouble();

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta){
                // Map Index to desired day of the Week
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

                // Calculate the index and ensure it wraps around for the correct Day
                final index= value.toInt() % days.length;

                // Get the day corresponding to the calculated index
                final day = days[index];

                return SideTitleWidget(axisSide: AxisSide.bottom, space: 0,child: Text(day));
              }
          )
      ),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: stepHeight <= 0 ? 500 :stepHeight, reservedSize: 50)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
