import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/create_product_controller.dart';
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

    return Obx(
      () => CreateProductController.instance.productType.value == ProductType.variable
      ? RSRoundedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Variations Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Variations', style: Theme.of(context).textTheme.headlineSmall),
                TextButton(onPressed: () => variationController.removeVariations(context),
                    child: Text('Remove Variations')),
              ],
            ),
            SizedBox(height: RSSizes.spaceBtwItems),

            // Variation list
            if(variationController.productVariations.isNotEmpty)
            ListView.separated(
              itemCount: variationController.productVariations.length,
                shrinkWrap: true,
              separatorBuilder: (_,__)=> SizedBox(height: RSSizes.spaceBtwItems),
                itemBuilder: (_,index){
                final variation = variationController.productVariations[index];
                return _buildVariationTile(context, index, variation, variationController);
                },
            ) else
            // No Variation Message
            _buildNoVariationMessage(),
          ],
        ),
      )
          : SizedBox.shrink(),
    );
  }

  // Helper method to build a variation tile
  Widget _buildVariationTile(
      BuildContext context, int index, ProductVariationModel variation, ProductVariationsController variationController) {
    return ExpansionTile(
        backgroundColor: RSColors.lightGrey,
        collapsedBackgroundColor: RSColors.lightGrey,
        childrenPadding: EdgeInsets.all(RSSizes.md),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RSSizes.borderRadiusLg),),
        title: Text(variation.attributeValues.entries.map((entry) => '${entry.key} : ${entry.value}').join(',')),
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

      // Variation for stock& Pricing
      Row(
        children: [
          Expanded(child: TextFormField(
            onChanged: (value) => variation.stock = int.tryParse(value) ?? 0,
            decoration: InputDecoration(labelText: 'Stock', hintText: 'Add Stock, only Numbers are allowed'),
            controller: variationController.stockControllersList[index][variation],
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          )),
          SizedBox(height: RSSizes.spaceBtwInputFields),

          Expanded(child:  TextFormField(
            onChanged: (value) => variation.price = double.tryParse(value) ?? 0.0,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Price', hintText: 'Price with up to 2- decimals'),
            controller: variationController.priceControllersList[index][variation],
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d\.?\d{0,4}$'))],
          )),
          SizedBox(height: RSSizes.spaceBtwInputFields),

          Expanded(child:  TextFormField(
            onChanged: (value) => variation.salePrice = double.tryParse(value) ?? 0.0,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Discounted Price', hintText: 'Price with up to 2- decimals'),
            controller: variationController.salePriceControllersList[index][variation],
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d\.?\d{0,4}$'))],
          )),
        ],
      ),
      SizedBox(height: RSSizes.spaceBtwInputFields),

      // Variation Description
      TextFormField(
        onChanged: (value) => variation.description = value,
        controller: variationController.descriptionControllersList[index][variation],
        decoration: InputDecoration(labelText: 'Description', hintText: 'Add description to this variation...'),
      ),
      SizedBox(height: RSSizes.spaceBtwSections),
    ],
    );
  }

  // Helper method to build message when there are no variations
  Widget _buildNoVariationMessage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RSRoundedImage(width: 200, height: 200, imageType: ImageType.asset, image: RSImages.defaultVariationImageIcon),
          ],
        ),
        SizedBox(height: RSSizes.spaceBtwItems),
        Text('There are no Variations added for this product'),
      ],
    );
  }
}
