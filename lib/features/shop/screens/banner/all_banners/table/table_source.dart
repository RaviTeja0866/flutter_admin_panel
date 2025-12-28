import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class BannersRows extends DataTableSource {
  final controller = BannerController.instance;
  @override
  DataRow? getRow(int index) {
    final banner = controller.filteredItems[index];
    return DataRow2(
        selected: controller.selectedRows[index],
        onTap: () => Get.toNamed(RSRoutes.editBanner, arguments: banner),
        onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
        cells: [
      DataCell(
        RSRoundedImage(
          width: 180,
          height: 100,
          padding: RSSizes.sm,
          image: banner.imageUrl,
          imageType: ImageType.network,
          borderRadius: RSSizes.borderRadiusMd,
          backgroundColor: RSColors.primaryBackground,
        ),
      ),
      DataCell(Text(controller.formatRoute(banner.targetScreen))),
      DataCell(banner.active ? Icon(Iconsax.eye, color: RSColors.primary) : Icon(Iconsax.eye_slash)),
      DataCell(RSTableActionButtons(
        onEditPressed: () => Get.toNamed(RSRoutes.editBanner, arguments: banner),
        onDeletePressed: () => controller.confirmAndDeleteItem(banner),
      ))
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount =>controller.filteredItems.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
