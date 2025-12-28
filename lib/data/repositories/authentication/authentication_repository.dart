import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:roguestore_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:roguestore_admin_panel/utils/exceptions/platform_exceptions.dart';

import '../../../routes/routes.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Firebase Auth Instance
  final _auth = FirebaseAuth.instance;

  // Get Authenticated User data
  User? get authUser => _auth.currentUser;

  // Ge IsAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    _auth.setPersistence(Persistence.LOCAL);
  }

  // Function to determine the relevant screen and redirect accordingly.
  void screenRedirect() async {
    final user = _auth.currentUser;

    // If the user is logged in
    if(user != null) {
      // Navigate to the Home
      Get.offAllNamed(RSRoutes.dashboard);
    } else {
      Get.offAllNamed(RSRoutes.login);
    }
  }

// Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try again';
    }
  }
// Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try again';
    }
  }

// Register User By Admin

// Email verification

// Forget Password
  Future<void> sendPasswordResentEmail(String email) async{
    try{
      await  _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went Wrong. Please try again.';
    }
  }

// Re Authenticate User
  Future<bool> reauthenticateUser(String password) async {
    try {
      print('[reauthenticateUser] Started');

      final user = _auth.currentUser;
      if (user == null) {
        print('[reauthenticateUser] No user logged in');
        throw 'No user logged in';
      }

      print('[reauthenticateUser] User email: ${user.email}');

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      print('[reauthenticateUser] Created credentials');

      await user.reauthenticateWithCredential(cred);
      print('[reauthenticateUser] Re-authentication successful');

      return true; // Password correct
    } on FirebaseAuthException catch (e) {
      print('[reauthenticateUser] FirebaseAuthException: ${e.code} - ${e.message}');
      if (e.code == 'wrong-password') {
        throw 'Incorrect password';
      }
      throw RSFirebaseAuthException(e.code).message;
    } catch (e) {
      print('[reauthenticateUser] General error: $e');
      throw 'Re-authentication failed: $e';
    }
  }

// Logout user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(RSRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please Try again';
    }
  }

// Delete User
}
