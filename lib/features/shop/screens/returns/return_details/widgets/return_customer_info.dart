import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/returns/reuturn_detail_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../models/return_model.dart';

class ReturnsCustomer extends StatelessWidget {
  const ReturnsCustomer({super.key, required this.returnOrder});

  final ReturnModel returnOrder;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReturnDetailController());
    controller.returnOrder.value = returnOrder;
    controller.loadCustomerDetails(); // load user + address

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -------------------------------------------------------
        // CUSTOMER INFO
        // -------------------------------------------------------
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
                    // Customer Image
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

                    // Name + Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.fullName,
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            c.email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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

        // -------------------------------------------------------
        // CONTACT INFO
        // -------------------------------------------------------
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

        // -------------------------------------------------------
        // SHIPPING ADDRESS (FOR RETURN PICKUP)
        // -------------------------------------------------------
        Obx(() {
          final address = controller.returnOrder.value.shippingAddress;

          return RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pickup Address',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: RSSizes.spaceBtwSections),

                Text(address?.fullName ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),

                Text(address?.toString() ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: RSSizes.spaceBtwItems / 2),

                Text(address?.phoneNumber ?? '',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          );
        }),
      ],
    );
  }
}
