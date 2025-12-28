import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/login_template.dart';
import '../widgets/reset_password_widget.dart';

class ResetPasswordScreenDesktopTablet extends StatelessWidget {
  const ResetPasswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return RSLoginTemplate(child: RestPasswordWidget());
  }
}

