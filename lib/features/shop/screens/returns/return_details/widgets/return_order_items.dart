import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/return_model.dart';

class ReturnOrderItemsCard extends StatelessWidget {
  const ReturnOrderItemsCard({super.key, required this.returnOrder});

  final ReturnModel returnOrder;

  @override
  Widget build(BuildContext context) {
    final total = returnOrder.productPrice * returnOrder.quantity;

    final List<String> images =
        returnOrder.imageUrls.where((e) => e.trim().isNotEmpty).toList();

    final bool hasImages = images.isNotEmpty;

    final String video = returnOrder.videoUrl ?? "";
    final bool hasVideo = video.trim().isNotEmpty;

    return RSRoundedContainer(
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Returned Item',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),

          Row(
            children: [
              RSRoundedImage(
                backgroundColor: RSColors.primaryBackground,
                imageType: hasImages ? ImageType.network : ImageType.asset,
                image: hasImages ? images.first : RSImages.defaultImage,
              ),
              SizedBox(width: RSSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(returnOrder.productTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    Text("Size : ${returnOrder.productSize}",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              SizedBox(width: RSSizes.spaceBtwItems),
              SizedBox(
                width: RSSizes.xl * 2,
                child: Text("₹${returnOrder.productPrice.toStringAsFixed(1)}",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              SizedBox(
                width: RSDeviceUtils.isMobileScreen(context)
                    ? RSSizes.xl * 1.4
                    : RSSizes.xl * 2,
                child: Text(returnOrder.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              SizedBox(
                width: RSDeviceUtils.isMobileScreen(context)
                    ? RSSizes.xl * 1.4
                    : RSSizes.xl * 2,
                child: Text("₹${total.toStringAsFixed(1)}",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),

          SizedBox(height: RSSizes.spaceBtwSections),

          if (hasImages) ...[
            Text("Uploaded Images",
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: RSSizes.sm),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => SizedBox(width: RSSizes.md),
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => _openImageViewer(context, images,index),
                    child: RSRoundedImage(
                      imageType: ImageType.network,
                      image: images[index],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwSections),
          ] else ...[
            Text("No images uploaded",
                style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: RSSizes.spaceBtwSections),
          ],
          // ------------------------------
          // VIDEO SECTION
          // ------------------------------
          if (hasVideo)
            RSRoundedContainer(
              padding: EdgeInsets.all(RSSizes.md),
              backgroundColor: RSColors.primaryBackground,
              child: Row(
                children: [
                  Icon(Icons.play_circle_fill, size: 40, color: Colors.orange),
                  SizedBox(width: RSSizes.md),
                  Expanded(
                    child: Text(
                      "Customer uploaded a video. Tap to play.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            )
          else
            Text("No video uploaded",
                style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

void _openImageViewer(BuildContext context, List<String> images, int initialIndex) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      int currentIndex = initialIndex;

      return StatefulBuilder(
        builder: (context, setState) {
          return RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                // Close on ESC
                if (event.logicalKey.keyLabel == "Escape") {
                  Navigator.of(context).pop();
                }

                // Next image →
                if (event.logicalKey.keyLabel == "Arrow Right" &&
                    currentIndex < images.length - 1) {
                  setState(() => currentIndex++);
                }

                // Previous image ←
                if (event.logicalKey.keyLabel == "Arrow Left" &&
                    currentIndex > 0) {
                  setState(() => currentIndex--);
                }
              }
            },
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.black.withOpacity(0.95),
              child: Stack(
                children: [
                  // Zoomable image
                  InteractiveViewer(
                    maxScale: 5.0,
                    child: Center(
                      child: Image.network(
                        images[currentIndex],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // CLOSE button
                  Positioned(
                    top: 30,
                    right: 30,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 32),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // LEFT arrow ←
                  if (currentIndex > 0)
                    Positioned(
                      left: 20,
                      top: MediaQuery.of(context).size.height / 2 - 30,
                      child: IconButton(
                        icon: Icon(Icons.arrow_left,
                            color: Colors.white, size: 60),
                        onPressed: () {
                          setState(() => currentIndex--);
                        },
                      ),
                    ),

                  // RIGHT arrow →
                  if (currentIndex < images.length - 1)
                    Positioned(
                      right: 20,
                      top: MediaQuery.of(context).size.height / 2 - 30,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right,
                            color: Colors.white, size: 60),
                        onPressed: () {
                          setState(() => currentIndex++);
                        },
                      ),
                    ),

                  // IMAGE COUNTER
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "${currentIndex + 1} / ${images.length}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

