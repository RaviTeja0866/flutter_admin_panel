import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repositories/admin/admin_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../../personalization/models/admin_model.dart';

class AdminUserController extends GetxController {
  static AdminUserController get instance => Get.find();

  final RxBool loading = false.obs;
  final Rx<AdminUserModel?> admin = Rx<AdminUserModel?>(null);

  final _adminRepository = AdminRepository.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadAdmin();
  }

  // -------------------------
  // Load logged-in admin
  // -------------------------
  Future<void> loadAdmin() async {
    try {
      loading.value = true;

      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw 'Not authenticated';
      }

      final adminUser =
      await _adminRepository.fetchAdminByUid(uid);

      if (adminUser == null || !adminUser.isActive) {
        throw 'Admin access denied';
      }

      admin.value = adminUser;
    } catch (e) {
      admin.value = null;
      RSLoaders.error(message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  // -------------------------
  // Helpers
  // -------------------------
  bool get isLoggedIn => admin.value != null;
}
