import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/all_roles/table/tabel_source.dart';

import '../../../../controllers/roles/role_controller.dart';

class RolesTable extends StatelessWidget {
  const RolesTable({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RolesController());

    return RSPaginatedDataTable(
      minWidth: 900,
      tableHeight: 640,
      columns: const [
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Permissions')),
        DataColumn(label: Text('Created')),
        DataColumn(label: Text('Actions')),
      ],
      source: RolesRows(),
    );
  }
}
