import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/all_admin_users/table/table_source.dart';
import '../../../../controllers/admin_users/adminroles_controller.dart';

class AdminUsersTable extends StatelessWidget {
  const AdminUsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminUsersController());

    return RSPaginatedDataTable(
      minWidth: 900,
      tableHeight: 640,
      columns: const [
        DataColumn(label: Text('User')),
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Last Login')),
        DataColumn(label: Text('Created')),
        DataColumn(label: Text('Actions')),
      ],
      source: AdminUsersRows(),
    );
  }
}
