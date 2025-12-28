import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_variation_model.dart';

class ProductImagesController extends GetxController {
  static ProductImagesController get instance => Get.find();

  // RX Observers for the selected Thumbnail image
  Rx<String?> selectedThumbnailImageUrl = Rx<String?>(null);

  // Lists to store additional product images
  final RxList<String> additionalProductImageUrls = <String>[].obs;

  // Map to store variation images with String keys (variation IDs)
  final RxMap<String, RxList<String>> variationImages = <String, RxList<String>>{}.obs;

  // Function to remove Product image
  Future<void> removeImage(int index) async {
    additionalProductImageUrls.removeAt(index);
  }

  // Function to remove an image from a variation
  void removeVariationImage(ProductVariationModel variation, int index) {
    final variationId = variation.id;


    // Check if the variation has images and if the index is within bounds
    if (variation.images != null && variation.images!.isNotEmpty) {
      final totalImages = variation.images!.length;

      if (index >= 0 && index < totalImages) {
        final imageToRemove = variation.images!.removeAt(index);
      }
    }
  }


  // Pick Thumbnail image from media
  void selectThumbnailImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected Images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      selectedThumbnailImageUrl.value = selectedImage.url;
    }
  }

  // Pick Multiple images for the main product
  void selectMultipleProductImages() async {
    final controller = Get.put(MediaController());
    final selectedImages = await controller.selectImagesFromMedia(
        multipleSelection: true, selectedUrls: additionalProductImageUrls);

    // Handle the selected Images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      additionalProductImageUrls.assignAll(selectedImages.map((e) => e.url));
    }
  }

// Pick Multiple images for a variation
  void selectMultipleVariationImages(ProductVariationModel variation) async {
    final controller = Get.put(MediaController());
    final variationId = variation.id; // Assuming each variation has a unique ID

    final selectedImages = await controller.selectImagesFromMedia(
      multipleSelection: true,
      selectedUrls: variationImages[variationId]?.toList() ?? [],
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {

      // Initialize or update variationImages for this variation
      if (!variationImages.containsKey(variationId)) {
        variationImages[variationId] = <String>[].obs;
      }

      variationImages[variationId]?.assignAll(selectedImages.map((e) => e.url));

      // Update variation's images list reactively
      variation.images.assignAll(variationImages[variationId]?.toList() ?? []);
    }
  }

// Add image to variation
  void addImageToVariation(ProductVariationModel variation) async {
    final controller = Get.put(MediaController());
    final variationId = variation.id; // Assuming variation.id is unique for each variation

    // Fetch images for the variation
    final selectedImages = await controller.selectImagesFromMedia(
      multipleSelection: true,
      selectedUrls: variationImages[variationId]?.toList() ?? [],
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {

      // Initialize or update variationImages for this variation
      variationImages.putIfAbsent(variationId, () => <String>[].obs);

      // Add new images to the existing variation images
      variationImages[variationId]?.addAll(selectedImages.map((e) => e.url));

      // Update the variation's images list reactively
      variation.images.addAll(selectedImages.map((e) => e.url)); // Add to the existing list instead of replacing it
    }
  }

  void reorderImagesForVariation(String variationId, int oldIndex, int newIndex) {
    final images = variationImages[variationId];
    if (images != null) {
      final image = images.removeAt(oldIndex);
      images.insert(newIndex, image);
    }
  }

  // Pick Thumbnail image from media
  void selectVariationImage(ProductVariationModel variation) async {
      final controller = Get.find<MediaController>();
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      if (selectedImages != null && selectedImages.isNotEmpty) {
        ImageModel selectedImage = selectedImages.first;
        selectedThumbnailImageUrl.value = selectedImage.url;

        // Update variation's images reactively
        if (variation.images.isEmpty) {
          variation.images.add(selectedImage.url); // Add to the RxList
        } else {
          variation.images.assignAll([selectedImage.url]); // Replace contents of the RxList
        }
      }
  }

}
