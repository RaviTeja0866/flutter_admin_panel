import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:roguestore_admin_panel/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/authentication/controllers/admin_auth_controller.dart';

Future<void> main() async {
  //Ensure the widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage
  await GetStorage.init();

  // Remove # sign from url
  setPathUrlStrategy();

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthenticationRepository()));

  // Main App Starts Here
  final auth = Get.put(AdminAuthController(), permanent: true);
  await auth.restoreSession();


  runApp(const App());
}
