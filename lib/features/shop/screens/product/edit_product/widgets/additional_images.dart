import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages({
    super.key,
    required this.additionalProductImagesURLs,
    this.onTapToAddImages,
    this.onTapToRemoveImage,
  });

  final RxList<String> additionalProductImagesURLs;
  final void Function()? onTapToAddImages;
  final void Function(int index)? onTapToRemoveImage;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 300,
        child: Column(
          children: [
            // Section to add additional product images
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: onTapToAddImages,
                child: RSRoundedContainer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          RSImages.defaultSingleImageIcon,
                          width: 50,
                          height: 50,
                        ),
                        const Text('Add Additional Product Images'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Section to display uploaded images
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 80,
                      child: _uploadImagesOrEmptyList(),
                    ),
                  ),
                  SizedBox(width: RSSizes.spaceBtwItems / 2),
                  RSRoundedContainer(
                    width: 80,
                    height: 80,
                    showBorder: true,
                    borderColor: RSColors.grey,
                    backgroundColor: RSColors.white,
                    onTap: onTapToAddImages,
                    child: const Center(child: Icon(Iconsax.add)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // Widget to display either uploaded or empty images
  Widget _uploadImagesOrEmptyList() {
    return additionalProductImagesURLs.isEmpty ? emptyList() : _uploadImages();
  }

  // Widget to display empty list placeholder
  Widget emptyList() {
    return ListView.separated(
      itemCount: 0,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) =>
          SizedBox(width: RSSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) => RSRoundedContainer(
        backgroundColor: RSColors.primaryBackground,
        width: 80,
        height: 80,
      ),
    );
  }

  // Widget to display uploaded images
  ListView _uploadImages() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: additionalProductImagesURLs.length,
      separatorBuilder: (context, index) =>
          SizedBox(width: RSSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) {
        final image = additionalProductImagesURLs[index];
        return RSImageUploader(
          top: 0,
          right: 0,
          width: 80,
          height: 80,
          left: null,
          bottom: null,
          image: image,
          icon: Iconsax.trash,
          imageType: ImageType.network,
          onIconButtonPressed: () => onTapToRemoveImage?.call(index),
        );
      },
    );
  }
}
