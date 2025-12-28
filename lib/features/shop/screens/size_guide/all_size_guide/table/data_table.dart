import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/size_guide/size_guide_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/all_size_guide/table/table_source.dart';

class SizeGuideTable extends StatelessWidget {
  const SizeGuideTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SizeGuideController());
    return Obx(
        () {
          Text(controller.filteredItems.length.toString());
          Text(controller.filteredItems.length.toString());

          //Table
          return RSPaginatedDataTable(
            minWidth: 700,
            tableHeight: 900,
            dataRowHeight: 110,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(label: Text('Size Guide')),
              DataColumn2(label: Text('Garment Type')),
              DataColumn2(label: Text('Created At')),
              DataColumn2(label: Text('Action'), fixedWidth: 100),
            ],
            source: SizeGuideRows(),
          );
        }
    );
  }
}
