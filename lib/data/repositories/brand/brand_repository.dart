import  'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_exceptions.dart';

import '../../../features/shop/models/brand_category.dart';
import '../../../features/shop/models/brand_model.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController{
  static BrandRepository get instance => Get.find();

  // Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // Get all Brands from the 'Brands' collection
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      final result = snapshot.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  /// Get brand by ID (REQUIRED for edit + reload)
  Future<BrandModel> getBrandById(String id) async {
    try {
      final doc = await _db.collection('Brands').doc(id).get();

      if (!doc.exists) {
        throw 'Brand not found';
      }
      return BrandModel.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get all Brands from the 'BrandCategory' collection
  Future<List<BrandCategoryModel>> getAllBrandCategories() async {
    try {
      final brandCategoryQuery = await _db.collection('BrandCategory').get();
      final brandCategories = brandCategoryQuery.docs.map((doc) => BrandCategoryModel.fromSnapshot(doc)).toList();
      return brandCategories;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get Specific Brands Categories for a given brand id
  Future<List<BrandCategoryModel>> getCategoriesOfSpecificBrand(String brandId) async {
    try {
      final brandCategory = await _db.collection('BrandCategory').where('brandId', isEqualTo: brandId).get();
      final brandCategories = brandCategory.docs.map((doc) => BrandCategoryModel.fromSnapshot(doc)).toList();
      return brandCategories;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<String> createBrand(BrandModel brand) async {
    try {

      // Add the brand document and automatically get the generated document ID
      final docRef = await _db.collection('Brands').add(brand.toJson());

      // Now update the 'Id' field with the Firestore-generated ID
      await docRef.update({'Id': docRef.id}); // Set the 'Id' field in Firestore

      // Log the generated ID and document

      // Optionally, update the local BrandModel instance with the generated ID
      brand.id = docRef.id;

      return docRef.id; // Return the generated document ID

    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message; // Rethrow the specific Firebase exception
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message; // Rethrow the platform exception
    } catch (e) {
      throw 'Something went wrong. Please try again'; // General error message
    }
  }

// Create a new BrandCategory document in the 'BrandCategory' collection
  Future<String> createBrandCategory(BrandCategoryModel brandCategory) async {
    try {
      final data = await _db.collection('BrandCategory').add(brandCategory.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateBrand(BrandModel brand) async {
    try {
      final brandData = brand.toJson();

      // Check if the document exists first
      final brandDocRef = _db.collection('Brands').doc(brand.id);
      final docSnapshot = await brandDocRef.get();

      if (docSnapshot.exists) {
        // Document exists, proceed with the update
        await brandDocRef.update(brandData);
      } else {
        // Document doesn't exist, handle accordingly
        throw "Brand document not found!";
      }
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

// Delete an existing Category from the 'Brands' collection
  Future<void> deleteBrand(BrandModel brand) async {
    try {
      await _db.runTransaction((transaction) async {
        final brandRef = _db.collection('Brands').doc(brand.id);
        final brandSnap = await transaction.get(brandRef);

        if (!brandSnap.exists) {
          throw Exception('Brand not found');
        }

        final brandCategoriesSnapshot = await _db.collection('BrandCategory').where('brandId', isEqualTo: brand.id).get();
        final brandCategories = brandCategoriesSnapshot.docs.map((e) => BrandCategoryModel.fromSnapshot(e)).toList();

        if (brandCategories.isNotEmpty) {
          for (var brandCategory in brandCategories) {
            transaction.delete(_db.collection('BrandCategory').doc(brandCategory.id));
          }
        }
        transaction.delete(brandRef);
      });
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

// Delete BrandCategory document in the 'BrandCategory' collection
  Future<void> deleteBrandCategory(String brandCategoryId) async {
    try {
      await _db.collection('BrandCategory').doc(brandCategoryId).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


}
