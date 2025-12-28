import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/features/media/screens/media/widgets/folder_dropdown.dart';
import 'package:roguestore_admin_panel/features/media/screens/media/widgets/view_image_details.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../../common/widgets/images/rs_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/popups/loader_animation.dart';

class MediaContent extends StatelessWidget {
  MediaContent(
      {super.key,
      required this.allowSelection,
      required this.allowMultipleSelection,
      this.alreadySelectedUrls,
      this.onImageSelected});

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel> selectedImages = [];
  final Function(List<ImageModel> selectedImages)? onImageSelected;

  @override
  Widget build(BuildContext context) {
    bool  loadedPreviousSelection = false;
    final controller = MediaController.instance;
    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Images Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Select Folder',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(width: RSSizes.spaceBtwItems),
                  MediaFolderDropdown(
                    onChanged: (MediaCategory? newValue) {
                      if (newValue != null) {
                        controller.selectedPath.value = newValue;
                        controller.getMediaImages();
                      }
                    },
                  ),
                ],
              ),
              if (allowSelection) buildAddSelectedImagesButton(),
            ],
          ),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Show Media
          Obx(
            () {
              // Get Selected Folder Images
              List<ImageModel> images = _getSelectedFolderImages(controller);

              // Load Selected Images from the Already Selected Images only once otherwise
              // on Obx() rebuild UI first images will be selected then auto Un check.
              if(loadedPreviousSelection){
                if (alreadySelectedUrls != null && alreadySelectedUrls!.isNotEmpty) {
                  // convert alreadySelectedUrls to set for faster lookup
                  final selectedUrlsSet = Set<String>.from(alreadySelectedUrls!);

                  for (var image in images) {
                    image.isSelected.value = selectedUrlsSet.contains(image.url);
                    if (image.isSelected.value) {
                      selectedImages.add(image);
                    }
                  }
                } else {
                  // if alreadySelectedUrls is null or empty, set all images to not selected
                  for (var image in images) {
                    image.isSelected.value = false;
                  }
                }
                loadedPreviousSelection = true;
              }


              // Loader
              if (controller.loading.value && images.isEmpty) return const RSLoaderAnimation();

              // Empty Widget
              if (images.isEmpty) return _buildEmptyAnimationWidget(context);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: RSSizes.spaceBtwItems / 2,
                    runSpacing: RSSizes.spaceBtwItems / 2,
                    children: images
                        .map((image) => GestureDetector(
                              onTap: () => Get.dialog(ImagePopup(image: image)),
                              child: SizedBox(
                                width: 140,
                                height: 180,
                                child: Column(
                                  children: [
                                    allowSelection
                                        ? _buildListWithCheckbox(image)
                                        : _buildSimpleList(image),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: RSSizes.sm),
                                        child: Text(image.filename,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  // Load More Media Button
                  if (!controller.loading.value)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: RSSizes.spaceBtwSections),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: RSSizes.buttonWidth,
                            child: ElevatedButton.icon(
                              onPressed: () => controller.loadMoreMediaImages(),
                              label: Text('Load More'),
                              icon: Icon(Iconsax.arrow_down),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<ImageModel> _getSelectedFolderImages(MediaController controller) {
    List<ImageModel> images = [];
    if (controller.selectedPath.value == MediaCategory.banners) {
      images = controller.allBannerImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (controller.selectedPath.value == MediaCategory.brands) {
      images = controller.allBrandImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (controller.selectedPath.value == MediaCategory.categories) {
      images = controller.allCategoryImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (controller.selectedPath.value == MediaCategory.products) {
      images = controller.allProductImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (controller.selectedPath.value == MediaCategory.users) {
      images = controller.allUserImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    }
    return images;
  }

  Widget _buildEmptyAnimationWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RSSizes.lg * 3),
      child: RSAnimationLoaderWidget(
        width: 300,
        height: 300,
        text: 'Select Your Desired Folder',
        animation: RSImages.packageAnimation,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  _buildSimpleList(ImageModel image) {
    return RSRoundedImage(
      width: 140,
      height: 140,
      padding: RSSizes.sm,
      image: image.url,
      imageType: ImageType.network,
      margin: RSSizes.spaceBtwItems / 2,
      backgroundColor: RSColors.primaryBackground,
    );
  }

  Widget _buildListWithCheckbox(ImageModel image) {
    return Stack(
      children: [
        RSRoundedImage(
          width: 140,
          height: 140,
          padding: RSSizes.sm,
          image: image.url,
          imageType: ImageType.network,
          margin: RSSizes.spaceBtwItems / 2,
          backgroundColor: RSColors.primaryBackground,
        ),
        Positioned(
            top: RSSizes.md,
            right: RSSizes.md,
            child: Obx(() => Checkbox(
                  value: image.isSelected.value,
                  onChanged: (selected) {
                    if (selected != null) {
                      image.isSelected.value = selected;

                      if (selected) {
                        if (!allowMultipleSelection) {
                          // if multiple selection is not allowed, uncheck other checkboxes
                          for (var otherImage in selectedImages) {
                            if (otherImage != image) {
                              otherImage.isSelected.value = false;
                            }
                          }
                          selectedImages.clear();
                        }
                        selectedImages.add(image);
                      } else {
                        selectedImages.remove(image);
                      }
                    }
                  },
                )))
      ],
    );
  }

  Widget buildAddSelectedImagesButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // close Button
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
              label: Text('Close'),
              icon: Icon(Iconsax.close_circle),
              onPressed: () => Get.back()),
        ),
        SizedBox(width: RSSizes.spaceBtwItems),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
              label: Text('Add'),
              icon: Icon(Iconsax.image),
              onPressed: () => Get.back(result: selectedImages)),
        )
      ],
    );
  }
}
