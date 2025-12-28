import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_circular_image.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/settings_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../routes/routes.dart';
import 'menu/menu_item.dart';

class RSSidebar extends StatelessWidget {
  const RSSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
            color: RSColors.white,
            border: Border(
                right: BorderSide(
              color: RSColors.grey,
              width: 1,
            ))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Image
              Row(
                children: [
                  Obx(() => RsCircularImage(
                      width: 60,
                      height: 60,
                      padding: 0,
                      image: SettingsController
                              .instance.settings.value.appLogo.isNotEmpty
                          ? SettingsController.instance.settings.value.appLogo
                          : RSImages.darkAppLogo,
                      imageType: SettingsController
                              .instance.settings.value.appLogo.isNotEmpty
                          ? ImageType.network
                          : ImageType.asset,
                      backgroundColor: Colors.transparent)),
                  Expanded(
                    child: Obx(
                      () => Text(SettingsController.instance.settings.value.appName,
                        style: Theme.of(context)
                          .textTheme
                          .headlineLarge,
                        overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  )],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(RSSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Menu',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),

                    //Menu Items
                    RSMenuItem(
                        route: RSRoutes.dashboard,
                        icon: Iconsax.status,
                        itemName: 'Dashboard'),
                    RSMenuItem(
                        route: RSRoutes.media,
                        icon: Iconsax.image,
                        itemName: 'Media'),
                    RSMenuItem(
                        route: RSRoutes.banners,
                        icon: Iconsax.picture_frame,
                        itemName: 'Banners'),
                    RSMenuItem(
                        route: RSRoutes.products,
                        icon: Iconsax.shopping_bag,
                        itemName: 'Products'),
                    RSMenuItem(
                        route: RSRoutes.categories,
                        icon: Iconsax.category_2,
                        itemName: 'Categories'),
                    RSMenuItem(
                        route: RSRoutes.shopCategory,
                        icon: Iconsax.image,
                        itemName: 'ShopCategories'),
                    RSMenuItem(
                        route: RSRoutes.brands,
                        icon: Iconsax.dcube,
                        itemName: 'Brands'),
                    RSMenuItem(
                        route: RSRoutes.customers,
                        icon: Iconsax.profile_2user,
                        itemName: 'Customers'),
                    RSMenuItem(
                        route: RSRoutes.orders,
                        icon: Iconsax.box,
                        itemName: 'Orders'),
                    RSMenuItem(
                        route: RSRoutes.coupons,
                        icon: Iconsax.discount_shape,
                        itemName: 'Coupons'),
                    RSMenuItem(
                        route: RSRoutes.sizeGuide,
                        icon: Iconsax.size,
                        itemName: 'SizeGuide'),

                    //Other
                    Text('OTHER',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    RSMenuItem(
                        route: RSRoutes.profile,
                        icon: Iconsax.user,
                        itemName: 'Profile'),
                    RSMenuItem(
                        route: RSRoutes.settings,
                        icon: Iconsax.setting_2,
                        itemName: 'Settings'),
                    RSMenuItem(
                        route: RSRoutes.auditLogs,
                        icon: Iconsax.bill,
                        itemName: 'AuditLogs'),
                    RSMenuItem(
                        route: 'logout',
                        icon: Iconsax.logout,
                        itemName: 'Logout'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
