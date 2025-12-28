import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/personalization/models/settings_model.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class SettingsRepository extends GetxController{
  static SettingsRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Function to save settings data to firestore
  Future<void> registerSettings(SettingsModel setting) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').set(setting.toJson());
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. $e';
    }
  }

  // Function to fetch settings details based on Setting Id
  Future<SettingsModel> getSettings() async {
    try {
     final querySnapshot = await _db.collection('Settings').doc('GLOBAL_SETTINGS').get();
     return SettingsModel.fromSnapshot(querySnapshot);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. $e';
    }
  }

  // Function to update settings data in firestore
  Future<void> updateSettingDetails(SettingsModel updateSetting) async {
    try {
       await _db.collection('Settings').doc('GLOBAL_SETTINGS').update(updateSetting.toJson());
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. $e';
    }
  }

  // update any field in specific Settings Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').update(json);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. $e';
    }
  }

}