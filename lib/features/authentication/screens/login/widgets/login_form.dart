import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/authentication/controllers/login_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class RSLoginForm extends StatelessWidget {
  const RSLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
        child: Padding(
          padding:
          EdgeInsets.symmetric(vertical: RSSizes.spaceBtwSections),
          child: Column(
            children: [
              ///Email
              TextFormField(
                controller: controller.email,
                validator: RSValidator.validateEmail,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: RSTexts.email,
                ),
              ),
              const SizedBox(height: RSSizes.spaceBtwInputFields),

              ///Password

              Obx(
                ()=> TextFormField(
                  controller: controller.password,
                  validator: (value) => RSValidator.validateEmptyText('Password', value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: RSTexts.password,
                    prefixIcon: Icon(Iconsax.direct_right),
                    suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)),
                  ),
                ),
              ),
              const SizedBox(height: RSSizes.spaceBtwInputFields / 2),

              ///Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Remember Me
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(()=> Checkbox(value: controller.rememberMe.value, onChanged: (value) =>controller.rememberMe.value = value!)),
                      Text(RSTexts.rememberMe),
                    ],
                  ),

                  // Forgot Password
                  TextButton(
                      onPressed: () => Get.toNamed(RSRoutes.forgetPassword),
                      child: Text(RSTexts.forgetPassword)),
                ],
              ),
              const SizedBox(height: RSSizes.spaceBtwSections),

              //Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: Text(RSTexts.signIn)),
                //child: ElevatedButton(onPressed: () => controller.registerAdmin(), child: Text(RSTexts.signIn)),
              )
            ],
          ),
        ));
  }
}