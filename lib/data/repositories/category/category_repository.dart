import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_exceptions.dart';

import '../../../utils/exceptions/platform_exceptions.dart';

class CategoryRepository extends GetxController{
  static CategoryRepository get instance => Get.find();

  // Firebase Firestore Instance
final FirebaseFirestore _db = FirebaseFirestore.instance;

 // Get all Categories from the 'Categories' collection
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final result = snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get category by ID (REQUIRED for edit + reload)
  Future<CategoryModel> getById(String id) async {
    try {
      final doc = await _db.collection('Categories').doc(id).get();

      if (!doc.exists) {
        throw 'Category not found';
      }
      return CategoryModel.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  // Create a new Category document in the 'Categories' collection
  Future<String> createCategory(CategoryModel category) async {
    try {

      // Add the Category document and automatically get the generated document ID
      final docRef = await _db.collection('Categories').add(category.toJson());

      // Now update the 'Id' field with the Firestore-generated ID
      await docRef.update({'Id': docRef.id}); // Set the 'Id' field in Firestore

      // Log the generated ID and document

      // Optionally, update the local CategoryModel instance with the generated ID
      category.id = docRef.id;

      return docRef.id; // Return the generated document ID

    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message; // Rethrow the specific Firebase exception
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message; // Rethrow the platform exception
    } catch (e) {
      throw 'Something went wrong. Please try again'; // General error message
    }
  }

  // Update Category document in the 'Categories' collection
  Future<void>updateCategory(CategoryModel category) async {
    try{
      await _db.collection('Categories').doc(category.id).update(category.toJson());
    }on FirebaseException catch(e) {
      throw RSFirebaseException(e.code).message;
    }on PlatformException catch(e) {
      throw RSPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete an existing Category from the 'Categories' collection
  Future<void> deleteCategory(String categoryId) async{
    try{
      await _db.collection('Categories').doc(categoryId).delete();
    }on FirebaseException catch(e) {
      throw RSFirebaseException(e.code).message;
    }on PlatformException catch(e) {
      throw RSPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong. Please try again';
    }
  }
}
