import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/returns/returns_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/return_model.dart';

class ReturnOrderInfo extends StatelessWidget {
  const ReturnOrderInfo({super.key, required this.returnOrder});

  final ReturnModel returnOrder;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReturnController());
    controller.returnStatus.value = returnOrder.status;

    return RSRoundedContainer(
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Return Information',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),

          Row(
            children: [
              // DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Requested On'),
                    Text(
                      returnOrder.formattedOrderDate,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // ITEMS (Quantity)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity'),
                    Text(
                      '${returnOrder.quantity} Item(s)',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // STATUS DROPDOWN
              Expanded(
                flex: RSDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Return Status'),
                    Obx(() {
                      if (controller.statusLoader.value) {
                        return RSShimmerEffect(
                            width: double.infinity, height: 55);
                      }

                      return RSRoundedContainer(
                        radius: RSSizes.cardRadiusSm,
                        padding: const EdgeInsets.symmetric(
                            horizontal: RSSizes.sm, vertical: 0),
                        backgroundColor:
                        RSHelperFunctions.getReturnStatusColor(
                            controller.returnStatus.value)
                            .withOpacity(0.1),
                        child: DropdownButton<ReturnStatus>(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          value: controller.returnStatus.value,
                          onChanged: (ReturnStatus? newValue) {
                            if (newValue != null) {
                              controller.updateReturnStatus(
                                  returnOrder, newValue);
                            }
                          },
                          items: ReturnStatus.values
                              .map((ReturnStatus status) {
                            return DropdownMenuItem<ReturnStatus>(
                              value: status,
                              child: Text(
                                status.name.capitalize.toString(),
                                style: TextStyle(
                                  color: RSHelperFunctions
                                      .getReturnStatusColor(status),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    })
                  ],
                ),
              ),

              // AMOUNT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item Price'),
                    Text(
                      '₹${returnOrder.productPrice}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
