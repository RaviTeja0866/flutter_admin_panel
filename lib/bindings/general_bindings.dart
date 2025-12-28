import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/settings_controller.dart';
import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';

import '../features/personalization/controllers/user_controller.dart';

 class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // -- Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserProfileController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }

 }