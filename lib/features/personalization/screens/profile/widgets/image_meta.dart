import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController());
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
                    loading: controller.loading.value,
                    onIconButtonPressed: () => controller.updateProfilePicture(),
                    image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : RSImages.user,
                    imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network: ImageType.asset,
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwItems),
              Obx(() => Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineLarge)),
              Obx(() => Text(controller.user.value.email)),
              SizedBox(height: RSSizes.spaceBtwSections),
            ],
          )
        ],
      ),
    );
  }
}
