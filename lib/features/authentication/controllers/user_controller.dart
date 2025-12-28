import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/user_model.dart';

import '../../../utils/popups/loaders.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final userRepository = Get.put(UserRepository());


  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  // Fetches user Details from the repository
 Future<Object> fetchUserDetails() async {
   try{
     loading.value = true;
     final user = await userRepository.fetchAdminDetails();
     this.user.value = user as UserModel;
     loading.value = false;
     return user;
   } catch (e) {
     loading.value = false;
     RSLoaders.errorSnackBar(title: 'Something went wrong', message: e.toString());
     return UserModel.empty();
   }
 }
}