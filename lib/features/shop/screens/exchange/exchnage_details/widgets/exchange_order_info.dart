import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/exchange/exchange_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/exchange_model.dart';

class ExchangeOrderInfo extends StatelessWidget {
  const ExchangeOrderInfo({super.key, required this.exchangeOrder});

  final ExchangeRequestModel exchangeOrder;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExchangeController());

    // Set initial dropdown value
    controller.exchangeStatus.value = exchangeOrder.status;

    final cart = exchangeOrder.cartItem;

    return RSRoundedContainer(
      padding: const EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exchange Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: RSSizes.spaceBtwSections),

          Row(
            children: [
              // --------------------------------------------------------------------
              // REQUESTED DATE
              // --------------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requested On'),
                    Text(
                      RSHelperFunctions.getFormattedDate(exchangeOrder.requestDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------------------------
              // QUANTITY
              // --------------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quantity'),
                    Text(
                      '${cart.quantity} Item(s)',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------------------------
              // EXCHANGE STATUS DROPDOWN
              // --------------------------------------------------------------------
              Expanded(
                flex: RSDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Exchange Status'),

                    Obx(() {
                      if (controller.statusLoader.value) {
                        return const RSShimmerEffect(
                            width: double.infinity, height: 55);
                      }

                      return RSRoundedContainer(
                        radius: RSSizes.cardRadiusSm,
                        padding: const EdgeInsets.symmetric(
                            horizontal: RSSizes.sm, vertical: 0),
                        backgroundColor:
                        RSHelperFunctions.getExchangeStatusColor(
                          controller.exchangeStatus.value,
                        ).withOpacity(0.1),
                        child: DropdownButton<ExchangeStatus>(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          value: controller.exchangeStatus.value,
                          onChanged: (ExchangeStatus? newValue) {
                            if (newValue != null) {
                              controller.updateExchangeStatus(
                                exchangeOrder,
                                newValue,
                              );
                            }
                          },
                          items: ExchangeStatus.values
                              .map((ExchangeStatus status) {
                            return DropdownMenuItem<ExchangeStatus>(
                              value: status,
                              child: Text(
                                status.name.capitalize.toString(),
                                style: TextStyle(
                                  color: RSHelperFunctions
                                      .getExchangeStatusColor(status),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // --------------------------------------------------------------------
              // ITEM PRICE
              // --------------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Item Price'),
                    Text(
                      '₹${cart.price}',
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
