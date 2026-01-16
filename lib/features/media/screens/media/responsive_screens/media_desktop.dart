import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/media_controller.dart';
import '../widgets/media_content.dart';
import '../widgets/media_uploader.dart';

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
                      breadcrumbItems: [RSRoutes.media, 'Media Screen']),
                  AdminScreenGuard(
                    permission: Permission.mediaCreate, // or mediaUpload
                    behavior: GuardBehavior.disable,
                    child: SizedBox(
                      width: RSSizes.buttonWidth * 1.5,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ActionGuard.check(
                            showDeniedScreen: true,
                            permission: Permission.mediaCreate,
                          ) &&
                              (controller.showImagesUploaderSection.value =
                              !controller.showImagesUploaderSection.value);
                        },
                        icon: const Icon(Iconsax.cloud_add),
                        label: const Text('Upload Images'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),
        
              // Upload Area
              MediaUploader(),
        
              // Media
              MediaContent(
                allowSelection: false,
                allowMultipleSelection: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
