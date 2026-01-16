import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/features/personalization/models/admin_model.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

import '../../../../data/repositories/order/order_repository.dart';
import '../../models/user_model.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  final Rxn<OrderModel> currentOrder = Rxn<OrderModel>();
  final Rx<UserModel> customer = UserModel.empty().obs;

  final _orderRepository = OrderRepository.instance;

  final RxBool loadingOrder = false.obs;
  final RxBool loadingCustomer = false.obs;

  late final String orderId;

  @override
  void onInit() {
    super.onInit();

    orderId = Get.parameters['docId'] ?? '';

    if (orderId.isNotEmpty) {
      loadOrderById(orderId);
    }
  }
  // --------------------------------------------------
  // LOAD ORDER BY DOC ID
  // --------------------------------------------------
  Future<void> loadOrderById(String orderId) async {
    if (loadingOrder.value) {
      debugPrint('[OrderDetail] 🔁 Already loading, skipping call');
      return;
    }

    debugPrint('[OrderDetail] ▶️ loadOrderById called');
    debugPrint('[OrderDetail] 🆔 orderId = $orderId');

    loadingOrder.value = true;
    debugPrint('[OrderDetail] ⏳ loadingOrder = true');

    try {
      final order = await _orderRepository.getOrderById(orderId);

      if (order == null) {
        debugPrint('[OrderDetail] ⚠️ Order NOT FOUND for id = $orderId');
        currentOrder.value = null;
      } else {
        debugPrint('[OrderDetail] ✅ Order loaded');
        debugPrint('[OrderDetail] 📦 order.id = ${order.id}');
        debugPrint('[OrderDetail] 📄 docId = ${order.docId}');
        debugPrint('[OrderDetail] 👤 userId = ${order.userId}');
        currentOrder.value = order;
      }
    } catch (e, stack) {
      debugPrint('[OrderDetail] ❌ ERROR loading order');
      debugPrint('[OrderDetail] ❌ $e');
      debugPrint('[OrderDetail] ❌ STACK TRACE:\n$stack');
      currentOrder.value = null;
    } finally {
      loadingOrder.value = false;
      debugPrint('[OrderDetail] ⏹ loadingOrder = false');
    }
  }



  // --------------------------------------------------
  // LOAD CUSTOMER
  // --------------------------------------------------
  Future<void> loadCustomer(String userId) async {
    try {
      loadingCustomer.value = true;

      final user =
      await UserRepository.instance.fetchUserDetails(userId);

      customer.value = user;
    } catch (e) {
      RSLoaders.error(message: e.toString());
    } finally {
      loadingCustomer.value = false;
    }
  }

}
