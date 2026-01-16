import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_action_buttons.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../controllers/brand/brand_controller.dart';

class BrandRows extends DataTableSource {
  final controller = Get.put(BrandController());

  @override
  DataRow? getRow(int index) {
    final brand = controller.filteredItems[index];
    return DataRow2(
        selected: controller.selectedRows[index],
        onSelectChanged: (value) =>
            controller.selectedRows[index] = value ?? false,
        onTap: () =>
            Get.toNamed('/editBrand/${brand.id}'),
        cells: [
          DataCell(
            Row(
              children: [
                RSRoundedImage(
                  width: 50,
                  height: 50,
                  padding: RSSizes.sm,
                  image: brand.image,
                  imageType: ImageType.network,
                  borderRadius: RSSizes.borderRadiusMd,
                  backgroundColor: RSColors.primaryBackground,
                ),
                SizedBox(width: RSSizes.spaceBtwItems),
                Expanded(
                    child: Text(
                  brand.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .bodyLarge!
                      .apply(color: RSColors.primary),
                ))
              ],
            ),
          ),
          DataCell(Padding(
            padding: EdgeInsets.symmetric(vertical: RSSizes.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: RSSizes.xs,
                direction: RSDeviceUtils.isMobileScreen(Get.context!) ? Axis.vertical : Axis.horizontal,
                children: brand.brandCategories != null
                    ? brand.brandCategories!
                        .map((e) => Padding(
                              padding: EdgeInsets.only(bottom: RSDeviceUtils.isMobileScreen(Get.context!) ? 0 : RSSizes.xs),
                              child: Chip(label: Text(e.name), padding: EdgeInsets.all(RSSizes.xs)),
                            )).toList()
                    : [SizedBox.shrink()],
              ),
            ),
          )),
          DataCell(brand.isFeatured ? Icon(Iconsax.heart5, color: RSColors.primary) :  Icon(Iconsax.heart)),
          DataCell(
            Text(
                brand.updatedAt != null
                    ? DateFormat('yyyy-MM-dd hh:mm:ss a').format(brand.updatedAt!)
                    : (brand.createdAt != null ? DateFormat('yyyy-MM-dd hh:mm:ss a').format(brand.createdAt!) : '')
            ),
          ),
          DataCell(RSTableActionButtons(
            onEditPressed: () =>
                Get.toNamed('/editBrand/${brand.id}'),
            onDeletePressed: () {
              ActionGuard.run(
                permission: Permission.brandDelete, // use correct enum
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(brand);
                },
              );
            },          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
