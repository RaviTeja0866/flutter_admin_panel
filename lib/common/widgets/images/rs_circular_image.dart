import 'dart:typed_data';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../utils/constants/sizes.dart';
import '../shimmers/shimmer_effect.dart';

class RsCircularImage extends StatelessWidget {
  const RsCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.memoryImage,
    this.backgroundColor,
    this.image,
    this.imageType = ImageType.asset,
    this.fit = BoxFit.cover,
    this.padding = RSSizes.sm,
    this.file,
  });

  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Uint8List? memoryImage;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white),
        borderRadius: BorderRadius.circular(width >= height ? width : height),
      ),
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
     borderRadius: BorderRadius.circular(width >= height ? width : height),
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

  //Function to build  the Memory Image widget
  Widget _buildFileImage() {
    if (file != null) {
      //Display image from the file using image Widget
      return Image(fit: fit, image: FileImage(file!), color: overlayColor);
    } else {
      // Return an Empty Container if no image is Provided
      return Container();
    }
  }

  //Function to build  the Memory Image widget
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

