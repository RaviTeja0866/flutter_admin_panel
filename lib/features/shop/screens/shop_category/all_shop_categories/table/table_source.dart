import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/shop_category/shop_category_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class ShopCategoryRows extends DataTableSource {
  final controller = ShopCategoryController.instance;

  @override
  DataRow? getRow(int index) {
    final shopCategory = controller.filteredItems[index];

    return DataRow2(
      selected: controller.selectedRows[index],

      onTap: () => Get.toNamed(
        RSRoutes.editShopCategory.replaceFirst(':id', shopCategory.id),
      ),

      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,

      cells: [
        DataCell(
          RSRoundedImage(
            width: 180,
            height: 100,
            padding: RSSizes.sm,
            image: shopCategory.imageUrl,
            imageType: ImageType.network,
            borderRadius: RSSizes.borderRadiusMd,
            backgroundColor: RSColors.primaryBackground,
          ),
        ),
        DataCell(Text(shopCategory.title)),
        DataCell(Text(shopCategory.gender)),
        DataCell(
          shopCategory.active
              ? Icon(Iconsax.eye, color: RSColors.primary)
              : Icon(Iconsax.eye_slash),
        ),
        DataCell(
          RSTableActionButtons(
            onEditPressed: () => Get.toNamed(
              RSRoutes.editShopCategory.replaceFirst(':id', shopCategory.id),
            ),
            onDeletePressed: () {
              ActionGuard.run(
                permission: Permission.shopCategoryDelete, // use correct enum
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(shopCategory);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
