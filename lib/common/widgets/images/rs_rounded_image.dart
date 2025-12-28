import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../utils/constants/sizes.dart';

class RSRoundedImage extends StatelessWidget {
  const RSRoundedImage({
    super.key,
    this.image,
    this.file,
    this.border,
    this.width = 56,
    this.height = 56,
    this.memoryImage,
    this.overlayColor,
    required this.imageType,
    this.backgroundColor,
    this.padding = RSSizes.sm,
    this.margin,
    this.fit = BoxFit.contain,
    this.applyImageRadius = true,
    this.borderRadius = RSSizes.md,
  });

  final bool applyImageRadius;
  final BoxBorder? border;
  final double borderRadius;
  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Uint8List? memoryImage;
  final double width, height, padding;
  final double? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin != null ? EdgeInsets.all(margin!) : null,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.network:
        imageWidget = _buildNetworkImage();
        break;
      case ImageType.memory:
        imageWidget = _buildMemoryImage();
        break;
      case ImageType.file:
        imageWidget = _buildFileImage();
        break;
      case ImageType.asset:
        imageWidget = _buildAssetImage();
        break;
    }
    //Apply ClipRReact directly to image widget
    return ClipRRect(
      borderRadius: applyImageRadius
          ? BorderRadius.circular(borderRadius)
          : BorderRadius.zero,
      child: imageWidget,
    );
  }

//Function to build  the network Image widget
  Widget _buildNetworkImage() {
    if (image != null && image!.isNotEmpty) {
      return Image.network(
        image!,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return RSShimmerEffect(width: width, height: height);
        },
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.error),
      );
    } else {
      return Icon(Icons.broken_image, size: width, color: Colors.grey);
    }
  }

  //Function to build  the Memory Image widget
  Widget _buildMemoryImage() {
    if (memoryImage != null) {
      //Display image from the memory using image Widget
      return Image(fit: fit, image: MemoryImage(memoryImage!), color: overlayColor);
    } else {
      // Return an Empty Container if no image is Provided
      return Container();
    }
  }

  //Function to build  the File Image widget
  Widget _buildFileImage() {
    if (file != null) {
      //Display image from the file using image Widget
      return Image(fit: fit, image: FileImage(file!), color: overlayColor);
    } else {
      // Return an Empty Container if no image is Provided
      return Container();
    }
  }

  //Function to build  the Asset Image widget
  Widget _buildAssetImage() {
    if (image != null) {
      //Display image from the file using image Widget
      return Image(fit: fit, image: AssetImage(image!), color: overlayColor);
    } else {
      // Return an Empty Container if no image is Provided
      return Container();
    }
  }
}
