import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_action_buttons.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/customer/customer_controller.dart';

import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../personalization/models/admin_model.dart';

class CustomerRows extends DataTableSource {
  final controller = CustomerController.instance;
  @override
  DataRow? getRow(int index) {
    final customer = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(RSRoutes.customerDetails, arguments: customer, parameters: {'customerId': customer.id ?? ''}),
        selected: controller.selectedRows[index],
        onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
        cells: [
      DataCell(Row(
        children: [RSRoundedImage(
            width: 50,
            height: 50,
            image: customer.profilePicture,
            imageType: ImageType.network,
          borderRadius: RSSizes.borderRadiusMd,
          backgroundColor: RSColors.primaryBackground,
        ),
          SizedBox(width: RSSizes.spaceBtwItems),
          Expanded(child: Text(customer.fullName, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: RSColors.primary),
          maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      )),
      DataCell(Text(customer.email)),
      DataCell(Text(customer.phoneNumber)),
      DataCell(Text(DateTime.now().toString())),
      DataCell(RSTableActionButtons(
        view: true,
        edit: false,
        onViewPressed: () => Get.toNamed(RSRoutes.customerDetails, arguments: customer),
        onDeletePressed: () {
          ActionGuard.run(
            permission: Permission.customerDelete, // use correct enum
            showDeniedScreen: true,
            action: () async {
              controller.confirmAndDeleteItem(customer);
            },
          );
        },      ))
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}
