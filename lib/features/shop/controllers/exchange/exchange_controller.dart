import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/abstract/base_data_table_controlller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

import '../../../../data/repositories/exchange/exchange_repository.dart';
import '../../models/exchange_model.dart';


class ExchangeController extends RSBaseController<ExchangeRequestModel> {
  static ExchangeController get instance => Get.find();

  RxBool statusLoader = false.obs;
  var exchangeStatus = ExchangeStatus.pending.obs;

  final _exchangeRepository = Get.put(ExchangeRepository());

  @override
  Future<List<ExchangeRequestModel>> fetchItems() async {
    try {
      isLoading.value = true;
      sortAscending.value = false;

      final items = await _exchangeRepository.getAllExchanges();
      return items;
    } catch (e) {
      RSLoaders.warningSnackBar(
        title: 'Error',
        message: 'Failed to load exchange requests.',
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  bool containsSearchQuery(item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(ExchangeRequestModel item) async {
    try {
      await _exchangeRepository.deleteExchange(item.id);
    } catch (e) {
      rethrow;
    }
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
            (ExchangeRequestModel e) => e.id.toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
            (ExchangeRequestModel e) => e.requestDate.toString().toLowerCase());
  }

  Future<void> updateExchangeStatus(
      ExchangeRequestModel exchange, ExchangeStatus newStatus) async {
    try {
      statusLoader.value = true;

      exchange.status = newStatus;
      await _exchangeRepository.updateExchangeSpecificValue(
        exchange.id,
        {'status': newStatus.toString()},
      );

      updateItemFromLists(exchange);
      exchangeStatus.value = newStatus;

      RSLoaders.successSnackBar(
        title: 'Updated',
        message: 'Exchange Status Updated',
      );
    } catch (e) {
      RSLoaders.warningSnackBar(title: 'Error', message: e.toString());
    } finally {
      statusLoader.value = false;
    }
  }
}
