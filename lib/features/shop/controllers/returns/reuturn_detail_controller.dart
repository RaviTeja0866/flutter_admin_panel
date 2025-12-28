import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/order/order_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/returns/return_repository.dart';

import '../../models/return_model.dart';
import '../../models/order_model.dart';
import '../../../personalization/models/user_model.dart';

class ReturnDetailController extends GetxController {
  static ReturnDetailController get instance => Get.find();

  /// LOADING
  RxBool loading = true.obs;

  /// MAIN MODELS
  Rx<ReturnModel> returnOrder = ReturnModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  Rx<OrderModel> order = OrderModel.empty().obs;

  /// REPOSITORIES
  final userRepo = UserRepository.instance;
  final orderRepo = OrderRepository.instance;
  final returnRepo = ReturnRepository.instance;

  // ---------------------------------------------------------------------------
  // FETCH RETURN BY ID (When screen opened directly)
  // ---------------------------------------------------------------------------
  Future<ReturnModel?> fetchReturnById(String id) async {
    try {
      loading.value = true;

      final model = await returnRepo.getReturnById(id);
      if (model != null) {
        returnOrder.value = model;
      }

      return model;
    } catch (e) {
      RSLoaders.errorSnackBar(title: "Error", message: e.toString());
      return null;
    } finally {
      loading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD CUSTOMER + ORDER DETAILS
  // ---------------------------------------------------------------------------
  Future<void> loadCustomerDetails() async {
    try {
      loading.value = true;

      // Load user data
      if (returnOrder.value.userId.isNotEmpty) {
        customer.value = await userRepo.fetchUserDetails(returnOrder.value.userId);
      }

      // Load order details
      if (returnOrder.value.orderId.isNotEmpty) {
        final orderData = await orderRepo.getOrderById(returnOrder.value.orderId);
        if (orderData != null) {
          order.value = orderData;
        }
      }

    } catch (e) {
      RSLoaders.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE TIMELINE STEP (uses ReturnRepository)
  // ---------------------------------------------------------------------------
  Future<void> updateTimelineStep({
    required int stepIndex,
    required String timestampField,
  }) async {
    try {
      await returnRepo.updateTimelineTimestamp(
        returnId: returnOrder.value.id!,
        timestampField: timestampField,
      );
    } catch (e) {
      RSLoaders.errorSnackBar(
          title: 'Timeline Update Error', message: e.toString());
    }
  }
}
