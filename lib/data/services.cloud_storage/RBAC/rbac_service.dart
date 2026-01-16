import 'package:flutter/foundation.dart';
import '../../../features/authentication/controllers/admin_auth_controller.dart';
import '../../../utils/constants/enums.dart';

class RBACService {
  static bool hasPermission(Permission permission) {
    debugPrint('🔐 [RBAC] Checking permission → ${permission.name}');

    final auth = AdminAuthController.instance;
    final admin = auth.admin.value;
    if (admin == null) return false;

    debugPrint('👤 [RBAC] Admin ID → ${admin.id}');
    debugPrint('👤 [RBAC] Role ID → ${admin.roleId}');

    // SUPER_ADMIN shortcut
    if (admin.roleId == 'SUPER_ADMIN') {
      debugPrint('🟢 [RBAC] SUPER_ADMIN → ALLOW');
      return true;
    }

    final role = auth.role.value;
    if (role == null) return false;

    debugPrint('🧩 [RBAC] Role name → ${role.name}');
    debugPrint('🧩 [RBAC] Role permissions (raw) → ${role.permissions}');
    debugPrint('➕ [RBAC] Extra permissions → ${admin.extraPermissions}');
    debugPrint('➖ [RBAC] Revoked permissions → ${admin.revokedPermissions}');

    // ✅ Convert STRING → ENUM
    final basePermissions = role.permissions
        .where((e) => Permission.values.any((p) => p.name == e))
        .map((e) => Permission.values.byName(e))
        .toSet();

    final effectivePermissions = {
      ...basePermissions,
      ...admin.extraPermissions,
    }..removeWhere(
          (p) => admin.revokedPermissions.contains(p),
    );

    debugPrint('📦 [RBAC] Effective permissions (enum) → $effectivePermissions');

    final allowed = effectivePermissions.contains(permission);

    debugPrint(
      '🛡️ [RBAC] Result → ${allowed ? 'ALLOWED' : 'DENIED'} '
          'for ${permission.name}',
    );

    return allowed;
  }
}
