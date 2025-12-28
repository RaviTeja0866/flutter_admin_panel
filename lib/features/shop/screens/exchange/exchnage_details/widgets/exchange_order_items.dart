import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/models/exchange_model.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ExchangeOrderItems extends StatelessWidget {
  const ExchangeOrderItems({super.key, required this.exchangeOrder});

  final ExchangeRequestModel exchangeOrder;

  @override
  Widget build(BuildContext context) {
    final cart = exchangeOrder.cartItem;

    final double total = cart.price * cart.quantity;

    return RSRoundedContainer(
      padding: const EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exchange Item',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: RSSizes.spaceBtwSections),

          // --------------------------------------------------------------------
          // PRODUCT ROW
          // --------------------------------------------------------------------
          Row(
            children: [
              RSRoundedImage(
                backgroundColor: RSColors.primaryBackground,
                imageType: ImageType.network,
                image: cart.image.isNotEmpty
                    ? cart.image
                    : RSImages.defaultImage,
              ),

              const SizedBox(width: RSSizes.spaceBtwItems),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      "Original Size: ${exchangeOrder.originalSize}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    Text(
                      "Requested Size: ${exchangeOrder.requestedSize}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: RSSizes.spaceBtwItems),

              SizedBox(
                width: RSSizes.xl * 2,
                child: Text(
                  "₹${cart.price.toStringAsFixed(1)}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              SizedBox(
                width: RSDeviceUtils.isMobileScreen(context)
                    ? RSSizes.xl * 1.4
                    : RSSizes.xl * 2,
                child: Text(
                  cart.quantity.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              SizedBox(
                width: RSDeviceUtils.isMobileScreen(context)
                    ? RSSizes.xl * 1.4
                    : RSSizes.xl * 2,
                child: Text(
                  "₹${total.toStringAsFixed(1)}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),

          const SizedBox(height: RSSizes.spaceBtwSections),

        ],
      ),
    );
  }
}
