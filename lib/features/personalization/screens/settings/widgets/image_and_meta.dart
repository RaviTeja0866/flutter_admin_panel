import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/settings_controller.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return RSRoundedContainer(
      padding: EdgeInsets.symmetric(vertical: RSSizes.lg,  horizontal: RSSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // User Image
              Obx(
                () => RSImageUploader(
                  right: 10,
                  bottom: 20,
                  left: null,
                  width: 200,
                  height: 200,
                  circular: true,
                  icon: Iconsax.camera,
                  loading: controller.loading.value,
                  onIconButtonPressed: () => controller.updateAppLogo(),
                  imageType: controller.settings.value.appLogo.isNotEmpty? ImageType.network : ImageType.asset,
                  image:controller.settings.value.appLogo.isNotEmpty? controller.settings.value.appLogo : RSImages.defaultImage,
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwItems),
              Obx(() => Text(controller.settings.value.appName, style: Theme.of(context).textTheme.headlineLarge)),
              SizedBox(height: RSSizes.spaceBtwSections),
            ],
          )
        ],
      ),
    );
  }
}
