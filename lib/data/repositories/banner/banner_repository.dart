import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController{
  static BannerRepository  get instance => Get.find();

  // Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all Brands from the 'Banners' collection
  Future<List<BannerModel>> getAllBanners() async {
    try {
      final snapshot = await _db.collection('Banners').get();
      final result = snapshot.docs.map((doc) => BannerModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get banners by ID (REQUIRED for edit + reload)
  Future<BannerModel> getBannerById(String id) async {
    try {
      final doc = await _db.collection('Banners').doc(id).get();

      if (!doc.exists) {
        throw 'Banner not found';
      }
      return BannerModel.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Create a Banner in the 'Banners' collection
  Future<String> createBanner(BannerModel banner) async {
    try {
      final result = await _db.collection('Banners').add(banner.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

// Update an Existing Banner in the 'Banners' collection
  Future<void> updateBanner(BannerModel banner) async {
    try {
      print("Updating banner with ID: ${banner.id}");
      print("Banner Data: ${banner.toJson()}");

      await _db.collection('Banners').doc(banner.id).update(banner.toJson());

      print("Banner updated successfully!");
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code} - ${e.message}");
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code} - ${e.message}");
      throw RSPlatformException(e.code).message;
    } catch (e) {
      print("Unknown error: $e");
      throw 'Something went wrong. Please try again';
    }
  }


  // Delete a Existing Banner in the 'Banners' collection
  Future<void> deleteBanner(String bannerId) async {
    try {
      await _db.collection('Banners').doc(bannerId).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

}
