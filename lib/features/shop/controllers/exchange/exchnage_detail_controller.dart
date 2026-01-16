import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/order/order_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/exchange/exchange_repository.dart';

import '../../models/order_model.dart';
import '../../models/exchange_model.dart';
import '../../../personalization/models/admin_model.dart';
import '../../models/user_model.dart';

class ExchangeDetailController extends GetxController {
  static ExchangeDetailController get instance => Get.find();

  RxBool loading = true.obs;

  Rx<ExchangeRequestModel> exchange = ExchangeRequestModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  Rx<OrderModel> order = OrderModel.empty().obs;

  final userRepo = UserRepository.instance;
  final orderRepo = OrderRepository.instance;
  final exchangeRepo = ExchangeRepository.instance;

  /// ----------------------------------------------------------------
  /// FETCH EXCHANGE FROM FIRESTORE WHEN OPENING ROUTE DIRECTLY
  /// ----------------------------------------------------------------
  Future<ExchangeRequestModel?> fetchExchangeById(String id) async {
    try {
      loading.value = true;
      final model = await exchangeRepo.getExchangeById(id);

      if (model != null) {
        exchange.value = model;
      }

      return model;
    } catch (e) {
      RSLoaders.error(message: e.toString());
      return null;
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------------------------------------------
  /// LOAD CUSTOMER + ORDER FOR SIDE PANEL UI
  /// ----------------------------------------------------------------
  Future<void> loadCustomerAndOrder() async {
    try {
      loading.value = true;

      if (exchange.value.userId.isNotEmpty) {
        customer.value = await userRepo.fetchUserDetails(exchange.value.userId);
      }

      if (exchange.value.orderId.isNotEmpty) {
        order.value = (await orderRepo.getOrderById(exchange.value.orderId))!;
      }
    } catch (e) {
      RSLoaders.error(message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  /// ----------------------------------------------------------------
  /// UPDATE TIMELINE STEP (Completes a stage)
  /// ----------------------------------------------------------------
  Future<void> updateTimelineStep(int index) async {
    try {
      await exchangeRepo.updateStepTimestamp(
        exchangeId: exchange.value.docId,
        stepIndex: index,
      );
    } catch (e) {
      RSLoaders.error(message: e.toString());
    }
  }
}
