import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../controllers/exchange/exchnage_detail_controller.dart';
import '../../../../models/exchange_model.dart';

class ExchangeOrderTimeline extends StatelessWidget {
  const ExchangeOrderTimeline({super.key, required this.exchange});

  final ExchangeRequestModel exchange;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExchangeDetailController());
    controller.exchange.value = exchange;

    return Obx(() {
      final steps = controller.exchange.value.steps;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Exchange Timeline',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: RSSizes.spaceBtwSections),
            itemBuilder: (context, index) {
              final step = steps[index];
              final isCompleted = step.timestamp != null;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indicator
                  Column(
                    children: [
                      Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                          color: isCompleted ? RSColors.primary : RSColors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (index != steps.length - 1)
                        Container(
                          height: 50,
                          width: 2,
                          color: RSColors.grey.withOpacity(0.4),
                        )
                    ],
                  ),

                  SizedBox(width: RSSizes.spaceBtwItems),

                  // Step Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title,
                            style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(height: 4),
                        Text(step.description,
                            style: Theme.of(context).textTheme.bodySmall),
                        SizedBox(height: 6),
                        Text(
                          step.timestamp != null
                              ? _formatDate(step.timestamp!)
                              : 'Pending',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: isCompleted
                                      ? RSColors.primary
                                      : RSColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      );
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
