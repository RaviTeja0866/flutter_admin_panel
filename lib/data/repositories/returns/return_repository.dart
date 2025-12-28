import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../features/shop/models/return_model.dart';

class ReturnRepository extends GetxController {
  static ReturnRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ReturnModel>> getAllReturns() async {
    try {
      final snapshot = await _db
          .collection("Returns")
          .orderBy("requestDate", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReturnModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw 'Failed to load return list.';
    }
  }

  Future<ReturnModel?> getReturnById(String id) async {
    try {
      final doc = await _db.collection("Returns").doc(id).get();
      if (!doc.exists) return null;
      return ReturnModel.fromSnapshot(doc);
    } catch (e) {
      throw 'Failed to load return details.';
    }
  }

  Future<void> deleteReturn(String id) async {
    try {
      await _db.collection("Returns").doc(id).delete();
    } catch (e) {
      throw 'Unable to delete return request.';
    }
  }

  // Update status + timestamps (used by controller)
  Future<void> updateReturnStatusWithTimestamps(
      String returnId, Map<String, dynamic> data) async {
    try {
      await _db.collection("Returns").doc(returnId).update(data);
    } catch (e) {
      throw 'Failed to update return status.';
    }
  }

  Future<void> updateTimelineTimestamp({
    required String returnId,
    required String timestampField,
  }) async {
    try {
      await _db.collection("Returns").doc(returnId).update({
        timestampField: FieldValue.serverTimestamp(),
        'updatedDate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update return timeline.';
    }
  }
  // Update refund status
  Future<void> updateRefundStatus({
    required String returnId,
    required String refundStatus,
    double? refundAmount,
  }) async {
    try {
      await _db.collection("Returns").doc(returnId).update({
        'refundStatus': refundStatus,
        'refundAmount': refundAmount,
        'refundProcessedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update refund status.';
    }
  }
}
