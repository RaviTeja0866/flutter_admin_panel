import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/size_guide_model.dart';
import '../../../../data/repositories/size_guide/size_guide_repository.dart';
import '../../../media/models/image_model.dart';

class CreateSizeGuideController extends GetxController {
  static CreateSizeGuideController get instance => Get.find();

  final SizeGuideRepository _sizeGuideRepo = Get.put(SizeGuideRepository());

  final formKey = GlobalKey<FormState>();
  final TextEditingController garmentTypeController = TextEditingController();
  final TextEditingController measurementUnitController = TextEditingController(text: 'Inches');

  final imageURL = ''.obs;
  final RxList<String> sizes = <String>[].obs;
  final RxList<String> measurements = <String>[].obs;
  final RxMap<String, Map<String, String>> sizeChart = <String, Map<String, String>>{}.obs;

  // Add size
  void addSize(String size) {
    if (!sizes.contains(size)) {
      sizes.add(size);
      sizeChart[size] = {};
      update();
    }
  }

  /// **Remove a size**
  void removeSize(String size) {
    sizes.remove(size);
    sizeChart.remove(size);
    update();
  }

  // Pick Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      imageURL.value = selectedImage.url;
    }
  }


// Add measurement
  void addMeasurement(String measurement) {
    if (!measurements.contains(measurement)) {
      measurements.add(measurement);
      for (var size in sizes) {
        sizeChart[size]![measurement] = '0'; // Default to "0"
      }
      update();
    }
  }

// Update size chart values for a specific size and measurement
  void updateSizeChart(String size, String measurement, String value) {
    if (sizeChart.containsKey(size)) {
      sizeChart[size]![measurement] = value; // Store value as string
    }
    update();
  }

  // Save size guide to Firestore
  Future<void> saveSizeGuide() async {
    if (formKey.currentState!.validate()) {
      final sizeGuide = SizeGuideModel(
        id: '', // Firestore will generate this when creating a new document
        garmentType: garmentTypeController.text.trim(),
        measurementUnit: measurementUnitController.text.trim(),
        sizes: sizes.toList(),
        imageURL: imageURL.value,
        measurements: measurements.toList(),
        sizeChart: sizeChart,
        createdAt: DateTime.now(),
      );

      try {
        await _sizeGuideRepo.createSizeGuide(sizeGuide);
        Get.snackbar('Success', 'Size guide saved successfully');
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    }
  }
}
