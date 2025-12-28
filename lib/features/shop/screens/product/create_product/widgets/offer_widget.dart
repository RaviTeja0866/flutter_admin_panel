import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/create_product_controller.dart';

class RSOfferWidget extends StatelessWidget {
  const RSOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerController = Get.put(BannerController());

    // Fetch coupons if the list is empty
    if (bannerController.allItems.isEmpty) {
      bannerController.fetchItems();
    }

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coupon label
          Text('Banner', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Dropdown for selecting a coupon
          Obx(
                () => bannerController.isLoading.value
                ? RSShimmerEffect(width: double.infinity, height: 50)
                : DropdownButtonFormField<BannerModel>(
              value: CreateProductController.instance.selectedBanner.value,
              decoration: InputDecoration(
                labelText: 'Select Banner',
                border: OutlineInputBorder(),
              ),
              items: bannerController.allItems
                  .map((banner) => DropdownMenuItem<BannerModel>(
                value: banner,
                child: Text(banner.value),
              ))
                  .toList(),
              onChanged: (BannerModel? value) {
                if (value != null) {
                  CreateProductController.instance.selectedBanner.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
