import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductImagesController controller = Get.put(ProductImagesController());

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail text
          Text('Product Thumbnail', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Container for Product Thumbnail
          RSRoundedContainer(
            height: 300,
            backgroundColor: RSColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thumbnail Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Obx(() => RSRoundedImage(
                              width: 220,
                              height: 220,
                              image:controller.selectedThumbnailImageUrl.value ?? RSImages.defaultSingleImageIcon,
                              imageType: controller.selectedThumbnailImageUrl.value == null ? ImageType.asset : ImageType.network,
                          )))
                    ],
                  ),

                  // Add Thumbnail Button
                  SizedBox(width: 200, child: OutlinedButton(onPressed: () => controller.selectThumbnailImage(), child: Text('Add Thumbnail'))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
