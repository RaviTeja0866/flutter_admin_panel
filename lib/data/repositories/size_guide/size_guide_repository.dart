  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/services.dart';
  import 'package:get/get.dart';
  import 'package:roguestore_admin_panel/features/shop/models/size_guide_model.dart';
  import '../../../utils/exceptions/firebase_exceptions.dart';
  import '../../../utils/exceptions/platform_exceptions.dart';
  
  class SizeGuideRepository extends GetxController {
    static SizeGuideRepository get instance => Get.find();
  
    // Firebase Firestore Instance
    final FirebaseFirestore _db = FirebaseFirestore.instance;
  
    // Collection reference
    final String _collectionPath = 'SizeGuide';
  
    // Get all Size Guides from the 'SizeGuides' collection
    Future<List<SizeGuideModel>> getAllSizeGuides() async {
      try {
        final snapshot = await _db.collection(_collectionPath).get();
        final result = snapshot.docs.map((doc) => SizeGuideModel.fromSnapshot(doc)).toList();
        return result;
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  
    // Get size guides by garment type
    Future<List<SizeGuideModel>> getSizeGuidesByGarmentType(String garmentType) async {
      try {
        final result = await _db
            .collection(_collectionPath)
            .where('garmentType', isEqualTo: garmentType)
            .get();
  
        return result.docs
            .map((doc) => SizeGuideModel.fromSnapshot(doc))
            .where((sizeGuide) => sizeGuide.validateSizeChart())
            .toList();
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  
    // Create a new Size Guide document
    Future<String> createSizeGuide(SizeGuideModel sizeGuide) async {
      try {
        if (!sizeGuide.validateSizeChart()) {
          throw 'Invalid size chart data';
        }
  
        final docRef = await _db.collection(_collectionPath).add(sizeGuide.toJson());
        return docRef.id;
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  
    // Update specific values of a size guide
    Future<void> updateSizeGuideSpecificValue(String sizeGuideId, Map<String, dynamic> data) async {
      try {
        await _db.collection(_collectionPath).doc(sizeGuideId).update({
          ...data,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  
    // Update entire size guide
    Future<void> updateSizeGuide(String sizeGuideId, SizeGuideModel sizeGuide) async {
      try {
        if (!sizeGuide.validateSizeChart()) {
          throw 'Invalid size chart data';
        }
  
        await _db.collection(_collectionPath).doc(sizeGuideId).update(sizeGuide.toJson());
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  
    // Delete an existing Size Guide
    Future<void> deleteSizeGuide(String sizeGuideId) async {
      try {
        await _db.collection(_collectionPath).doc(sizeGuideId).delete();
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  
    // Get a single size guide by ID
    Future<SizeGuideModel?> getSizeGuideById(String sizeGuideId) async {
      try {
        final doc = await _db.collection(_collectionPath).doc(sizeGuideId).get();
  
        if (!doc.exists) return null;
  
        final sizeGuide = SizeGuideModel.fromSnapshot(doc);
      } on FirebaseException catch (e) {
        throw RSFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw RSPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }
  }