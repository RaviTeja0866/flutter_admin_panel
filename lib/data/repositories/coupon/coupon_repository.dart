import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_exceptions.dart';

import '../../../utils/exceptions/platform_exceptions.dart';

class CouponRepository extends GetxController {
  static CouponRepository get instance => Get.find();

  // Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all Coupons from the 'Coupons' collection
  Future<List<CouponModel>> getAllCoupons() async {
    try {
      final snapshot = await _db.collection('Coupons').get();
      final result = snapshot.docs.map((doc) => CouponModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  /// Get Coupon by ID (REQUIRED for edit + reload)
  Future<CouponModel> getCouponById(String id) async {
    try {
      final doc = await _db.collection('Coupons').doc(id).get();

      if (!doc.exists) {
        throw 'Coupon not found';
      }
      return CouponModel.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Create a new Coupon document in the 'Coupons' collection
  Future<String> createCoupon(CouponModel coupon) async {
    try {
      // Add the Coupon document and automatically get the generated document ID
      final docRef = await _db.collection('Coupons').add(coupon.toJson());

      // Update the 'Id' field with the Firestore-generated ID
      await docRef.update({'Id': docRef.id}); // Set the 'Id' field in Firestore

      // Update the local CouponModel instance with the generated ID
      coupon.id = docRef.id;

      return docRef.id; // Return the generated document ID
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update Coupon document in the 'Coupons' collection
  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      await _db.collection('Coupons').doc(coupon.id).update(coupon.toJson());
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete an existing Coupon from the 'Coupons' collection
  Future<void> deleteCoupon(String couponId) async {
    try {
      await _db.collection('Coupons').doc(couponId).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
