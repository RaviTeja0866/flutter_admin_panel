import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/product/product_attributes_controller.dart';
import '../../../../controllers/product/product_variations_controller.dart';
import '../../../../models/product_attribute_model.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;
    final attributeController = Get.put(ProductAttributesController());
    final variationController = Get.put(ProductVariationsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Divider based on Product Type
        Obx(() {
          return productController.productType.value == ProductType.single
              ? Column(children: [
            Divider(color: RSColors.primaryBackground),
            SizedBox(height: RSSizes.spaceBtwItems),
          ])
              : SizedBox.shrink();
        }),

        Text('Add Product Attributes',
            style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: RSSizes.spaceBtwItems),

        // Form to add new Attribute
        Form(
          key: attributeController.attributeFormKey,
          child: RSDeviceUtils.isDesktopScreen(context)
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAttributeName(attributeController),
              ),
              SizedBox(width: RSSizes.spaceBtwItems),
              Expanded(
                flex: 2,
                child: _buildAttributeTextField(attributeController),
              ),
              SizedBox(width: RSSizes.spaceBtwItems),
              _buildAddAttributeButton(attributeController)
            ],
          )
              : Column(
            children: [
              _buildAttributeName(attributeController),
              SizedBox(height: RSSizes.spaceBtwItems),
              _buildAttributeTextField(attributeController),
              SizedBox(height: RSSizes.spaceBtwItems),
              _buildAddAttributeButton(attributeController),
            ],
          ),
        ),
        SizedBox(height: RSSizes.spaceBtwSections),

        //List of added attributes
        Text('All Attributes', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: RSSizes.spaceBtwItems),

        // Display added attributes in a rounded container
        RSRoundedContainer(
          backgroundColor: RSColors.primaryBackground,
          child: Obx(
                () => attributeController.productAttributes.isNotEmpty
                ? ListView.separated(
              shrinkWrap: true,
              itemCount: attributeController.productAttributes.length,
              separatorBuilder: (_, __) => SizedBox(height: RSSizes.spaceBtwItems),
              itemBuilder: (_, index){
                final attribute = attributeController.productAttributes[index];
                final bool isColorAttribute = attribute.name?.toLowerCase() == 'color' ||
                    attribute.name?.toLowerCase() == 'colors';

                return Container(
                  decoration: BoxDecoration(
                    color: RSColors.white,
                    borderRadius: BorderRadius.circular(RSSizes.borderRadiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modified ListTile with dropdown for color attributes
                      ListTile(
                        title: Text(attribute.name ?? ''),
                        subtitle: Text(attribute.values!.map((e) => e.trim()).toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Show dropdown icon only for color attributes
                            if (isColorAttribute)
                              Obx(() => IconButton(
                                onPressed: () => attributeController.toggleSwatchVisibility(index),
                                icon: Icon(
                                  attributeController.isSwatchVisible(index)
                                      ? Iconsax.arrow_up_1
                                      : Iconsax.arrow_down_1,
                                  color: RSColors.primary,
                                ),
                              )),
                            IconButton(
                              onPressed: () => attributeController.removeAttribute(index, context),
                              icon: Icon(Iconsax.trash, color: RSColors.error),
                            ),
                          ],
                        ),
                      ),

                      // Show color swatches if this is a color attribute and swatches are visible
                      if (isColorAttribute && attribute.values != null)
                        Obx(() => attributeController.isSwatchVisible(index)
                            ? Padding(
                          padding: const EdgeInsets.only(
                            left: RSSizes.defaultSpace,
                            right: RSSizes.defaultSpace,
                            bottom: RSSizes.defaultSpace,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Color Swatches:',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: RSSizes.spaceBtwItems / 2),
                              // Show "No swatches found" with upload button if there are no swatches
                              attribute.values!.isEmpty
                                  ? _buildNoSwatchesFound(context, attributeController, index)
                                  : Wrap(
                                spacing: RSSizes.spaceBtwItems,
                                runSpacing: RSSizes.spaceBtwItems / 2,
                                children: attribute.values!.map((colorName) {
                                  // Get input type (Hex Code or Image)
                                  final String inputType = attribute.additionalInfo != null &&
                                      attribute.additionalInfo![colorName] != null &&
                                      attribute.additionalInfo![colorName]['inputType'] != null ?
                                  attribute.additionalInfo![colorName]['inputType'] : 'Hex Code';

                                  // Check if swatch image exists
                                  final bool hasImage = attribute.additionalInfo != null &&
                                      attribute.additionalInfo![colorName] != null &&
                                      attribute.additionalInfo![colorName]['imageUrl'] != null;

                                  // Get color from additionalInfo
                                  final Color colorValue = attribute.additionalInfo != null &&
                                      attribute.additionalInfo![colorName] != null &&
                                      attribute.additionalInfo![colorName]['colorCode'] != null ?
                                  attributeController.hexToColor(
                                      attribute.additionalInfo![colorName]['colorCode']
                                  ) : Colors.grey;

                                  // Check if editing hex code
                                  final bool isEditingHex = attributeController.isEditingHexCodeFor(
                                      attribute.name!, colorName);

                                  // Create TextEditingController for hex code editing
                                  final TextEditingController hexEditController = TextEditingController(
                                      text: attribute.additionalInfo != null &&
                                          attribute.additionalInfo![colorName] != null &&
                                          attribute.additionalInfo![colorName]['colorCode'] != null ?
                                      attribute.additionalInfo![colorName]['colorCode'].replaceAll('#', '') : 'CCCCCC'
                                  );

                                  return Container(
                                    width: 110,
                                    child: Column(
                                      children: [
                                        // Color name
                                        Text(colorName,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 8),

                                        // Input type selection (Hex Code or Image)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: inputType,
                                            underline: SizedBox(),
                                            icon: Icon(Icons.arrow_drop_down, size: 18),
                                            items: attributeController.colorInputTypes.map((String type) {
                                              return DropdownMenuItem<String>(
                                                value: type,
                                                child: Text(type, style: TextStyle(fontSize: 12)),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                attributeController.updateInputTypeSelection(
                                                    attribute.name!, colorName, newValue, context
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 8),

                                        // Show appropriate input based on selected type
                                        inputType == 'Hex Code'
                                            ? _buildHexCodeInput(context, attribute.name!, colorName, hexEditController, attributeController)
                                            : _buildImageUploadDisplay(hasImage, attribute, colorName, attributeController, context),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                            : SizedBox.shrink()),
                    ],
                  ),
                );
              },
            )
                : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RSRoundedImage(width: 150, height: 60, imageType: ImageType.asset, image: RSImages.defaultAttributeColorsImageIcon),
                  ],
                ),
                SizedBox(height: RSSizes.spaceBtwItems),
                Text('There are no Attributes added for this Product')
              ],
            ),
          ),
        ),
        SizedBox(height: RSSizes.spaceBtwSections),

        // Generate Variations Button
        Obx(
              ()=> productController.productType.value == ProductType.variable && variationController.productVariations.isEmpty
              ? Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                icon: Icon(Iconsax.activity),
                label: Text('Generate Variations'),
                onPressed: () => variationController.generateVariationsConfirmation(context),
              ),
            ),
          )
              : SizedBox.shrink(),
        )
      ],
    );
  }

  // Hex code input field - always shown when input type is Hex Code
