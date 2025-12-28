import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_action_buttons.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/exchange/exchange_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class ExchangeRows extends DataTableSource {
  final controller = ExchangeController.instance;

  @override
  DataRow getRow(int index) {
    final item = controller.filteredItems[index]; // ExchangeRequestModel

    return DataRow2(
      onTap: () => Get.toNamed(
        '${RSRoutes.exchangeDetails}/${item.docId}',
        arguments: item,
      ),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,
      cells: [
        // 1. Exchange ID
        DataCell(
          Text(
            item.docId,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .copyWith(color: RSColors.primary),
          ),
        ),

        // 2. Date
        DataCell(
          Text(
            RSHelperFunctions.getFormattedDate(item.requestDate),
          ),
        ),

        // 3. Items & Sizes
        DataCell(
          Text(
            "${item.cartItem.quantity} Item(s)\n${item.originalSize} → ${item.requestedSize}",
            style: Theme.of(Get.context!).textTheme.bodyMedium,
          ),
        ),

        // 4. Exchange Status
        DataCell(
          RSRoundedContainer(
            radius: RSSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: RSSizes.sm,
              horizontal: RSSizes.md,
            ),
            backgroundColor:
            RSHelperFunctions.getExchangeStatusColor(item.status)
                .withOpacity(0.1),
            child: Text(
              item.status.name.capitalize!,
              style: TextStyle(
                color: RSHelperFunctions.getExchangeStatusColor(item.status),
              ),
            ),
          ),
        ),

        // 5. Amount
        DataCell(
          Text(
            "₹${item.cartItem.price.toStringAsFixed(0)}",
          ),
        ),

        // 6. Action buttons
        DataCell(
          RSTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              '${RSRoutes.exchange}/${item.docId}',
              arguments: item,
            ),
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
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
      controller.selectedRows.where((x) => x == true).length;
}
