import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/tag_model.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class TagRepository extends GetxController {
  static TagRepository get instance => Get.find();

  // Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all tags from the 'Tags' collection
  Future<List<TagModel>> getAllTags() async {
    try {
      print("Fetching all tags from Firestore...");
      final result = await _db.collection('Tags').orderBy('createdAt', descending: true).get();
      final tags = result.docs.map((doc) => TagModel.fromSnapshot(doc)).toList();
      print("Fetched tags: ${tags.length} found.");
      return tags;
    } catch (e) {
      print("Error fetching tags: $e");
      throw _handleError(e);
    }
  }

  // Add a new tag to the 'Tags' collection
  Future<String> addTag(TagModel tag) async {
    try {
      print("Adding new tag: ${tag.name}");
      if (tag.name.isEmpty) {
        throw Exception("Tag name is null or empty");
      }
      final docRef = await _db.collection('Tags').add(tag.toJson());
      print("Tag added with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error adding tag: $e");
      throw _handleError(e);
    }
  }


  // Update a specific value of a tag
  Future<void> updateTagSpecificValue(String tagId, Map<String, dynamic> data) async {
    try {
      print("Updating tag with ID: $tagId");
      print("Data to update: $data");
      await _db.collection('Tags').doc(tagId).update(data);
      print("Tag updated successfully.");
    } catch (e) {
      print("Error updating tag: $e");
      throw _handleError(e);
    }
  }

  // Delete a tag from the 'Tags' collection
  Future<void> deleteTag(String tagId) async {
    try {
      print("Deleting tag with ID: $tagId");
      await _db.collection('Tags').doc(tagId).delete();
      print("Tag deleted successfully.");
    } catch (e) {
      print("Error deleting tag: $e");
      throw _handleError(e);
    }
  }

  // Error handler
  String _handleError(dynamic error) {
    if (error is FirebaseException) {
      print("Firebase error occurred: ${error.message}");
      return RSFirebaseException(error.code).message;
    } else if (error is PlatformException) {
      print("Platform error occurred: ${error.message}");
      return RSPlatformException(error.code).message;
    } else {
      print("Unknown error occurred: $error");
      return 'Something went wrong. Please try again';
    }
  }
}
