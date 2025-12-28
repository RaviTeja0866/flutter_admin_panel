import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../controllers/exchange/exchnage_detail_controller.dart';
import '../../../../models/exchange_model.dart';

class ExchangeCustomer extends StatelessWidget {
  const ExchangeCustomer({super.key, required this.exchange});

  final ExchangeRequestModel exchange;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExchangeDetailController());
    controller.exchange.value = exchange;
    controller
        .loadCustomerAndOrder(); // loads customer + order of this exchange

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ------------------------------
        /// PERSONAL INFO
        /// ------------------------------
        RSRoundedContainer(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: RSSizes.spaceBtwSections),
              Obx(() {
                final c = controller.customer.value;

                return Row(
                  children: [
                    RSRoundedImage(
                      padding: 0,
                      backgroundColor: RSColors.primaryBackground,
                      image: c.profilePicture.isNotEmpty
                          ? c.profilePicture
                          : RSImages.user,
                      imageType: c.profilePicture.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                    ),
                    SizedBox(width: RSSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.fullName,
                              style: Theme.of(context).textTheme.headlineMedium,
                              overflow: TextOverflow.ellipsis),
                          Text(c.email,
                              overflow: TextOverflow.ellipsis, maxLines: 1),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),

        SizedBox(height: RSSizes.spaceBtwSections),

        /// ------------------------------
        /// CONTACT INFO
        /// ------------------------------
        Obx(() {
          final c = controller.customer.value;

          return RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Person',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(c.fullName, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),
                Text(c.email, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),
                Text(c.phoneNumber,
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          );
        }),

        SizedBox(height: RSSizes.spaceBtwSections),

        /// ------------------------------
        /// SHIPPING ADDRESS
        /// ------------------------------
        Obx(() {
          final order = controller.order.value;

          return RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shipping Address',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(order.shippingAddress?.fullName ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),
                Text(order.shippingAddress?.toString() ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),
                Text(order.shippingAddress?.phoneNumber ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          );
        }),

        SizedBox(height: RSSizes.spaceBtwSections),

        /// ------------------------------
        /// BILLING ADDRESS
        /// ------------------------------
        Obx(() {
          final order = controller.order.value;

          final billing = order.billingAddressSameShipping
              ? order.shippingAddress
              : order.billingAddress;

          return RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Billing Address',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(billing?.fullName ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),
                Text(billing?.toString() ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),
                Text(billing?.phoneNumber ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          );
        }),
      ],
    );
  }
}
