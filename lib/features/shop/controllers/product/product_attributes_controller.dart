import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/popups/dialogs.dart';

class ProductAttributesController extends GetxController {
  static ProductAttributesController get instance => Get.find();

  // Observables for loading state form key, and Product Attributes
  final isLoading = false.obs;
  final attributeFormKey = GlobalKey<FormState>();
  TextEditingController attributeName = TextEditingController();
  TextEditingController attributes = TextEditingController();
  final RxList<ProductAttributeModel> productAttributes = <ProductAttributeModel>[].obs;

  // Track swatch visibility for each attribute
  final RxMap<int, RxBool> swatchVisibility = <int, RxBool>{}.obs;

  // Track which colors are being edited
  final RxMap<String, RxBool> isEditingHexCode = <String, RxBool>{}.obs;

  // List of input types for color attributes
  final List<String> colorInputTypes = ['Hex Code', 'Image'];

  Map<String, bool> confirmedHexCodes = {}; // Key: "$attributeName|$colorName"

  // Function to toggle swatch visibility for a specific attribute
  void toggleSwatchVisibility(int index) {
    if (!swatchVisibility.containsKey(index)) {
      swatchVisibility[index] = true.obs;
    } else {
      swatchVisibility[index]!.toggle();
    }
  }

  // Function to check if swatch is visible for a specific attribute
  bool isSwatchVisible(int index) {
    return swatchVisibility.containsKey(index) ? swatchVisibility[index]!.value : false;
  }

  // Function to add New Attribute
  void addNewAttribute() {
    // Form Validation
    if (!attributeFormKey.currentState!.validate()) {
      return;
    }

    final attributeNameText = attributeName.text.trim().toLowerCase();
    final attributeValues = attributes.text.trim().split('|').map((e) => e.trim()).toList();
    Map<String, dynamic>? additionalInfo;

    // Check if the attribute is for colors
    if (attributeNameText == 'color' || attributeNameText == 'colors') {
      additionalInfo = {};

      // Initialize color attributes with appropriate values based on default input type
      for (var colorName in attributeValues) {
        // Default to 'Hex Code' input type
        additionalInfo[colorName] = {
          'inputType': 'Hex Code',
          'colorCode': '#CCCCCC',  // Default to gray
          // Don't include imageUrl field at all until needed
        };

        // Create reactive variable for editing state
        final editKey = '${attributeNameText}_$colorName';
        isEditingHexCode[editKey] = false.obs;
      }

      // Set the swatch visibility to true for new color attributes
      final index = productAttributes.length;
      swatchVisibility[index] = false.obs;
    }

    // Add attributes to the list of attributes
    productAttributes.add(ProductAttributeModel(
      name: attributeName.text.trim(),
      values: attributeValues,
      additionalInfo: additionalInfo,
    ));

    // Clear text fields after adding
    attributeName.text = '';
    attributes.text = '';
  }

