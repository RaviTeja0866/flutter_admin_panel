import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/size_guide_model.dart';
import '../../../../data/repositories/size_guide/size_guide_repository.dart';
import '../../../media/models/image_model.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/helpers/network_manager.dart';

class EditSizeGuideController extends GetxController {
  static EditSizeGuideController get instance => Get.find();

  final SizeGuideRepository _sizeGuideRepo = Get.put(SizeGuideRepository());

  final formKey = GlobalKey<FormState>();
  final TextEditingController garmentTypeController = TextEditingController();
  final TextEditingController measurementUnitController = TextEditingController(text: 'Inches');

  final imageURL = ''.obs;
  final RxList<String> sizes = <String>[].obs;
  final RxList<String> measurements = <String>[].obs;
  final RxMap<String, Map<String, String>> sizeChart = <String, Map<String, String>>{}.obs;

  // Initialize size guide data
  void init(SizeGuideModel sizeGuide) {
    garmentTypeController.text = sizeGuide.garmentType;
    measurementUnitController.text = sizeGuide.measurementUnit;
    imageURL.value = sizeGuide.imageURL;
    sizes.assignAll(sizeGuide.sizes);
    measurements.assignAll(sizeGuide.measurements);
    sizeChart.assignAll(sizeGuide.sizeChart);
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

  // Add size
  void addSize(String size) {
    if (!sizes.contains(size)) {
      sizes.add(size);
      sizeChart[size] = {};
      update();
    }
  }

  // Remove size
  void removeSize(String size) {
    sizes.remove(size);
    sizeChart.remove(size);
    update();
  }

  // Add measurement
  void addMeasurement(String measurement) {
    if (!measurements.contains(measurement)) {
      measurements.add(measurement);
      for (var size in sizes) {
        sizeChart[size]![measurement] = '0'; // Store default value as string
      }
      update();
    }
  }

  // Update size chart values for a specific size and measurement
  void updateSizeChart(String size, String measurement, String value) {
    if (sizeChart.containsKey(size)) {
      sizeChart[size]![measurement] = value; // Store the value as a string
    }
    update();
  }

  // Update Size Guide
  Future<void> updateSizeGuide(SizeGuideModel sizeGuide) async {
    try {
      // Start Loading
      RSFullScreenLoader.popUpCircular();

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Check if data is updated
      if (sizeGuide.imageURL != imageURL.value ||
          sizeGuide.garmentType != garmentTypeController.text ||
          sizeGuide.measurementUnit != measurementUnitController.text ||
          sizeGuide.sizes != sizes ||
          sizeGuide.measurements != measurements ||
          sizeGuide.sizeChart != sizeChart) {

        // Map updated data
        sizeGuide.imageURL = imageURL.value;
        sizeGuide.garmentType = garmentTypeController.text;
        sizeGuide.measurementUnit = measurementUnitController.text;
        sizeGuide.sizes = sizes.toList();
        sizeGuide.measurements = measurements.toList();
        sizeGuide.sizeChart = sizeChart;

        await _sizeGuideRepo.updateSizeGuide(sizeGuide.id, sizeGuide);
      }

      // Remove loading
      RSFullScreenLoader.stopLoading();

      // Success message
      RSLoaders.successSnackBar(title: 'Success', message: 'Size Guide has been updated');
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
