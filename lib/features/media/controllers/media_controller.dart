import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/media/media_repository.dart';
import 'package:roguestore_admin_panel/features/media/screens/media/widgets/media_uploader.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/popups/dialogs.dart';
import 'package:roguestore_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';
import 'package:universal_html/html.dart' as html;
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/popups/circular_loader.dart';
import '../screens/media/widgets/media_content.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  final RxBool loading = false.obs;
  final int initialLoadCount = 20;
  final int loadMoreCount = 25;

  late DropzoneViewController dropzoneViewController;
  final RxBool showImagesUploaderSection = false.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;

  final RxList<ImageModel> allImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;
  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;
  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;
  final RxList<ImageModel> allUserImages = <ImageModel>[].obs;

  final MediaRepository mediaRepository = MediaRepository();

// Get Images
  void getMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = <ImageModel>[].obs;

      // Determine the target list based on the selected category
      if (selectedPath.value == MediaCategory.banners) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users) {
        targetList = allUserImages;
      }

      final fetchedImages = await mediaRepository.fetchImagesFromDatabase(selectedPath.value, initialLoadCount);

      // Check for duplicates
      final uniqueImages = fetchedImages.where((newImage) {
        final isDuplicate = targetList.any((existingImage) => existingImage.id == newImage.id);
        if (isDuplicate) {
        }
        return !isDuplicate;
      }).toList();

      // Add unique images to the target list
      targetList.addAll(uniqueImages);

      loading.value = false;
    } catch (e) {
      loading.value = false;
      RSLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: 'Unable to Fetch Images, Something Went wrong. Please Try Again.',
      );
    }
  }

// Load More Images
  void loadMoreMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = getTargetListByCategory();

      if (targetList.isEmpty) {
        RSLoaders.warningSnackBar(
            title: 'No Images',
            message: 'No images found in the selected category.');
        loading.value = false;
        return;
      }

      final DateTime lastImageCreatedAt = targetList.isNotEmpty ? targetList.last.createdAt ?? DateTime.now() : DateTime.now();

      final images = await mediaRepository.loadMoreImagesFromDatabase(
        selectedPath.value,
        loadMoreCount,
        lastImageCreatedAt,
      );


      final newImages = images.where((img) {
        final isDuplicate = targetList.any((existingImage) => existingImage.id == img.id);
        return !isDuplicate;
      }).toList();

      targetList.addAll(newImages);

      if (newImages.isEmpty) {
        RSLoaders.infoSnackBar(
            title: 'No More Images',
            message: 'You have loaded all available images.');
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
      RSLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: 'Unable to Load More Images. Something went wrong. Please try again.',
      );
    }
  }

