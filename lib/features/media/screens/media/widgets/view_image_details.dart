import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

class ImagePopup extends StatelessWidget {

  // The Image Model to display detailed information about.
  final ImageModel image;

  // constructor for image popup class.
  const ImagePopup({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        // Define the shape of Dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RSSizes.borderRadiusLg)),
        child: RSRoundedContainer(
          // Set the width of the rounded container based on screen size.
          width: RSDeviceUtils.isDesktopScreen(context) ? MediaQuery.of(context).size.width * 0.4 :double.infinity,
          padding: const EdgeInsets.all(RSSizes.spaceBtwItems),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the image with an Option to close the Dialog
              SizedBox(
                child: Stack(
                  children: [
                    // Display the Image with Round Container.
                    RSRoundedContainer(
                      backgroundColor: RSColors.primaryBackground,
                      child: RSRoundedImage(
                        image: image.url,
                          applyImageRadius: true,
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: RSDeviceUtils.isDesktopScreen(context) ? MediaQuery.of(context).size.width * 0.4 :double.infinity,
                          imageType: ImageType.network,
                      ),
                    ),
                    // Close Icon button positioned at the top-right corner
                    Positioned(top: 0, right: 0, child: IconButton(onPressed: ()=> Get.back(), icon: const Icon(Iconsax.close_circle)))
                  ],
                ),
              ),
              const Divider(),
              SizedBox(height: RSSizes.spaceBtwItems),

              // Display Various metadata about image
              // Includes image name, path, type, creation and modification dates and URL.
              // Also provides an option to copy the image URL.
              Row(
                children: [
                  Expanded(child: Text('Image Name:', style: Theme.of(context).textTheme.bodyLarge)),
                  Expanded(flex: 3,  child: Text(image.filename, style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),

              // Display the image url with an option to copy it.
              Row(
                children: [
                  Expanded(child: Text('Image Url:', style: Theme.of(context).textTheme.bodyLarge)),
                  Expanded(flex: 2, child: Text(image.url, style:Theme.of(context).textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Expanded(child: OutlinedButton(onPressed: () {FlutterClipboard.copy(image.url).then((value) => RSLoaders.customToast(message:'URL Copied'));},
                      child: Text('Copy URL')))
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Display a button to delete the image.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width:300,
                    child: TextButton(onPressed: () => MediaController.instance.removeCloudImageConfirmation(image),
                        child: Text('Delete Image', style: TextStyle(color: Colors.red))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
