import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/shop_category.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ShopCategoryRepository extends GetxController {
  static ShopCategoryRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;


  // Get all ShopCategories from the 'ShopCategories' collection
  Future<List<ShopCategory>> getAllShopCategories() async {
    try {
      final snapshot = await _db.collection('ShopCategories').get();
      final result = snapshot.docs.map((doc) => ShopCategory.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  /// Get shop categories by type (TOP_SELLERS or NEW_ARRIVALS)
  Future<List<ShopCategory>> getShopCategoriesByType(String type, String gender) async {
    try {
      final snapShot = await _db.collection('ShopCategories')
          .where('Type', isEqualTo: type)
          .where('Gender', isEqualTo: gender)
          .get();

      final list = snapShot.docs
          .map((document) => ShopCategory.fromSnapshot(document))
          .toList();

      return list;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later';
    }
  }

  /// Add a new shop category
  Future<String> createShopCategory(ShopCategory shopCategory) async {
    try {
      final result = await _db.collection('ShopCategories').add(shopCategory.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get shop category by ID (WEB-SAFE, REQUIRED)
  Future<ShopCategory> getById(String id) async {
    try {
      final doc = await _db.collection('ShopCategories').doc(id).get();

      if (!doc.exists) {
        throw 'ShopCategory not found';
      }

      return ShopCategory.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  /// Update a shop category
  Future<void> updateShopCategory(ShopCategory category) async {
    try {
      await _db.collection('ShopCategories').doc(category.id).update(category.toJson());
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later';
    }
  }

  /// Delete a shop category
  Future<void> deleteShopCategory(String categoryId) async {
    try {
      await _db.collection('ShopCategories').doc(categoryId).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later';
    }
  }
}