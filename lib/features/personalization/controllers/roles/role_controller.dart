import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/abstract/base_data_table_controlller.dart';
import 'package:roguestore_admin_panel/features/personalization/models/role_model.dart';

import '../../../../data/repositories/roles/role_repository.dart';

class RolesController extends RSBaseController<RoleModel> {
  static RolesController get instance => Get.find();

  final _rolesRepository = RoleRepository.instance;

  @override
  Future<List<RoleModel>> fetchItems() async {
    return await _rolesRepository.getAllRoles();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (RoleModel r) => r.name.toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(RoleModel item, String query) {
    final q = query.toLowerCase();
    return item.name.toLowerCase().contains(q) ||
        item.description.toLowerCase().contains(q);
  }

  @override
  Future<void> deleteItem(RoleModel item) async {
    await _rolesRepository.deleteRole(item.id);
  }
}
