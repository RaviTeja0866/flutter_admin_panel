import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/auditlogs_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuditLogRepository extends GetxController {
  static AuditLogRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Create audit log
  Future<void> createAuditLog(AuditLogModel log) async {
    try {
      await _db.collection('AuditLogs').add(log.toJson());
    } on FirebaseException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to create audit log. $e';
    }
  }

  /// Fetch all audit logs (latest first)
  Future<List<AuditLogModel>> fetchAuditLogs({int limit = 50}) async {
    try {
      final querySnapshot = await _db
          .collection('AuditLogs')
          .orderBy('CreatedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => AuditLogModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch audit logs. $e';
    }
  }

  /// Delete single audit log (admin only)
  Future<void> deleteAuditLog(String id) async {
    try {
      await _db.collection('AuditLogs').doc(id).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Failed to delete audit log. $e';
    }
  }

  /// Clear all logs (use with caution)
  Future<void> clearAllLogs() async {
    try {
      final batch = _db.batch();
      final snapshot = await _db.collection('AuditLogs').get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to clear audit logs. $e';
    }
  }
}
