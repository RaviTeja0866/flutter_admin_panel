import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/abstract/base_data_table_controlller.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/features/personalization/models/user_model.dart';

class CustomerController extends RSBaseController<UserModel> {
  static CustomerController get instance => Get.find();

  final _customerRepository = Get.put(UserRepository());

  @override
  Future<List<UserModel>> fetchItems() async{
    return await _customerRepository.getAllUsers();
  }

  void sortByName(int sortColumnIndex, bool ascending){
    sortByProperty(sortColumnIndex, ascending, (UserModel u) =>u.fullName.toString().toLowerCase());
  }

  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.fullName.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(UserModel item) async{
    await _customerRepository.deleteUser(item.id ?? '');
  }


}