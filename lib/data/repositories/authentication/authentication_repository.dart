import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:roguestore_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:roguestore_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:roguestore_admin_panel/utils/exceptions/platform_exceptions.dart';
import '../../../features/authentication/controllers/admin_auth_controller.dart';
import '../../../routes/routes.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔑 Single source of truth
  final Rxn<User> firebaseUser = Rxn<User>();
  final RxBool isAuthReady = false.obs;

  User? get authUser => firebaseUser.value;
  bool get isAuthenticated => firebaseUser.value != null;

  @override
  void onReady() async {
    print('🔐 [AUTH] onReady called');

    await _auth.setPersistence(Persistence.LOCAL);
    print('🔐 [AUTH] Persistence set to LOCAL');

    firebaseUser.bindStream(_auth.authStateChanges());

    ever(firebaseUser, (user) {
      print('🔐 [AUTH STREAM] user = ${user?.uid}');
      print('🔐 [AUTH STREAM] isAuthReady(before) = ${isAuthReady.value}');
      _onAuthChanged(user);
    });
  }


  void _onAuthChanged(User? user) {
    final route = Get.currentRoute;
    final adminAuth = AdminAuthController.instance;

    debugPrint(
      '🔐 [AUTH] user=${user?.uid} route=$route '
          'adminReady=${adminAuth.isAdminReady.value} '
          'admin=${adminAuth.admin.value?.id}',
    );

    // Ignore transient nulls during active admin session
    if (user == null) {
      if (!adminAuth.isAdminReady.value || adminAuth.isLoggedIn) {
        debugPrint('⏳ [AUTH] Ignoring transient null user');
        return;
      }

      if (route != RSRoutes.login) {
        Get.offNamed(RSRoutes.login);
      }
      return;
    }

    // 🔑 IMPORTANT: only redirect if NOT already on dashboard
    if ((route == RSRoutes.login || route == RSRoutes.splash) &&
        route != RSRoutes.dashboard) {
      Get.offNamed(RSRoutes.dashboard);
    }

  }

  // ---------------------------------------------------------------------------
  // AUTH ACTIONS
  // ---------------------------------------------------------------------------

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<bool> reauthenticateUser(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'No user logged in';

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw 'Incorrect password';
      }
      throw RSFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Re-authentication failed';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      // ❌ NO navigation here
      // authStateChanges will handle redirect
    } on FirebaseAuthException catch (e) {
      throw RSFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on FormatException {
      throw const RSFormatException();
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }
}
