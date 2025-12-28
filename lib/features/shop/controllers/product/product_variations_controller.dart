import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:roguestore_admin_panel/utils/popups/dialogs.dart';

class ProductVariationsController extends GetxController {
  static ProductVariationsController get instance => Get.find();

  // Observables for loading state and product variations
  final isLoading = false.obs;
  final RxList<ProductVariationModel> productVariations = <ProductVariationModel>[].obs;

  // Lists to store controllers for each variation attribute
  List<Map<ProductVariationModel, TextEditingController>> stockControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> priceControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> salePriceControllersList = [];
  List<Map<ProductVariationModel, TextEditingController>> descriptionControllersList = [];

  final attributeController = Get.put(ProductAttributesController());

  // Initialize controllers for each variation
  void initializeVariationsControllers(List<ProductVariationModel> variations) {
    // Clear existing lists
    stockControllersList.clear();
    priceControllersList.clear();
    salePriceControllersList.clear();
    descriptionControllersList.clear();

    for (var variation in variations) {
      // Stock Controllers
      Map<ProductVariationModel, TextEditingController> stockController = {};
      stockController[variation] = TextEditingController(text: variation.stock.toString());
      stockControllersList.add(stockController);

      // Price Controllers
      Map<ProductVariationModel, TextEditingController> priceController = {};
      priceController[variation] = TextEditingController(text: variation.price.toString());
      priceControllersList.add(priceController);

      // SalePrice Controllers
      Map<ProductVariationModel, TextEditingController> salePriceController = {};
      salePriceController[variation] = TextEditingController(text: variation.salePrice.toString());
      salePriceControllersList.add(salePriceController);

      // Description Controllers
      Map<ProductVariationModel, TextEditingController> descriptionController = {};
      descriptionController[variation] = TextEditingController(text: variation.description.toString());
      descriptionControllersList.add(descriptionController);
    }
  }

  // Remove variations with confirmation
  void removeVariations(BuildContext context) {
    RSDialogs.defaultDialog(
      context: context,
      title: 'Remove Variations',
      onConfirm: () {
        productVariations.value = [];
        resetAllValues();
        Navigator.of(context).pop();
      },
    );
  }

  // Generate variations confirmation dialog
  void generateVariationsConfirmation(BuildContext context) {
    RSDialogs.defaultDialog(
      context: context,
      confirmText: 'Generate',
      title: 'Generate Variations',
      content: 'Once variations are created, you cannot add more attributes. To add more variations, delete an attribute.',
      onConfirm: () {
        generateVariationsFromAttributes();
      },
    );
  }

  // Generate variations from attributes
  void generateVariationsFromAttributes() {
    // Close the previous pop-up
    Get.back();

    final List<ProductVariationModel> variations = [];

    if (attributeController.productAttributes.isNotEmpty) {
      final List<List<String>> attributeCombinations =
      getCombinations(attributeController.productAttributes.map((attr) => attr.values ?? <String>[]).toList());

      for (final combination in attributeCombinations) {
        final Map<String, String> attributeValues = Map.fromIterables(
            attributeController.productAttributes.map((attr) => attr.name ?? ''), combination);

        // Create a map to store additional info for each attribute in this variation
        final Map<String, dynamic> variationMetadata = {};

        // Add color codes to metadata if applicable
        for (var attr in attributeController.productAttributes) {
          final String? attrName = attr.name;
          if (attrName == null) continue;

          // Get the value for this attribute in this variation
          final String? attrValue = attributeValues[attrName];
          if (attrValue == null) continue;

          // Check if this is a color attribute and has color code in additionalInfo
          final bool isColorAttr = attrName.toLowerCase() == 'color' || attrName.toLowerCase() == 'colors';
          if (isColorAttr && attr.additionalInfo != null && attr.additionalInfo![attrValue] != null) {
            variationMetadata[attrName] = {
              'value': attrValue,
              'colorCode': attr.additionalInfo![attrValue]['colorCode'],
            };
          }
        }

        final ProductVariationModel variation = ProductVariationModel(
          id: UniqueKey().toString(),
          attributeValues: attributeValues,
          metadata: variationMetadata.isNotEmpty ? variationMetadata : null,
        );

        variations.add(variation);

        // Create Controllers for each variation
        final Map<ProductVariationModel, TextEditingController> stockControllers = {};
        final Map<ProductVariationModel, TextEditingController> priceControllers = {};
        final Map<ProductVariationModel, TextEditingController> salePriceControllers = {};
        final Map<ProductVariationModel, TextEditingController> descriptionControllers = {};

        // Assuming variation is your current ProductVariationModel
        stockControllers[variation] = TextEditingController(text: '0');
        priceControllers[variation] = TextEditingController(text: '0.0');
        salePriceControllers[variation] = TextEditingController(text: '0.0');
        descriptionControllers[variation] = TextEditingController(text: '');

        // Add the maps to their respective lists
        stockControllersList.add(stockControllers);
        priceControllersList.add(priceControllers);
        salePriceControllersList.add(salePriceControllers);
        descriptionControllersList.add(descriptionControllers);
      }
    }

    productVariations.value = variations;
  }

  // Get all combinations of attribute values
  List<List<String>> getCombinations(List<List<String>> lists) {
    final List<List<String>> result = [];
    combine(lists, 0, <String>[], result);
    return result;
  }

  // Helper function to recursively combine attribute values
  void combine(List<List<String>> lists, int index, List<String> current, List<List<String>> result) {
    if (index == lists.length) {
      result.add(List.from(current));
      return;
    }

    for (final item in lists[index]) {
      final List<String> updated = List.from(current)..add(item);
      combine(lists, index + 1, updated, result);
    }
  }

  // Reset all values
  void resetAllValues() {
    productVariations.clear();
    stockControllersList.clear();
    priceControllersList.clear();
    salePriceControllersList.clear();
    descriptionControllersList.clear();
  }

  // Get color for variation based on color attribute (for UI display)
  Color? getColorForVariation(ProductVariationModel variation) {
    if (variation.metadata == null) return null;

    // Look for color attribute in metadata
    String? colorAttrName;
    Map<String, dynamic>? colorData;

    for (var entry in variation.metadata!.entries) {
      if (entry.key.toLowerCase() == 'color' || entry.key.toLowerCase() == 'colors') {
        colorAttrName = entry.key;
        colorData = entry.value;
        break;
      }
    }

    if (colorAttrName == null || colorData == null || colorData['colorCode'] == null) {
      return null;
    }

    return attributeController.hexToColor(colorData['colorCode']);
  }

  @override
  void onClose() {
    for (var map in stockControllersList) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    for (var map in priceControllersList) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    for (var map in salePriceControllersList) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    for (var map in descriptionControllersList) {
      for (var controller in map.values) {
        controller.dispose();
      }
    }
    super.onClose();
  }
}