  // Function to Remove an Attribute
  void removeAttribute(int index, BuildContext context) {
    if (index < 0 || index >= productAttributes.length) {
      return;
    }

    // Show a confirmation dialog
    RSDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        Navigator.of(context).pop();

        // Clean up reactive variables for this attribute
        final attribute = productAttributes[index];
        if ((attribute.name?.toLowerCase() == 'color' || attribute.name?.toLowerCase() == 'colors') &&
            attribute.values != null) {
          for (var colorName in attribute.values!) {
            final editKey = '${attribute.name?.toLowerCase()}_$colorName';
            isEditingHexCode.remove(editKey);
          }
        }

        productAttributes.removeAt(index);

        // Remove the swatch visibility entry for this index
        swatchVisibility.remove(index);

        // Reindex the swatchVisibility map after removing an item
        final Map<int, RxBool> newSwatchVisibility = {};
        swatchVisibility.forEach((k, v) {
          if (k > index) {
            newSwatchVisibility[k - 1] = v;
          } else if (k < index) {
            newSwatchVisibility[k] = v;
          }
        });
        swatchVisibility.clear();
        swatchVisibility.addAll(newSwatchVisibility);

        // Reset the product variations when removing an attribute
        ProductVariationsController.instance.productVariations.value = [];
      },
    );
  }

  // Function to reset product Attributes
  void resetProductAttributes() {
    productAttributes.clear();
    swatchVisibility.clear();
    isEditingHexCode.clear();
  }

  // Function to convert hex color code to Color object
  Color hexToColor(String hexString) {
    hexString = hexString.toUpperCase().replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF' + hexString;
    }
    return Color(int.parse(hexString, radix: 16));
  }

  // Get color object for a given color name
  Color? getColorForName(String attributeName, String colorName) {
    if (attributeName.toLowerCase() != 'color' && attributeName.toLowerCase() != 'colors') {
      return null;
    }

    // Find the attribute
    final attribute = productAttributes.firstWhere(
          (attr) => attr.name?.toLowerCase() == attributeName.toLowerCase(),
      orElse: () => ProductAttributeModel(),
    );

    if (attribute.additionalInfo == null) return null;

    final colorInfo = attribute.additionalInfo![colorName];
    if (colorInfo == null || colorInfo['colorCode'] == null) return null;

    return hexToColor(colorInfo['colorCode']);
  }

  // Function to update input type selection for a color
  void updateInputTypeSelection(String attributeName, String colorName, String inputType, BuildContext context) {
    final index = productAttributes.indexWhere(
            (attr) => attr.name?.toLowerCase() == attributeName.toLowerCase()
    );

    if (index >= 0) {
      final attribute = productAttributes[index];
      if (attribute.additionalInfo == null) {
        attribute.additionalInfo = {};
      }

      if (attribute.additionalInfo![colorName] == null) {
        attribute.additionalInfo![colorName] = {};
      }

      // Update the input type
      attribute.additionalInfo![colorName]['inputType'] = inputType;

      // IMPORTANT: Clear irrelevant data based on input type
      if (inputType == 'Hex Code') {
        // If switching to Hex Code, ensure we have a default color code and remove imageUrl
        attribute.additionalInfo![colorName]['colorCode'] =
            attribute.additionalInfo![colorName]['colorCode'] ?? '#CCCCCC';
        attribute.additionalInfo![colorName].remove('imageUrl');
      } else if (inputType == 'Image') {
        // If switching to Image, remove the color code
        attribute.additionalInfo![colorName].remove('colorCode');
      }

      // Reset editing state when switching input types
      final editKey = '${attributeName.toLowerCase()}_$colorName';
      if (isEditingHexCode.containsKey(editKey)) {
        isEditingHexCode[editKey]?.value = false;
      }

      // Update the attribute in the list
      productAttributes[index] = attribute;

      // Take appropriate action based on input type
      if (inputType == 'Hex Code') {
        // Toggle hex editing mode instead of showing dialog
        toggleHexCodeEditing(attributeName, colorName);
      } else if (inputType == 'Image') {
        // For Image type, immediately show the upload dialog
        uploadSwatchImage(context, attributeName, colorName);
      }

      // Refresh the UI
      update();
    }
  }

  // Function to toggle hex code editing mode
  void toggleHexCodeEditing(String attributeName, String colorName) {
    final editKey = '${attributeName.toLowerCase()}_$colorName';

    if (!isEditingHexCode.containsKey(editKey)) {
      isEditingHexCode[editKey] = false.obs;
    }

    isEditingHexCode[editKey]!.toggle();
  }

  // Function to check if hex code is being edited
  bool isEditingHexCodeFor(String attributeName, String colorName) {
    final editKey = '${attributeName.toLowerCase()}_$colorName';
    return isEditingHexCode.containsKey(editKey) ? isEditingHexCode[editKey]!.value : false;
  }

  // Function to update color from dropdown selection
  void updateColorFromDropdown(String attributeName, String colorName, String selectedColor, BuildContext context) {
    final index = productAttributes.indexWhere(
            (attr) => attr.name?.toLowerCase() == attributeName.toLowerCase()
    );

    if (index >= 0) {
      final attribute = productAttributes[index];
      if (attribute.additionalInfo == null) {
        attribute.additionalInfo = {};
      }

      if (attribute.additionalInfo![colorName] == null) {
        attribute.additionalInfo![colorName] = {};
      }

      // Update the selected color
      attribute.additionalInfo![colorName]['selectedColor'] = selectedColor;

      // Set a default color code based on the selection
      String hexCode = '#CCCCCC'; // Default gray

      // Map common color names to hex codes
      Map<String, String> colorMap = {
        'Red': '#FF0000',
        'Blue': '#0000FF',
        'Green': '#00FF00',
        'Yellow': '#FFFF00',
        'Black': '#000000',
        'White': '#FFFFFF',
        'Purple': '#800080',
        'Orange': '#FFA500',
        'Pink': '#FFC0CB',
        'Brown': '#A52A2A',
        'Gray': '#808080',
      };

      if (colorMap.containsKey(selectedColor)) {
        hexCode = colorMap[selectedColor]!;
      }

      attribute.additionalInfo![colorName]['colorCode'] = hexCode;
      productAttributes[index] = attribute;

      // Refresh the UI
      update();
    }
  }

  // Function to directly update hex color without dialog
  void updateHexColorInline(String attributeName, String colorName, String hexCode, BuildContext context) {
    if (!hexCode.startsWith('#')) {
      hexCode = '#$hexCode';
    }

    // Validate hex code (simple validation)
    final validHexPattern = RegExp(r'^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})$');
    if (!validHexPattern.hasMatch(hexCode)) {
      Get.snackbar(
        'Invalid Hex Code',
        'Please enter a valid hex color code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: RSColors.error.withOpacity(0.1),
        colorText: RSColors.error,
      );
      return;
    }

    setHexColorCode(attributeName, colorName, hexCode);

    // Toggle off editing mode
    final editKey = '${attributeName.toLowerCase()}_$colorName';
    if (isEditingHexCode.containsKey(editKey)) {
      isEditingHexCode[editKey]?.value = false;
    }
  }

  // Show dialog for hex code input (public method)
  void showHexCodeInputDialog(BuildContext context, String attributeName, String colorName) {
    final TextEditingController hexController = TextEditingController();

    // Get current color code if it exists
    final attribute = productAttributes.firstWhere(
          (attr) => attr.name?.toLowerCase() == attributeName.toLowerCase(),
      orElse: () => ProductAttributeModel(),
    );

    if (attribute.additionalInfo != null &&
        attribute.additionalInfo![colorName] != null &&
        attribute.additionalInfo![colorName]['colorCode'] != null) {
      hexController.text = attribute.additionalInfo![colorName]['colorCode'].replaceAll('#', '');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hex Code for $colorName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: hexController,
                decoration: InputDecoration(
                  labelText: 'Hex Color Code',
                  hintText: 'Enter color hex code without #',
                  prefixText: '#',
                ),
              ),
              SizedBox(height: 10),
              StatefulBuilder(
                  builder: (context, setState) {
                    Color previewColor = Colors.grey;
                    try {
                      if (hexController.text.isNotEmpty) {
                        previewColor = hexToColor('#${hexController.text}');
                      }
                    } catch (e) {
                      // Invalid hex code
                    }

                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: previewColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    );
                  }
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (hexController.text.isNotEmpty) {
                  setHexColorCode(attributeName, colorName, hexController.text);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to set a hex color code
  void setHexColorCode(String attributeName, String colorName, String colorCode) {
    final index = productAttributes.indexWhere(
            (attr) => attr.name?.toLowerCase() == attributeName.toLowerCase()
    );

    if (index >= 0) {
      final attribute = productAttributes[index];
      if (attribute.additionalInfo == null) {
        attribute.additionalInfo = {};
      }

      if (attribute.additionalInfo![colorName] == null) {
        attribute.additionalInfo![colorName] = {};
      }

      if (!colorCode.startsWith('#')) {
        colorCode = '#$colorCode';
      }

      // IMPORTANT: Remove image URL when setting hex color code
      attribute.additionalInfo![colorName].remove('imageUrl');
      attribute.additionalInfo![colorName]['inputType'] = 'Hex Code';
      attribute.additionalInfo![colorName]['colorCode'] = colorCode;

      productAttributes[index] = attribute;

      // Refresh UI
      update();
    }
  }


  // Function to upload a swatch image for a specific color
  void uploadSwatchImage(BuildContext context, String attributeName, String colorName) {
    // Use ImagePicker to select an image
    _pickImage().then((XFile? file) {
      if (file != null) {
        // In a real implementation, you would upload this file to your server
        // and get back a URL. For now, we'll simulate this process.
        _simulateImageUpload(file, attributeName, colorName);
      }
    }).catchError((error) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to pick image: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: RSColors.error.withOpacity(0.1),
        colorText: RSColors.error,
      );
    });
  }

  // Function to pick an image
  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  // Function to simulate image upload (this would be replaced with actual upload in production)
  void _simulateImageUpload(XFile file, String attributeName, String colorName) {
    // Show loading indicator
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Simulate network delay
    Future.delayed(Duration(seconds: 2), () {
      // Close loading dialog
      Get.back();

      // Update attribute with "uploaded" image URL
      final index = productAttributes.indexWhere(
              (attr) => attr.name?.toLowerCase() == attributeName.toLowerCase()
      );

      if (index >= 0) {
        final attribute = productAttributes[index];
        if (attribute.additionalInfo == null) {
          attribute.additionalInfo = {};
        }

        if (attribute.additionalInfo![colorName] == null) {
          attribute.additionalInfo![colorName] = {};
        }

        // IMPORTANT: Remove color code when setting image URL
        attribute.additionalInfo![colorName].remove('colorCode');

        // In a real implementation, you would save the actual image URL here
        attribute.additionalInfo![colorName]['imageUrl'] = 'https://via.placeholder.com/150';
        attribute.additionalInfo![colorName]['inputType'] = 'Image';

        // Update the attribute in the list to trigger UI refresh
        productAttributes[index] = attribute;

        // Show success message
        Get.snackbar(
          'Image Uploaded',
          'Successfully uploaded image for $colorName.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: RSColors.success.withOpacity(0.1),
          colorText: RSColors.success,
          duration: Duration(seconds: 2),
        );
      }
    });
  }
}