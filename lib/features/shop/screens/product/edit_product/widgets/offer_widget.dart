import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/helpers/cloud_helper_functions.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';

import '../../../../models/banner_model.dart';

class RSOfferWidget extends StatelessWidget {
  const RSOfferWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;
    final bannerController = Get.put(BannerController());

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Label
          Text('Banner', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Coupon selection using DropdownButton
          FutureBuilder<BannerModel?>(
            future: productController.loadBannerForProduct(product.id),
            builder: (context, snapshot) {
              final widget =
                  RSCloudHelperFunctions.checkSingleRecordState(snapshot);
              if (widget != null) return widget;

              return Obx(() {
                return DropdownButtonFormField<BannerModel>(
                  value: productController.selectedBanner.value,
                  decoration: InputDecoration(
                    labelText: 'Select Banner',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Iconsax.picture_frame),
                  ),
                  items: [
                    // Add a "No Banner" option
                    DropdownMenuItem<BannerModel>(
                      value: null,
                      child: Text('No Banner'),
                    ),
                    // Add all available coupons
                    ...bannerController.allItems
                        .map((banner) => DropdownMenuItem<BannerModel>(
                              value: banner,
                              child: Text(banner.value),
                            )),
                  ],
                  onChanged: (value) {
                    productController.selectedBanner.value =
                        value; // Set selected coupon
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
