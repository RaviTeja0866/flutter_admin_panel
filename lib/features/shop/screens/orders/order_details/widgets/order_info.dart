import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../utils/constants/sizes.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return RSRoundedContainer(
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: RSSizes.spaceBtwSections),

          Row(
            children: [
              // ---------------- DATE ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(
                      order.formattedOrderDate,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // ---------------- ITEMS ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Items'),
                    Text(
                      '${order.items.length} Items',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // ---------------- STATUS ----------------
              Expanded(
                flex: RSDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),

                    GetX<OrderController>(
                      builder: (controller) {
                        if (controller.statusLoader.value) {
                          return RSShimmerEffect(
                            width: double.infinity,
                            height: 48,
                          );
                        }

                        return RSRoundedContainer(
                          radius: RSSizes.cardRadiusSm,
                          padding: EdgeInsets.symmetric(horizontal: RSSizes.sm),
                          backgroundColor: RSHelperFunctions
                              .getOrderStatusColor(order.status)
                              .withOpacity(0.12),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<OrderStatus>(
                              value: order.status,
                              isExpanded: true,
                              onChanged: (OrderStatus? newStatus) {
                                if (newStatus == null) return;
                                if (newStatus == order.status) return;

                                controller.updateOrderStatus(order, newStatus);
                              },
                              items: OrderStatus.values.map((status) {
                                return DropdownMenuItem<OrderStatus>(
                                  value: status,
                                  child: Text(
                                    status.name.capitalize!,
                                    style: TextStyle(
                                      color: RSHelperFunctions
                                          .getOrderStatusColor(status),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ---------------- TOTAL ----------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text(
                      '₹${order.totalAmount}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
