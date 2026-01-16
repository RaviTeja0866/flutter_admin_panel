import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/services.cloud_storage/RBAC/rbac_service.dart';
import '../../../utils/constants/enums.dart';
import 'access_denied_screen.dart';

class ActionGuard {
  /// Guard for async actions (API calls, writes, deletes)
  static Future<T?> run<T>({
    required Permission permission,
    required Future<T> Function() action,
    bool showDeniedScreen = false,
  }) async {
    debugPrint('🛡️ [ActionGuard.run] Checking permission → ${permission.name}');

    final allowed = RBACService.hasPermission(permission);

    debugPrint(
      '🛡️ [ActionGuard.run] Result → '
          '${allowed ? 'ALLOWED' : 'DENIED'}',
    );

    if (!allowed) {
      debugPrint(
        '❌ [ActionGuard.run] Access denied for ${permission.name}',
      );

      if (showDeniedScreen) {
        debugPrint(
          '🚫 [ActionGuard.run] Redirecting to AccessDeniedScreen',
        );
        Get.to(() => const AccessDeniedScreen());
      }

      return null;
    }

    debugPrint(
      '✅ [ActionGuard.run] Executing protected action',
    );

    final result = await action();

    debugPrint(
      '✅ [ActionGuard.run] Action completed',
    );

    return result;
  }

  /// Guard for sync actions (navigation, toggles)
  static bool check({
    required Permission permission,
    bool showSnackbar = true,
    bool showDeniedScreen = false,
  }) {
    debugPrint('🛡️ [ActionGuard.check] Checking permission → ${permission.name}');

    final allowed = RBACService.hasPermission(permission);

    debugPrint(
      '🛡️ [ActionGuard.check] Result → '
          '${allowed ? 'ALLOWED' : 'DENIED'}',
    );

    if (!allowed) {
      debugPrint(
        '❌ [ActionGuard.check] Access denied for ${permission.name}',
      );

      if (showDeniedScreen) {
        debugPrint(
          '🚫 [ActionGuard.check] Redirecting to AccessDeniedScreen',
        );
        Get.to(() => const AccessDeniedScreen());
      }
    }

    return allowed;
  }
}
