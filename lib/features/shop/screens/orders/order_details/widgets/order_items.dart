import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';
import 'package:roguestore_admin_panel/utils/helpers/pricing_calculator.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/order_model.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final subtotal = order.items.fold(0.0, (previousValue, element) => previousValue + (element.price * element.quantity));
    return RSRoundedContainer(
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),
          // Items
          ListView.separated(
              shrinkWrap: true,
            itemCount: order.items.length,
              physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: RSSizes.spaceBtwItems),
              itemBuilder: (_, index){
                final item  = order.items[index];
                return Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          RSRoundedImage(
                              backgroundColor: RSColors.primaryBackground,
                              imageType: item.image != null ? ImageType.network : ImageType.asset,
                            image: item.image ?? RSImages.defaultImage,
                          ),
                          SizedBox(width: RSSizes.spaceBtwItems),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(
                              item.title,style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            if(item.selectedVariation != null)
                              Text(item.selectedVariation!.entries.map((e) => ('${e.key} : ${e.value}')).toString(),
                              ),
                            ],
                          )),
                          SizedBox(width: RSSizes.spaceBtwItems),
                          SizedBox(
                            width: RSSizes.xl * 2,
                            child: Text('₹${item.price.toStringAsFixed(1)}',style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          SizedBox(width: RSDeviceUtils.isMobileScreen(context) ? RSSizes.xl * 1.4 : RSSizes.xl * 2,
                            child:  Text(item.quantity.toString() ,style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          SizedBox(width: RSDeviceUtils.isMobileScreen(context) ? RSSizes.xl * 1.4 : RSSizes.xl * 2,
                            child:  Text('₹${item.totalAmount}' ,style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
          ),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Items Total
          RSRoundedContainer(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            backgroundColor: RSColors.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SubTotal',style: Theme.of(context).textTheme.titleLarge),
                  Text('₹$subtotal',style: Theme.of(context).textTheme.titleLarge),
                ],
                ),
                SizedBox(height: RSSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount',style: Theme.of(context).textTheme.titleLarge),
                    Text('₹0.00',style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                SizedBox(height: RSSizes.spaceBtwSections),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shpping',style: Theme.of(context).textTheme.titleLarge),
                    Text('₹${RSPricingCalculator.calculateShippingCost(subtotal, '')}',style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                SizedBox(height: RSSizes.spaceBtwSections),
                Divider(),
                SizedBox(height: RSSizes.spaceBtwSections),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',style: Theme.of(context).textTheme.titleLarge),
                    Text('₹${RSPricingCalculator.calculateTotalPrice(subtotal, '')}',style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
