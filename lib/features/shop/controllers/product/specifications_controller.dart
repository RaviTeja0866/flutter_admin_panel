import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product_specification_model.dart';

class ProductSpecificationsController extends GetxController {
  static ProductSpecificationsController get instance => Get.find();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Lists for the specification types and their values (not observable for the lists themselves)
  final selectedTypes = List<String>.filled(6, '');
  final valueControllers = List.generate(6, (_) => TextEditingController());

  // Observable flag to trigger UI updates when needed
  final updateTrigger = 0.obs;

  // Debug flag to track when setSpecifications is called
  final hasSpecsBeenLoaded = false.obs;

  // Trigger UI update
  void _triggerUpdate() {
    updateTrigger.value++;
  }

  // Get available specification types for dropdown
  List<String> getAvailableTypes(int index) {
    // Get all specification types
    final allTypes = ProductSpecifications.getAvailableSpecificationTypesNoMirrors();

    // Filter out already selected types (except the current one)
    return allTypes.where((type) {
      if (selectedTypes[index] == type) {
        return true; // Include the current selection
      }
      return !selectedTypes.contains(type); // Filter out other selections
    }).toList();
  }

  // Update selected type for a specific index
  void updateSelectedType(int index, String type) {
    selectedTypes[index] = type;
    _triggerUpdate(); // Trigger reactive update
  }

  // Reset all values
  void resetValues() {
    for (int i = 0; i < 6; i++) {
      selectedTypes[i] = '';
      valueControllers[i].clear();
    }
    hasSpecsBeenLoaded.value = false;
    _triggerUpdate(); // Trigger reactive update
  }

  // Convert the selected specifications to a ProductSpecifications object
  ProductSpecifications getSpecifications() {
    // Create a new ProductSpecifications
    final specs = ProductSpecifications(id: '');

    // Map the selected types and values to the specifications object
    for (int i = 0; i < 6; i++) {
      if (selectedTypes[i].isNotEmpty) {
        final type = selectedTypes[i];
        final value = valueControllers[i].text.trim();

        // Set the value based on the selected type
        switch (type) {
          case 'Fabric':
            specs.fabric = value;
            break;
          case 'Pattern':
            specs.pattern = value;
            break;
          case 'Fit':
            specs.fit = value;
            break;
          case 'Neck':
            specs.neck = value;
            break;
          case 'Sleeve':
            specs.sleeve = value;
            break;
          case 'Style':
            specs.style = value;
            break;
          case 'WashCare':
            specs.washCare = value;
            break;
          case 'WaistRise':
            specs.waistRise = value;
            break;
          case 'Material':
            specs.material = value;
            break;
          case 'Color':
            specs.color = value;
            break;
          case 'Weight':
            specs.weight = value;
            break;
          case 'Dimension':
            specs.dimension = value;
            break;
          case 'Warranty':
            specs.warranty = value;
            break;
          case 'Brand':
            specs.brand = value;
            break;
          case 'Origin':
            specs.origin = value;
            break;
        }
      }
    }

    return specs;
  }

  // Set values from an existing ProductSpecifications object
  void setSpecifications(ProductSpecifications? specs) {
    // Reset all values first
    for (int i = 0; i < 6; i++) {
      selectedTypes[i] = '';
      valueControllers[i].clear();
    }

    // Return early if specs is null
    if (specs == null) {
      hasSpecsBeenLoaded.value = false;
      _triggerUpdate();
      return;
    }

    // Create a map of type -> value for all non-empty properties
    final Map<String, String> specsMap = {};
    if (specs.fabric.isNotEmpty) specsMap['Fabric'] = specs.fabric;
    if (specs.pattern.isNotEmpty) specsMap['Pattern'] = specs.pattern;
    if (specs.fit.isNotEmpty) specsMap['Fit'] = specs.fit;
    if (specs.neck.isNotEmpty) specsMap['Neck'] = specs.neck;
    if (specs.sleeve.isNotEmpty) specsMap['Sleeve'] = specs.sleeve;
    if (specs.style.isNotEmpty) specsMap['Style'] = specs.style;
    if (specs.washCare.isNotEmpty) specsMap['WashCare'] = specs.washCare;
    if (specs.waistRise.isNotEmpty) specsMap['WaistRise'] = specs.waistRise;
    if (specs.material.isNotEmpty) specsMap['Material'] = specs.material;
    if (specs.color.isNotEmpty) specsMap['Color'] = specs.color;
    if (specs.weight.isNotEmpty) specsMap['Weight'] = specs.weight;
    if (specs.dimension.isNotEmpty) specsMap['Dimension'] = specs.dimension;
    if (specs.warranty.isNotEmpty) specsMap['Warranty'] = specs.warranty;
    if (specs.brand.isNotEmpty) specsMap['Brand'] = specs.brand;
    if (specs.origin.isNotEmpty) specsMap['Origin'] = specs.origin;

    // Set values to controllers (up to 6 specifications)
    final entries = specsMap.entries.toList();
    final count = entries.length > 6 ? 6 : entries.length;

    for (int i = 0; i < count; i++) {
      selectedTypes[i] = entries[i].key;
      valueControllers[i].text = entries[i].value;
    }

    // Flag that specifications have been loaded
    hasSpecsBeenLoaded.value = true;

    // Trigger UI update to refresh dropdowns and text fields
    _triggerUpdate();

    // Debug log to confirm values were set
    print('Specs loaded: ${specsMap.toString()}');
    print('SelectedTypes after load: $selectedTypes');
    for (int i = 0; i < count; i++) {
      print('Value controller $i: ${valueControllers[i].text}');
    }
  }

  @override
  void onClose() {
    // Clean up controllers
    for (var controller in valueControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}