import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';

import '../../../utils/constants/enums.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload any Image using File
  Future<ImageModel> uploadImageFileInStorage({
    required html.File file,
    required String path,
    required String imageName,
  }) async {
    try {
      // Reference to the storage location
      final Reference ref = _storage.ref('$path/$imageName');

      // Upload file
      await ref.putBlob(file);

      // Get Download Url
      final String downloadURL = await ref.getDownloadURL();

      // Fetch Metadata
      final FullMetadata metadata = await ref.getMetadata();

      return ImageModel.fromFirebaseMetaData(
          metadata, path, imageName, downloadURL);
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  // Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('Images')
          .add(image.toJson());

      return data.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

// Fetch images from Firestore based on media category and load count
  Future<List<ImageModel>> fetchImagesFromDatabase(
      MediaCategory mediaCategory, int loadCount) async {
    try {

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Images')
          .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('createdAt', descending: true)
          .limit(loadCount)
          .get();

      final images = querySnapshot.docs.map((e) {
        final image = ImageModel.fromSnapshot(e);
        return image;
      }).toList();

      return images;
    } on FirebaseException catch (e) {
      throw "Failed to fetch images: ${e.message}";
    } on SocketException {
      throw "No internet connection.";
    } on PlatformException catch (e) {
      throw "Platform error occurred: ${e.message}";
    } catch (e) {
      throw "An unknown error occurred.";
    }
  }

// Load More images from Firestore based on media category, load count, and Last fetched Date
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
      MediaCategory mediaCategory,
      int loadCount,
      DateTime lastFetchedDate) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Images')
          .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('createdAt', descending: true)
          .startAfter([lastFetchedDate])
          .limit(loadCount)
          .get();


      final images = querySnapshot.docs.map((e) {
        final image = ImageModel.fromSnapshot(e);
        return image;
      }).toList();

      return images;
    } on FirebaseException catch (e) {
      throw "Failed to load more images: ${e.message}";
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  // Delete file from firebase Storage and corresponding document from firestore
 Future<void> deleteFileFromStorage(ImageModel image) async {
    try{
      await FirebaseStorage.instance.ref(image.fullPath).delete();
      await FirebaseFirestore.instance.collection('Images').doc(image.id).delete();
    }on FirebaseException catch (e) {
      throw e.message ?? 'something went wrong while deleting image.';
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
 }

}
