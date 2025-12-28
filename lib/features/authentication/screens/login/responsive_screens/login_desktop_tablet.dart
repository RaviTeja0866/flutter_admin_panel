import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/login_template.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';


class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return RSLoginTemplate(child: Column(
      children: [
        //Header
        RSLoginHeader(),

        //Form
        RSLoginForm()
      ],
    ),
    );
  }
}



