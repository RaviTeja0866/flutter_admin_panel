import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/circular_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_circular_image.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../utils/constants/sizes.dart';
import '../icons/circular_icon.dart';

class RSImageUploader extends StatelessWidget {
  const RSImageUploader({
    super.key,
    this.image,
    this.onIconButtonPressed,
    this.memoryImage,
    this.width = 100,
    this.height = 100,
    this.circular = false,
    required this.imageType,
    this.icon = Iconsax.edit_2,
    this.top,
    this.bottom = 0,
    this.right,
    this.left = 0,
    this.loading = false,
  });

  final bool loading;

  // whether to display the image in circular shape
  final bool circular;

  // Url path of the image to display
  final String? image;

  // Type of image(asset, network, memory, etc...)
  final ImageType imageType;

  // width of image uploader widget
  final double width;

  // height of image uploader widget
  final double height;

  // Byte data of the image
  final Uint8List? memoryImage;

  // Icon to display on image uploader widget
  final IconData icon;

  // offset from top edge of the widget
  final double? top;

  // offset from bottom edge of the widget
  final double? bottom;

  // offset from right edge of the widget
  final double? right;

  // offset from left edge of the widget
  final double? left;

  // callback function for when the icon button is pressed
  final void Function()? onIconButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dis[play the image in either circular or rounded image
        circular
            ? RsCircularImage(
                image: image,
                width: width,
                height: height,
                imageType: imageType,
                memoryImage: memoryImage,
                backgroundColor: RSColors.primaryBackground,
              )
            : RSRoundedImage(
                image: image,
                width: width,
                height: height,
                imageType: imageType,
                memoryImage: memoryImage,
                backgroundColor: RSColors.primaryBackground,
              ),
        // Display the edit button on the top of the image
        Positioned(
            top: top,
            left: left,
            right: right,
            bottom: bottom,
            child: loading
                ? RSCircularContainer(
                    width: RSSizes.xl,
                    height: RSSizes.xl,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: RSColors.primary,
                        color: Colors.white),
                  )
                : RSCircularIcon(
                    icon: icon,
                    size: RSSizes.md,
                    color: Colors.white,
                    onPressed: onIconButtonPressed,
                    backgroundColor: RSColors.primary.withOpacity(0.9),
                  ))
      ],
    );
  }
}
