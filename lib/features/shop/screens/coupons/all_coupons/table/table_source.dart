import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../utils/constants/enums.dart';

class CouponRows extends DataTableSource {
  final controller = CouponController.instance;

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length) {
      return null;
    }
    final coupon = controller.filteredItems[index];

    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.toNamed(
        '${RSRoutes.editCoupon}/${coupon.id}',
      ),
      onSelectChanged: (value) =>
          controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text(coupon.title)), // Coupon title
        DataCell(Text(coupon.discountType == 'percentage'
            ? '${coupon.discountValue}%' // Percentage discount
            : '${coupon.discountValue}')), // Flat discount
        DataCell(Text('${coupon.minimumPurchase}')), // Minimum purchase amount
        DataCell(coupon.status
            ? Icon(Iconsax.heart5, color: RSColors.primary) // Active coupon
            : Icon(Iconsax.heart)), // Inactive coupon
        DataCell(Text(coupon.formattedStartDate)), // Formatted start date
        DataCell(Text(coupon.formattedEndDate)), // Formatted end date
        DataCell(
          RSTableActionButtons(
            onEditPressed: () => Get.toNamed(
              '${RSRoutes.editCoupon}/${coupon.id}',
            ),
            onDeletePressed: () {
              ActionGuard.run(
                permission: Permission.couponDelete, // use correct enum
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(coupon);
                },
              );
            },          ),
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
