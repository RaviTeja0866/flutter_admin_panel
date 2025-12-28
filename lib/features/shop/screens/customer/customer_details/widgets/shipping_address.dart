import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/personalization/models/address_model.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../utils/constants/sizes.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    controller.getCustomerAddresses();

    return Obx(
      () {
        if(controller.addressesLoading.value) return RSLoaderAnimation();

        AddressModel selectedAddress = AddressModel.empty();
        if(controller.customer.value.addresses != null){
          if(controller.customer.value.addresses!.isNotEmpty) {
            selectedAddress = controller.customer.value.addresses!.where((element) => element.selectedAddress).single;
          }
        }

        return RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Meta Data
                Row(
                  children: [
                    SizedBox(width: 120, child: Text('Name')),
                    Text(':'),
                    SizedBox(width: RSSizes.spaceBtwItems / 2),
                    Expanded(
                      child: Text(selectedAddress.firstName, style: Theme.of(context).textTheme.titleMedium),
                    )
                  ],
                ),
                SizedBox(height: RSSizes.spaceBtwItems),
                Row(
                  children: [
                    SizedBox(width: 120, child: Text('Name')),
                    Text(':'),
                    SizedBox(width: RSSizes.spaceBtwItems / 2),
                    Expanded(
                      child: Text(selectedAddress.lastName, style: Theme.of(context).textTheme.titleMedium),
                    )
                  ],
                ),
                SizedBox(height: RSSizes.spaceBtwItems),
                Row(
                  children: [
                    SizedBox(width: 120, child: Text('Phone Number')),
                    Text(':'),
                    SizedBox(width: RSSizes.spaceBtwItems / 2),
                    Expanded(
                      child: Text(selectedAddress.phoneNumber, style: Theme.of(context).textTheme.titleMedium),
                    )
                  ],
                ),
                SizedBox(height: RSSizes.spaceBtwItems),
                Row(
                  children: [
                    SizedBox(width: 120, child: Text('Address')),
                    Text(':'),
                    SizedBox(width: RSSizes.spaceBtwItems / 2),
                    Expanded(
                      child: Text(
                          selectedAddress.id.isNotEmpty ? selectedAddress.toString() : '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
    );
  }
}
