import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';
import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

///Header widget for the application
class RSHeader extends StatelessWidget implements PreferredSizeWidget {
  const RSHeader({super.key, this.scaffoldKey});

  /// Global Key to access the scaffold state
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserProfileController.instance;
    return Container(
      decoration: const BoxDecoration(
        color: RSColors.white,
        border: Border(bottom: BorderSide(color: RSColors.grey, width: 1)),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: RSSizes.md, vertical: RSSizes.sm),
      child: AppBar(
        ///Mobile Menu
        leading: !RSDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon: const Icon(Iconsax.menu))
            : null,

        ///Search Field
        title: RSDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search Anything ....'),
                ),
              )
            : null,

        ///Actions
        actions: [
          /// Search icon on Mobile
          if (!RSDeviceUtils.isDesktopScreen(context))
            IconButton(onPressed: () {}, icon: Icon(Iconsax.search_normal)),

          // Notification Icon
          IconButton(onPressed: () {}, icon: Icon(Iconsax.notification)),
          const SizedBox(width: RSSizes.spaceBtwItems / 2),

          // User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Image
              Obx(
                () => RSRoundedImage(
                  width: 40,
                  height: 40,
                  padding: 2,
                  imageType: controller.user.value.profilePicture.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : RSImages.user,
                ),
              ),
              SizedBox(width: RSSizes.sm),

              /// Name And Email
              if (!RSDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const RSShimmerEffect(width: 50, height: 13)
                          : Text(controller.user.value.fullName, style: Theme.of(context).textTheme.titleLarge),
                      controller.loading.value
                          ? const RSShimmerEffect(width: 50, height: 13)
                          : Text(controller.user.value.email, style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(RSDeviceUtils.getAppBarHeight() + 15);
}
