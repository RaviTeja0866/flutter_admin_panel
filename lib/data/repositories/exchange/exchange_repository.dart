import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/exchange_model.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ExchangeRepository extends GetxController {
  static ExchangeRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // GET ALL EXCHANGES
  // ---------------------------------------------------------------------------
  Future<List<ExchangeRequestModel>> getAllExchanges() async {
    try {
      final result = await _db
          .collection('ExchangeRequests')
          .orderBy('requestDate', descending: true)
          .get();

      List<ExchangeRequestModel> exchanges = [];
      for (var doc in result.docs) {
        try {
          // FIX: use fromSnapshot(doc) instead of fromMap(data, id)
          final item = ExchangeRequestModel.fromSnapshot(doc);
          exchanges.add(item);
        } catch (e) {
          // Skip bad docs
        }
      }
      return exchanges;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // ---------------------------------------------------------------------------
  // GET EXCHANGE BY ID
  // ---------------------------------------------------------------------------
  Future<ExchangeRequestModel?> getExchangeById(String id) async {
    try {
      final doc = await _db.collection('ExchangeRequests').doc(id).get();
      if (doc.exists) {
        // FIX: use fromSnapshot(doc) instead of fromMap(data, id)
        return ExchangeRequestModel.fromSnapshot(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  // ---------------------------------------------------------------------------
  // ADD NEW EXCHANGE
  // ---------------------------------------------------------------------------
  Future<void> addExchange(ExchangeRequestModel exchange) async {
    try {
      // FIX: ExchangeRequestModel has toJson(), not toMap()
      await _db.collection('ExchangeRequests').add(exchange.toJson());
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to create exchange request.';
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE A SPECIFIC VALUE (STATUS, SIZE CHANGE ETC)
  // ---------------------------------------------------------------------------
  Future<void> updateExchangeSpecificValue(
      String exchangeId, Map<String, dynamic> data) async {
    try {
      await _db.collection('ExchangeRequests').doc(exchangeId).update(data);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to update exchange request.';
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE EXCHANGE REQUEST
  // ---------------------------------------------------------------------------
  Future<void> deleteExchange(String exchangeId) async {
    try {
      await _db.collection('ExchangeRequests').doc(exchangeId).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Unable to delete exchange request.';
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE TIMELINE STEP TIMESTAMP
  // NOTE: This assumes your Firestore document has a `steps` array
  // ---------------------------------------------------------------------------
  Future<void> updateStepTimestamp({
    required String exchangeId,
    required int stepIndex,
  }) async {
    try {
      final docRef = _db.collection('ExchangeRequests').doc(exchangeId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final List<dynamic> steps = data['steps'];

      steps[stepIndex]['timestamp'] = FieldValue.serverTimestamp();

      await docRef.update({
        'steps': steps,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to update timeline.';
    }
  }
}
