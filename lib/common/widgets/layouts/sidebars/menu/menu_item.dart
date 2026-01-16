import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:url_launcher/link.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class RSMenuItem extends StatelessWidget {
  const RSMenuItem({
    super.key,
    required this.route,
    required this.icon,
    required this.itemName,
    this.onTap,
  });

  final String route;
  final IconData icon;
  final String itemName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(); // ✅ CUSTOM ACTION (LOGOUT)
        } else {
          menuController.menuOnTap(route); // ✅ NORMAL NAV
        }
      },
      onHover: (hovering) => hovering
          ? menuController.changeHoverItem(route)
          : menuController.changeHoverItem(''),
      child: Obx(
            () => Padding(
          padding: const EdgeInsets.symmetric(vertical: RSSizes.xs),
          child: Container(
            decoration: BoxDecoration(
              color: menuController.isHovering(route) ||
                  menuController.isActive(route)
                  ? RSColors.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(RSSizes.cardRadiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: RSSizes.lg,
                    top: RSSizes.md,
                    bottom: RSSizes.md,
                    right: RSSizes.md,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: menuController.isActive(route) ||
                        menuController.isHovering(route)
                        ? RSColors.white
                        : RSColors.darkGrey,
                  ),
                ),

                Flexible(
                  child: Text(
                    itemName,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: menuController.isActive(route) ||
                          menuController.isHovering(route)
                          ? RSColors.white
                          : RSColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
