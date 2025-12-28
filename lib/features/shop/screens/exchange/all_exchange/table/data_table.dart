import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/exchange/exchange_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/all_exchange/table/table_source.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';

class ExchangeTable extends StatelessWidget {
  const ExchangeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExchangeController());

    return Obx(() {
      // Force reactive updates
      controller.filteredItems.length;
      controller.selectedRows.length;

      return RSPaginatedDataTable(
        minWidth: 700,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,

        columns: [
          DataColumn2(label: Text('Exchange ID')),
          DataColumn2(
            label: Text('Requested Date'),
            onSort: (columnIndex, ascending) =>
                controller.sortByDate(columnIndex, ascending),
          ),
          DataColumn2(label: Text('Items / Sizes')),
          DataColumn2(
            label: Text('Status'),
            fixedWidth:
            RSDeviceUtils.isMobileScreen(context) ? 120 : null,
          ),
          DataColumn2(label: Text('Amount')),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],

        source: ExchangeRows(),
      );
    });
  }
}
