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
  const OrderCustomer ({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    controller.order.value = order;
    controller.getCustomerOffCurrentOrder();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Info
        RSRoundedContainer(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer',  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: RSSizes.spaceBtwSections),
              Obx(
                () {
                    return Row(
                      children: [
                        RSRoundedImage(
                          padding: 0,
                          backgroundColor: RSColors.primaryBackground,
                          image: controller.customer.value.profilePicture
                              .isNotEmpty ? controller.customer.value
                              .profilePicture : RSImages.user,
                          imageType: controller.customer.value.profilePicture
                              .isNotEmpty ? ImageType.network : ImageType.asset,
                        ),
                        SizedBox(width: RSSizes.spaceBtwItems),

                        Expanded(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.customer.value.fullName,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium, overflow: TextOverflow
                                  .ellipsis, maxLines: 1,),
                            Text(controller.customer.value.email,
                                overflow: TextOverflow.ellipsis, maxLines: 1),
                          ],
                        ))

                      ],
                    );
                  },
              ),
            ],
          ),
        ),
        SizedBox(height: RSSizes.spaceBtwSections),

        // Contact Info
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: RSRoundedContainer(
              padding: EdgeInsets.all(RSSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact person', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: RSSizes.spaceBtwSections),
                  Text(controller.customer.value.fullName, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: RSSizes.spaceBtwSections / 2),
                  Text(controller.customer.value.email, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: RSSizes.spaceBtwSections / 2),
                  Text(controller.customer.value.phoneNumber, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: RSSizes.spaceBtwSections / 2),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: RSSizes.spaceBtwSections),

        // Shipping Address

          SizedBox(
            width: double.infinity,
            child: RSRoundedContainer(
              padding: EdgeInsets.all(RSSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: RSSizes.spaceBtwSections),
                  Text(order.shippingAddress != null ? order.shippingAddress!.fullName : '', style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: RSSizes.spaceBtwSections / 2),
                  Text(order.shippingAddress != null ? order.shippingAddress!.toString() : '', style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: RSSizes.spaceBtwSections / 2),
                  Text(order.shippingAddress != null ? order.shippingAddress!.phoneNumber : '', style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: RSSizes.spaceBtwSections / 2),
                ],
              ),
            ),
          ),
        SizedBox(height: RSSizes.spaceBtwSections),

        // Billing Address
        SizedBox(
          width: double.infinity,
          child: RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Billing Address', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: RSSizes.spaceBtwSections),
                Text(order.billingAddressSameShipping ? order.shippingAddress!.fullName : order.billingAddress!.fullName, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwSections / 2),
                Text(order.billingAddressSameShipping ? order.shippingAddress!.toString() : order.billingAddress!.toString(), style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwSections / 2),
                Text(order.billingAddressSameShipping ? order.shippingAddress!.phoneNumber : order.billingAddress!.phoneNumber, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwSections / 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
