import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/features/personalization/models/user_model.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  Future<void> getCustomerOffCurrentOrder() async {
    print('[OrderDetailController] getCustomerOffCurrentOrder called');
    print('[OrderDetailController] Current order ID: ${order.value.userId}');

    try {
      loading.value = true;
      print('[OrderDetailController] Loading set to true');

      final user = await UserRepository.instance.fetchUserDetails(order.value.userId);
      print('[OrderDetailController] Fetched user details: $user');

      customer.value = user;
      print('[OrderDetailController] Customer details updated');
    } catch (e) {
      print('[OrderDetailController] Error occurred: $e');
      RSLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
      print('[OrderDetailController] Loading set to false');
    }
  }
}
