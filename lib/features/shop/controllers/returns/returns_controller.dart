  import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
  import 'package:roguestore_admin_panel/data/repositories/returns/return_repository.dart';
  import 'package:roguestore_admin_panel/utils/constants/enums.dart';
  import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

  import '../../../../data/abstract/base_data_table_controlller.dart';
  import '../../models/return_model.dart';

  class ReturnController extends RSBaseController<ReturnModel> {
    static ReturnController get instance => Get.find();

    final _returnRepository = Get.put(ReturnRepository());

    RxBool statusLoader = false.obs;
    Rx<ReturnStatus> returnStatus = ReturnStatus.pending.obs;

    @override
    Future<List<ReturnModel>> fetchItems() async {
      try {
        isLoading.value = true;
        sortAscending.value = false;

        final items = await _returnRepository.getAllReturns();
        return items;
      } catch (e) {
        RSLoaders.warningSnackBar(
          title: 'Error',
          message: 'Failed to load returns. Please try again.',
        );
        rethrow;
      } finally {
        isLoading.value = false;
      }
    }

    Future<ReturnModel?> fetchReturnById(String returnId) async {
      return await _returnRepository.getReturnById(returnId);
    }

    @override
    bool containsSearchQuery(ReturnModel item, String query) {
      return item.id!.toLowerCase().contains(query.toLowerCase());
    }

    @override
    Future<void> deleteItem(ReturnModel item) async {
      try {
        await _returnRepository.deleteReturn(item.id!);
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
            (ReturnModel r) => r.requestDate.toString().toLowerCase(),
      );
    }

    void sortByPrice(int columnIndex, bool ascending) {
      sortByProperty(
        columnIndex,
        ascending,
            (ReturnModel r) => r.productPrice.toString().toLowerCase(),
      );
    }

    // ---------------------------------------------------------------------------
    // UPDATE RETURN STATUS (Pending → Approved → Rejected → Completed)
    // ---------------------------------------------------------------------------

    Future<void> updateReturnStatus(ReturnModel item, ReturnStatus newStatus) async {
      try {
        statusLoader.value = true;

        final now = DateTime.now();
        final Map<String, dynamic> updateData = {
          'status': newStatus.name,
          'updatedDate': now,
        };

        // Map STATUS → TIMELINE FIELDS
        switch (newStatus) {
          case ReturnStatus.approved:
            updateData['approvedAt'] = now;
            item.approvedAt = now;
            break;

          case ReturnStatus.pickupScheduled:
            updateData['pickupScheduledAt'] = now;
            item.pickupScheduledAt = now;
            break;

          case ReturnStatus.pickedUp:
            updateData['pickedUpAt'] = now;
            item.pickedUpAt = now;
            break;

          case ReturnStatus.received:
            updateData['receivedAt'] = now;
            item.receivedAt = now;
            break;

          case ReturnStatus.refunded:
            updateData['refundedAt'] = now;
            item.refundedAt = now;
            break;

          case ReturnStatus.completed:
            updateData['completedAt'] = now;
            item.completedAt = now;
            break;

          case ReturnStatus.rejected:
          case ReturnStatus.cancelled:
          case ReturnStatus.pending:
            break;
        }

        // FIRESTORE UPDATE
        await _returnRepository.updateReturnStatusWithTimestamps(item.id!, updateData);

// If status changed to RECEIVED → Trigger refund Lambda
        if (newStatus == ReturnStatus.received) {
          try {
            await callRefundLambda(item.id!);
            RSLoaders.successSnackBar(
              title: "Refund Triggered",
              message: "Return moved to ‘received’. Refund is being processed.",
            );
          } catch (e) {
            RSLoaders.errorSnackBar(
              title: "Refund Failed",
              message: e.toString(),
            );
          }
        }


        // LOCAL MODEL UPDATE
        item.status = newStatus;
        returnStatus.value = newStatus;

        updateItemFromLists(item);

        RSLoaders.successSnackBar(
          title: 'Updated',
          message: 'Return Status Updated',
        );

      } catch (e) {
        RSLoaders.warningSnackBar(
          title: 'Error',
          message: e.toString(),
        );
      } finally {
        statusLoader.value = false;
      }
    }

    Future<void> callRefundLambda(String returnId) async {
      final url = Uri.parse("https://bmfnlmu22h.execute-api.ap-south-1.amazonaws.com/prod/returnOrderProcessor"); // your refundLambda URL

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"returnId": returnId}),
      );

      print("[REFUND_LAMBDA] Status: ${response.statusCode}");
      print("[REFUND_LAMBDA] Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Refund failed: ${response.body}");
      }
    }


    // ---------------------------------------------------------------------------
    // UPDATE REFUND STATUS (none → processing → completed)
    // ---------------------------------------------------------------------------

    Future<void> updateRefundStatus({
      required ReturnModel item,
      required String refundStatus,
      double? refundAmount,
    }) async {
      try {
        statusLoader.value = true;

        await _returnRepository.updateRefundStatus(
          returnId: item.id!,
          refundStatus: refundStatus,
          refundAmount: refundAmount,
        );

        // Update local model
        item.refundStatus = refundStatus;
        item.refundAmount = refundAmount;

        updateItemFromLists(item);

        RSLoaders.successSnackBar(
          title: 'Updated',
          message: 'Refund status updated',
        );
      } catch (e) {
        RSLoaders.warningSnackBar(
          title: 'Error',
          message: e.toString(),
        );
      } finally {
        statusLoader.value = false;
      }
    }
  }
