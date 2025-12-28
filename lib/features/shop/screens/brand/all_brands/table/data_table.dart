import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/all_brands/table/table_source.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../controllers/brand/brand_controller.dart';

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());
        Text(controller.selectedRows.length.toString());

        final lgTable  = controller.filteredItems.any((element) => element.brandCategories != null && element.brandCategories!.length > 2);

        return RSPaginatedDataTable(
        minWidth: 700,
        dataRowHeight: lgTable ? 96 : 64,
          tableHeight: lgTable ? 96 * 11.5 :  760,
          sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(label: Text('Brands'), fixedWidth: RSDeviceUtils.isMobileScreen(Get.context!) ? null : 200,
          onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending)),
          DataColumn2(label: Text('Categories')),
          DataColumn2(label: Text('Featured'), fixedWidth: RSDeviceUtils.isMobileScreen(Get.context!) ? null : 100),
          DataColumn2(label: Text('Date'), fixedWidth: RSDeviceUtils.isMobileScreen(Get.context!) ? null : 200),
          DataColumn2(label: Text('Action'), fixedWidth: RSDeviceUtils.isMobileScreen(Get.context!) ? null : 100),
        ],
        source: BrandRows(),
      );
        },
      );
  }
}
