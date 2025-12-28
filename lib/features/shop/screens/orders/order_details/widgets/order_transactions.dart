import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class OrderTransactions extends StatelessWidget {
  const OrderTransactions({super.key, required this.order});

  final OrderModel order;

  String _getPaymentMethodImage(String? paymentMethod) {
    if (paymentMethod == null) return RSImages.paytm;

    switch (paymentMethod.toLowerCase()) {
      case 'paytm':
        return RSImages.paytm;
      case 'gpay':
      case 'google pay':
        return RSImages.googlePay;
      case 'phonepe':
      case 'phone pe':
        return RSImages.phonePe;
      case 'upi':
        return RSImages.upi;
      case 'card payment':
        return RSImages.creditCard;
      case 'net banking':
        return RSImages.netBanking;
      case 'wallet':
        return RSImages.wallet;
      case 'cod':
      case 'cash on delivery':
        return RSImages.cod;
      default:
        return RSImages.paytm;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RSRoundedContainer(
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: RSSizes.spaceBtwSections),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PAYMENT METHOD
              Expanded(
                flex: RSDeviceUtils.isMobileScreen(context) ? 2 : 3,
                child: Row(
                  children: [
                    RSRoundedImage(
                      imageType: ImageType.asset,
                      image: _getPaymentMethodImage(order.paymentMethod),
                    ),
                    SizedBox(width: RSSizes.spaceBtwItems),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          order.paymentMethod?.capitalize ?? 'Unknown',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text(order.formattedOrderDate,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),

              /// TOTAL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total',
                        style: Theme.of(context).textTheme.labelMedium),
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

