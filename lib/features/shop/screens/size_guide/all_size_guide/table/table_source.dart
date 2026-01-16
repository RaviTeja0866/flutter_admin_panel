import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/size_guide/size_guide_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class SizeGuideRows extends DataTableSource {
  final controller = SizeGuideController.instance;

  @override
  DataRow? getRow(int index) {
    final sizeGuide = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.toNamed(RSRoutes.editSizeGuide, arguments: sizeGuide),
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        // Measurement Guide Image
        DataCell(
          sizeGuide.imageURL != null
              ? RSRoundedImage(
            width: 180,
            height: 100,
            padding: RSSizes.sm,
            image: sizeGuide.imageURL!,
            imageType: ImageType.network,
            borderRadius: RSSizes.borderRadiusMd,
            backgroundColor: RSColors.primaryBackground,
          )
              : Container(
            width: 180,
            height: 100,
            decoration: BoxDecoration(
              color: RSColors.primaryBackground,
              borderRadius: BorderRadius.circular(RSSizes.borderRadiusMd),
            ),
            child: const Icon(Iconsax.image),
          ),
        ),
        // Garment Type
        DataCell(Text(sizeGuide.garmentType)),
        // Last Updated
        DataCell(Text(sizeGuide.formattedUpdatedDate)),
        // Actions
        DataCell(RSTableActionButtons(
          onEditPressed: () =>
              Get.toNamed(RSRoutes.editSizeGuide, arguments: sizeGuide),
          onDeletePressed: () {
            ActionGuard.run(
              permission: Permission.sizeGuideDelete, // use correct enum
              showDeniedScreen: true,
              action: () async {
                controller.confirmAndDeleteItem(sizeGuide);
              },
            );
          },        )),
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