import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:roguestore_admin_panel/features/personalization/models/admin_model.dart';

import '../../../features/shop/models/order_model.dart';
import '../../../features/shop/models/user_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;


  // Function to save user data to Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
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

  // Function to fetch users data from Firestore
  Future<List<UserModel>> getAllUsers() async{
    try {
      final querySnapshot = await _db.collection('Users').orderBy('FirstName').get();
      return querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
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

// Function to fetch all users details based on id
Future<UserModel> fetchUserDetails(String id) async{
  try {
    final documentSnapshot = await _db.collection('Users').doc(id).get();
    if(documentSnapshot.exists){
      return UserModel.fromSnapshot(documentSnapshot);
    } else{
      return UserModel.empty();
    }
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


  // Function to fetch users details based on user id
  Future<List<OrderModel>> fetchUserOrders(String  userId) async{
    try {
      final documentSnapshot = await _db.collection('Orders').where('userId', isEqualTo: userId).get();
      return documentSnapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
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

  // Function to update users data in firestore
  Future<void> updateUserDetails(UserModel  updateUser) async{
    try {
       await _db.collection('Users').doc(updateUser.id).update(updateUser.toJson());
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

  // Function to update users data in firestore
  Future<void> updateSingleFiled(Map<String, dynamic> json) async{
    try {
      await _db.collection('Users').doc(AuthenticationRepository.instance.authUser!.uid).update(json);
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

  //Delete User Data
  Future<void> deleteUser(String id) async{
    try {
      await _db.collection('Users').doc(id).delete();
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