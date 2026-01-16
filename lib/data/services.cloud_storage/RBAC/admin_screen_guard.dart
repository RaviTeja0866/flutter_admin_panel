import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/data/services.cloud_storage/RBAC/rbac_service.dart';
import '../../../utils/constants/enums.dart';
import 'access_denied_screen.dart';

enum GuardBehavior {
  hide,
  disable,
  denyScreen,
}

class AdminScreenGuard extends StatelessWidget {
  final Permission permission;
  final Widget child;
  final GuardBehavior behavior;

  const AdminScreenGuard({
    super.key,
    required this.permission,
    required this.child,
    this.behavior = GuardBehavior.hide,
  });

  @override
  Widget build(BuildContext context) {
    final allowed = RBACService.hasPermission(permission);

    if (allowed) return child;

    switch (behavior) {
      case GuardBehavior.hide:
        return const SizedBox.shrink();

      case GuardBehavior.disable:
        return MouseRegion(
          cursor: SystemMouseCursors.forbidden, // 🚫 only cursor
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.5,
              child: child,
            ),
          ),
        );

      case GuardBehavior.denyScreen:
        return const AccessDeniedScreen();
    }
  }
}
