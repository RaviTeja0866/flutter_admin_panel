import 'package:get/get.dart';
import '../../../../data/abstract/base_data_table_controlller.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../data/repositories/user/auditlog_repository.dart';
import '../models/auditlogs_model.dart';

class AuditLogController extends RSBaseController<AuditLogModel> {
  static AuditLogController get instance => Get.find();

  final _auditLogRepository = Get.put(AuditLogRepository());

  RxBool statusLoader = false.obs;

  /// Filters
  RxString selectedUser = ''.obs;
  RxString selectedAction = ''.obs;
  RxString selectedBrowser = ''.obs;

  // ---------------------------------------------------------------------------
  // FETCH
  // ---------------------------------------------------------------------------

  @override
  Future<List<AuditLogModel>> fetchItems() async {
    try {
      isLoading.value = true;
      sortAscending.value = false;

      final items = await _auditLogRepository.fetchAuditLogs();
      return items;
    } catch (e) {
      RSLoaders.warning(
        message: 'Failed to load audit logs.',
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  @override
  bool containsSearchQuery(AuditLogModel item, String query) {
    final q = query.toLowerCase();

    return item.userName.toLowerCase().contains(q) ||
        item.userEmail.toLowerCase().contains(q) ||
        item.action.toLowerCase().contains(q) ||
        item.subject.toLowerCase().contains(q);
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  @override
  Future<void> deleteItem(AuditLogModel item) async {
    try {
      await _auditLogRepository.deleteAuditLog(item.id!);
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // SORTING
  // ---------------------------------------------------------------------------

  void sortByDate(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (AuditLogModel l) => l.createdAt.toString().toLowerCase(),
    );
  }

  void sortByUser(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (AuditLogModel l) => l.userName.toLowerCase(),
    );
  }

  void sortByAction(int columnIndex, bool ascending) {
    sortByProperty(
      columnIndex,
      ascending,
          (AuditLogModel l) => l.action.toLowerCase(),
    );
  }

  // ---------------------------------------------------------------------------
  // CREATE LOG (USED BY OTHER CONTROLLERS)
  // ---------------------------------------------------------------------------

  Future<void> logAction({
    required AuditLogModel log,
  }) async {
    try {
      await _auditLogRepository.createAuditLog(log);
    } catch (_) {
      // Silent fail — audit logs must never block business logic
    }
  }
}
