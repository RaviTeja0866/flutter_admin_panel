import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../../../common/widgets/images/multiple_image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    final variationController = ProductVariationsController.instance;

    return Obx(() {
      final productType = EditProductController.instance.productType.value;
      return productType == ProductType.variable
          ? RSRoundedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Variations',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextButton(
                    onPressed: () =>
                        variationController.removeVariations(context),
                    child: Text('Remove Variations')),
              ],
            ),
            SizedBox(height: RSSizes.spaceBtwItems),

            // Variation List
            Obx(() {
              final variations = variationController.productVariations;
              if (variations.isNotEmpty) {
                return ListView.separated(
                  itemCount: variations.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: RSSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final variation = variations[index];
                    return _buildVariationTile(
                        context, index, variation, variationController);
                  },
                );
              } else {
                return _buildNoVariationMessage();
              }
            }),
          ],
        ),
      )
          : SizedBox.shrink();
    });
  }

  Widget _buildVariationTile(
      BuildContext context,
      int index,
      ProductVariationModel variation,
      ProductVariationsController variationController) {
    return ExpansionTile(
      backgroundColor: RSColors.lightGrey,
      collapsedBackgroundColor: RSColors.lightGrey,
      childrenPadding: EdgeInsets.all(RSSizes.md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RSSizes.borderRadiusLg),
      ),
      title: Text(variation.attributeValues.entries
          .map((entry) => '${entry.key} : ${entry.value}')
          .join(',')),
      children: [
        // Upload Variation Images
        RSMultipleImageUploader(
            images: variation.images, // RxList<String>
            variationId: variation.id,
            onAddImage: () {
              ProductImagesController.instance.addImageToVariation(variation);
            },
        onRemoveImage: (imageData) {
          int imageIndex = imageData['index']; // Extract index from the map
          ProductImagesController.instance.removeVariationImage(variation, imageIndex);
        },
            onReorder: (oldIndex, newIndex) {
              ProductImagesController.instance.reorderImagesForVariation(variation.id, oldIndex, newIndex);
            },
          ),

        SizedBox(height: RSSizes.spaceBtwInputFields),

        // Stock and Pricing
        Row(
          children: [
            // Stock Input
            Expanded(
              child: TextFormField(
                onChanged: (value) =>
                variation.stock = int.tryParse(value) ?? 0,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  hintText: 'Add Stock (Numbers only)',
                ),
                controller:
                variationController.stockControllersList[index][variation],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),

            // Price Input
            Expanded(
              child: TextFormField(
                onChanged: (value) =>
                variation.price = double.tryParse(value) ?? 0.0,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Price (2 decimals max)',
                ),
                controller:
                variationController.priceControllersList[index][variation],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))
                ],
              ),
            ),

            // Sale Price Input
            Expanded(
              child: TextFormField(
                onChanged: (value) =>
                variation.salePrice = double.tryParse(value) ?? 0.0,
                decoration: InputDecoration(
                  labelText: 'Sale Price',
                  hintText: 'Discounted Price (2 decimals max)',
                ),
                controller: variationController
                    .salePriceControllersList[index][variation],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoVariationMessage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RSRoundedImage(
              width: 200,
              height: 200,
              imageType: ImageType.asset,
              image: RSImages.defaultVariationImageIcon,
            ),
          ],
        ),
        SizedBox(height: RSSizes.spaceBtwItems),
        Text('There are no Variations added for this product'),
      ],
    );
  }
}
