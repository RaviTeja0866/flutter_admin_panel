import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_detail_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderDetailController.instance;

    return Obx(() {
      final order = controller.currentOrder.value;
      final customer = controller.customer.value;

      if (order == null) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- CUSTOMER INFO ----------------
          RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: RSSizes.spaceBtwSections),

                Row(
                  children: [
                    RSRoundedImage(
                      padding: 0,
                      backgroundColor: RSColors.primaryBackground,
                      image: customer.profilePicture.isNotEmpty
                          ? customer.profilePicture
                          : RSImages.user,
                      imageType: customer.profilePicture.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                    ),
                    SizedBox(width: RSSizes.spaceBtwItems),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            customer.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: RSSizes.spaceBtwSections),

          // ---------------- CONTACT INFO ----------------
          RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Person',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(customer.fullName),
                Text(customer.email),
                Text(customer.phoneNumber),
              ],
            ),
          ),

          SizedBox(height: RSSizes.spaceBtwSections),

          // ---------------- SHIPPING ADDRESS ----------------
          RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(order.shippingAddress?.fullName ?? ''),
                Text(order.shippingAddress?.toString() ?? ''),
                Text(order.shippingAddress?.phoneNumber ?? ''),
              ],
            ),
          ),

          SizedBox(height: RSSizes.spaceBtwSections),

          // ---------------- BILLING ADDRESS ----------------
          RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billing Address',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(
                  order.billingAddressSameShipping
                      ? order.shippingAddress?.fullName ?? ''
                      : order.billingAddress?.fullName ?? '',
                ),
                Text(
                  order.billingAddressSameShipping
                      ? order.shippingAddress?.toString() ?? ''
                      : order.billingAddress?.toString() ?? '',
                ),
                Text(
                  order.billingAddressSameShipping
                      ? order.shippingAddress?.phoneNumber ?? ''
                      : order.billingAddress?.phoneNumber ?? '',
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
