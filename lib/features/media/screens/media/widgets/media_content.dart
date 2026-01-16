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
import '../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
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
    bool loadedPreviousSelection = false;
    final controller = MediaController.instance;

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Select Folder',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(width: RSSizes.spaceBtwItems),
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

          Obx(() {
            final images = _getSelectedFolderImages(controller);

            // Initial loading
            if (controller.loading.value && images.isEmpty) {
              return const RSLoaderAnimation();
            }

            // Empty state
            if (images.isEmpty) {
              return _buildEmptyAnimationWidget(context);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// GRID
                Wrap(
                  spacing: RSSizes.spaceBtwItems / 2,
                  runSpacing: RSSizes.spaceBtwItems / 2,
                  children: images.map((image) {
                    return GestureDetector(
                      onTap: () => Get.dialog(ImagePopup(image: image)),
                      child: SizedBox(
                        width: 140,
                        height: 180,
                        child: Column(
                          children: [
                            allowSelection
                                ? _buildListWithCheckbox(image)
                                : _buildSimpleList(image),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: RSSizes.sm),
                              child: Text(
                                image.filename,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                /// LOAD MORE
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: RSSizes.spaceBtwSections,
                  ),
                  child: Center(
                    child: controller.loading.value
                        ? const CircularProgressIndicator()
                        : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: RSColors.primary, // text + icon color
                        side: BorderSide(
                          color: RSColors.primary,
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.loadMoreMediaImages,
                      child: const Text('Load More'),
                    )

                  ),
                ),
              ],
            );
          }),
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
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            label: const Text('Close'),
            icon: const Icon(Iconsax.close_circle),
            onPressed: () {
              onImageSelected?.call([]);
            },
          ),
        ),
        SizedBox(width: RSSizes.spaceBtwItems),

        AdminScreenGuard(
          permission: Permission.mediaCreate,
          behavior: GuardBehavior.disable, // 🚫 cursor only
          child: SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              label: const Text('Add'),
              icon: const Icon(Iconsax.image),
              onPressed: () {
                ActionGuard.run(
                  permission: Permission.mediaCreate,
                  action: () async {
                    onImageSelected?.call(
                      List<ImageModel>.from(selectedImages),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
