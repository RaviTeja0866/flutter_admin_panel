import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/abstract/base_data_table_controlller.dart';
import 'package:roguestore_admin_panel/data/repositories/admin/admin_repository.dart';
import 'package:roguestore_admin_panel/features/personalization/models/admin_model.dart';

class AdminUsersController extends RSBaseController<AdminUserModel> {
  static AdminUsersController get instance => Get.find();

  final _adminRepository = AdminRepository.instance;

  @override
  Future<List<AdminUserModel>> fetchItems() async {
    return await _adminRepository.getAllAdmins();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (AdminUserModel u) => u.fullName.toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(AdminUserModel item, String query) {
    final q = query.toLowerCase();
    return item.fullName.toLowerCase().contains(q) ||
        item.email.toLowerCase().contains(q);
  }

  @override
  Future<void> deleteItem(AdminUserModel item) async {
    await _adminRepository.deleteAdmin(item.roleId);
  }
}
