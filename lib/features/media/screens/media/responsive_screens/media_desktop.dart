import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/screens/media/widgets/media_content.dart';
import 'package:roguestore_admin_panel/features/media/screens/media/widgets/media_uploader.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';

import '../../../../../utils/constants/sizes.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BreadCrumbs
                  RSBreadcrumbsWithHeading(
                    heading: 'Media',
                    breadcrumbItems: [RSRoutes.login, 'Media Screen']),
                  SizedBox(
                    width: RSSizes.buttonWidth * 1.5,
                    child: ElevatedButton.icon(
                      onPressed:() => controller.showImagesUploaderSection.value = !controller.showImagesUploaderSection.value,
                      icon: Icon(Iconsax.cloud_add),
                      label: Text('Upload Images'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Upload Area
              MediaUploader(),

              // Media
              MediaContent(allowSelection: false, allowMultipleSelection: false),

            ],
          ),
        ),
      ),
    );
  }
}