// Modified _buildHexCodeInput method
  Widget _buildHexCodeInput(
      BuildContext context,
      String attributeName,
      String colorName,
      TextEditingController hexController,
      ProductAttributesController controller,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hex code text field styled like a dropdown
        Expanded(
          child: Container(
            height: 40,
            child: TextField(
              controller: hexController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6), // More rectangular
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: RSColors.primary, width: 1.2),
                ),
                prefixText: "#",
                hintText: "FFFFFF",
              ),
              style: TextStyle(fontSize: 13),
              onSubmitted: (value) {
                controller.updateHexColorInline(attributeName, colorName, value, context);
              },
            ),
          ),
        ),
        SizedBox(width: 6),
        // Save button - only show when editing
        Obx(() {
          final isEditing = controller.isEditingHexCodeFor(attributeName, colorName);
          return isEditing
              ? InkWell(
            onTap: () {
              controller.updateHexColorInline(
                  attributeName, colorName, hexController.text, context);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: RSColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          )
              : SizedBox.shrink(); // Hide the button when not editing
        }),
      ],
    );
  }


  // Image upload display - only shown when input type is Image
  Widget _buildImageUploadDisplay(
      bool hasImage,
      ProductAttributeModel attribute,
      String colorName,
      ProductAttributesController controller,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Show image if exists, otherwise show placeholder
        hasImage
            ? Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
            image: DecorationImage(
              image: NetworkImage(attribute.additionalInfo![colorName]['imageUrl']),
              fit: BoxFit.cover,
            ),
          ),
        )
            : Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 20,
          ),
        ),
        SizedBox(width: 8),
        // Upload image button
        InkWell(
          onTap: () => controller.uploadSwatchImage(context, attribute.name!, colorName),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: RSColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.gallery_add,
              color: RSColors.primary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  // build button to add a new attribute
  SizedBox _buildAddAttributeButton(ProductAttributesController controller) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
          onPressed: () => controller.addNewAttribute(),
          icon: Icon(Iconsax.add),
          style: ElevatedButton.styleFrom(
            foregroundColor: RSColors.black,
            backgroundColor: RSColors.secondary,
            side: BorderSide(color: RSColors.secondary),
          ),
          label: Text('Add')),
    );
  }

  // Build text form field for attribute name
  TextFormField _buildAttributeName(ProductAttributesController controller) {
    return TextFormField(
      controller: controller.attributeName,
      validator: (value) => RSValidator.validateEmptyText('Attribute Name', value),
      decoration: InputDecoration(labelText: 'Attribute Name', hintText: 'Colors, sizes, Material'),
    );
  }

  // Build text form filed for attribute values
  _buildAttributeTextField(ProductAttributesController controller) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        controller: controller.attributes,
        validator: (value) => RSValidator.validateEmptyText('Attribute Filed', value),
        decoration: InputDecoration(
          labelText: 'Attributes',
          hintText: 'Add Attributes separated by | Example : Green | Blue | Yellow',
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  // Widget to show when no swatches are found
  Widget _buildNoSwatchesFound(BuildContext context, ProductAttributesController controller, int attributeIndex) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No color swatches available', style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: RSSizes.spaceBtwItems),
          InkWell(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: RSColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RSColors.grey.withOpacity(0.3)),
              ),
              child: Icon(
                Iconsax.gallery_add,
                color: RSColors.primary,
                size: 30,
              ),
            ),
          ),
          SizedBox(height: RSSizes.spaceBtwItems / 2),
          Text('Upload Images', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}