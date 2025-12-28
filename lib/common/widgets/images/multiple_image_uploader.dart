import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../containers/rounded_container.dart';
import 'image_uploader.dart';

class RSMultipleImageUploader extends StatelessWidget {
  final RxList<String> images;
  final String variationId;
  final VoidCallback onAddImage;
  final void Function(Map<String, dynamic>) onRemoveImage;  // Updated to pass a map
  final Function(int oldIndex, int newIndex) onReorder;

  const RSMultipleImageUploader({
    super.key,
    required this.images,
    required this.variationId,
    required this.onAddImage,
    required this.onRemoveImage,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return SizedBox(
            height: 80,
            child: images.isEmpty ? _emptyPlaceholder() : _uploadedImages(),
          );
        }),
        SizedBox(height: RSSizes.spaceBtwItems),
        GestureDetector(
          onTap: onAddImage,
          child: RSRoundedContainer(
            width: 80,
            height: 80,
            showBorder: true,
            borderColor: RSColors.grey,
            backgroundColor: RSColors.white,
            child: const Center(child: Icon(Iconsax.add)),
          ),
        ),
      ],
    );
  }


  Widget _emptyPlaceholder() {
    return Center(
      child: Text(
        "No images added",
        style: TextStyle(color: RSColors.grey),
      ),
    );
  }

  Widget _uploadedImages() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      separatorBuilder: (context, index) => SizedBox(width: RSSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) {
        final image = images[index];
        return RSImageUploader(
          image: image,
          width: 80,
          height: 80,
          imageType: ImageType.network,
          icon: Iconsax.trash,
          onIconButtonPressed: () {
            // Passing both index and variationId as a map
            onRemoveImage({
              'index': index,
              'variationId': variationId,
            });
          },
        );
      },
    );
  }
}



