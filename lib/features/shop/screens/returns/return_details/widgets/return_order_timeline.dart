import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../controllers/returns/reuturn_detail_controller.dart';
import '../../../../models/return_model.dart';

class ReturnTimeline extends StatelessWidget {
  const ReturnTimeline({super.key, required this.returnOrder});

  final ReturnModel returnOrder;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReturnDetailController());
    controller.returnOrder.value = returnOrder;

    return Obx(() {
      final data = controller.returnOrder.value;

      final steps = [
        _TimelineStep("Requested", "Customer submitted return request", data.requestDate),
        _TimelineStep("Approved", "Return approved by admin", data.approvedAt),
        _TimelineStep("Pickup Scheduled", "Pickup scheduled with courier", data.pickupScheduledAt),
        _TimelineStep("Picked Up", "Return item picked from customer", data.pickedUpAt),
        _TimelineStep("Received", "Return item received at warehouse", data.receivedAt),
        _TimelineStep("Refunded", "Refund processed", data.refundedAt),
        _TimelineStep("Completed", "Return request completed", data.completedAt),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Return Timeline',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),

          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (_, __) => SizedBox(height: RSSizes.spaceBtwSections),
            itemBuilder: (context, index) {
              final step = steps[index];
              final isCompleted = step.timestamp != null;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------
                  // INDICATOR + CONNECTOR
                  // ------------------------------------------
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
                        ),
                    ],
                  ),

                  SizedBox(width: RSSizes.spaceBtwItems),

                  // ------------------------------------------
                  // CONTENT
                  // ------------------------------------------
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
                              ? _format(step.timestamp!)
                              : "Pending",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                            color: isCompleted
                                ? RSColors.primary
                                : RSColors.grey,
                          ),
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

  String _format(DateTime date) {
    return "${date.day}-${date.month}-${date.year}   "
        "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}

class _TimelineStep {
  final String title;
  final String description;
  final DateTime? timestamp;

  _TimelineStep(this.title, this.description, this.timestamp);
}
