import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/authentication/screens/forget_password/widgets/header_form.dart';

import '../../../../../utils/constants/sizes.dart';

class ForgetPasswordScreenMobile extends StatelessWidget {
  const ForgetPasswordScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
             padding: EdgeInsets.all(RSSizes.defaultSpace),
             child: HeaderAndForm(),
      )),
    );
  }
}