// Helper Function to Get Target List by Category
  RxList<ImageModel> getTargetListByCategory() {
    switch (selectedPath.value) {
      case MediaCategory.banners:
        return allBannerImages;
      case MediaCategory.brands:
        return allBrandImages;
      case MediaCategory.categories:
        return allCategoryImages;
      case MediaCategory.products:
        return allProductImages;
      case MediaCategory.users:
        return allUserImages;
      default:
        return <ImageModel>[].obs;
    }
  }

  // Local Storage Images
  Future<void> selectLocalImages() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/jpeg,image/png';
    uploadInput.multiple = true;

    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          // Check if the file is already in the list to avoid duplicates
          if (selectedImagesToUpload.any((image) => image.filename == file.name)) {
            RSLoaders.warningSnackBar(
                title: 'Duplicate File',
                message: 'The file "${file.name}" is already selected.');
            continue;
          }

          final reader = html.FileReader();
          try {
            reader.readAsArrayBuffer(file);
            reader.onLoadEnd.listen((_) {
              if (reader.result != null) {
                final bytes = Uint8List.fromList(reader.result as List<int>);
                final image = ImageModel(
                  url: '',
                  file: file,
                  folder: '',
                  filename: file.name,
                  localImageToDisplay: bytes,
                );
                selectedImagesToUpload.add(image);
              }
            });
          } catch (error) {
            RSLoaders.warningSnackBar(
                title: 'File Error',
                message: 'Error reading file: ${file.name}');
          }
        }
      } else {
        RSLoaders.infoSnackBar(
            title: 'No Files Selected',
            message: 'Please select valid image files.');
      }
    });
  }


  // Popup Confirmation Upload Images
  void uploadImagesConfirmation() {
    if (selectedPath.value == MediaCategory.folders) {
      RSLoaders.warningSnackBar(
          title: 'Select Folder',
          message: 'Please select the folder to upload Images.');
      return;
    }
    RSDialogs.defaultDialog(
      context: Get.context!,
      title: 'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async {
        await uploadImages();
      },
      content:
      'Are you sure you want to upload all the Images in ${selectedPath.value.name.toUpperCase()} folder?',
    );
  }

  // Upload Images
  Future<void> uploadImages() async {
    try {
      Get.back();
      uploadImagesLoader();
      MediaCategory selectedCategory = selectedPath.value;
      RxList<ImageModel> targetList;


      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }


      final uploadTasks = selectedImagesToUpload.map((selectedImage) async {
        final image = selectedImage.file!;
        try {
          final ImageModel uploadedImage = await mediaRepository.uploadImageFileInStorage(
            file: image,
            path: getSelectedPath(),
            imageName: selectedImage.filename,
          );

          uploadedImage.mediaCategory = selectedCategory.name;
          final id = await mediaRepository.uploadImageFileInDatabase(uploadedImage);
          uploadedImage.id = id;

          targetList.add(uploadedImage);
        } catch (error) {
          RSLoaders.warningSnackBar(
              title: 'Upload Error',
              message: 'Failed to upload image: ${selectedImage.filename}');
        }
      }).toList();

      await Future.wait(uploadTasks);

      selectedImagesToUpload.clear();
      RSFullScreenLoader.stopLoading();
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.warningSnackBar(
          title: 'Error Uploading Images',
          message: 'Something went wrong while uploading your images.');
    }
  }

  // Loader to Upload Images
  void uploadImagesLoader() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Uploading Images'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(RSImages.uploadingImageIllustration,
                    height: 300, width: 300),
                SizedBox(height: RSSizes.spaceBtwItems),
                Text('Sit Tight, Your Images are Uploading...'),
              ],
            ),
          ),
        ));
  }

  // Get Storage Path
  String getSelectedPath() {
    String path = '';
    switch (selectedPath.value) {
      case MediaCategory.banners:
        path = RSTexts.bannersStoragePath;
        break;
      case MediaCategory.brands:
        path = RSTexts.brandsStoragePath;
        break;
      case MediaCategory.categories:
        path = RSTexts.categoriesStoragePath;
        break;
      case MediaCategory.products:
        path = RSTexts.productsStoragePath;
        break;
      case MediaCategory.users:
        path = RSTexts.usersStoragePath;
        break;
      default:
        path = 'Others';
    }
    return path;
  }

  // Popup confirmation to remove cloud image
void removeCloudImageConfirmation(ImageModel image) {
    // Delete Confirmation
  RSDialogs.defaultDialog(context: Get.context!,
  content: 'Are you sure you want to delete this image?',
    onConfirm: (){
    // close the previous Dialog Image Popup
      Get.back();
      removeCloudImage(image);
    },
  );
}

 // Remove Cloud Image
  void removeCloudImage(ImageModel image) async {
    try{
      // close the removeCLoudImageConfirmation () dialog
      Get.back();

      // Show loader
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(canPop: false, child: SizedBox(width:150, height: 150, child: RSCircularLoader())),
      );

      // Delete Image
      await mediaRepository.deleteFileFromStorage(image);

      // Get the corresponding list to update
        RxList<ImageModel> targetList;

        // Check the selected category and update the corresponding list
      switch (selectedPath.value) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }

      // remove from the list
      targetList.remove(image);
      update();

      RSFullScreenLoader.stopLoading();
      RSLoaders.successSnackBar(title: 'Image Deleted', message: 'Image Successfully deleted from your Cloud storage');
    }catch(e){
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Images Selection Bottom Sheet
 Future<List<ImageModel>?> selectImagesFromMedia({List<String>? selectedUrls, bool allowSelection = true, bool multipleSelection = false}) async {
    showImagesUploaderSection.value = true;

    List<ImageModel>? selectedImages = await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: RSColors.primaryBackground,
      FractionallySizedBox(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            children: [
              MediaUploader(),
              MediaContent(
                allowSelection: allowSelection,
                alreadySelectedUrls: selectedUrls ?? [],
                allowMultipleSelection: multipleSelection,
              )

            ],
          ),
          ),
        ),
      ),
    );

    return selectedImages;
 }

}
