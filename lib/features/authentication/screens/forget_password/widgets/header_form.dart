import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class HeaderAndForm extends StatelessWidget {
  const HeaderAndForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Header
        IconButton(
            onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
        const SizedBox(height: RSSizes.spaceBtwItems),
        Text(RSTexts.forgetPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: RSSizes.spaceBtwItems),
        Text(RSTexts.forgetPasswordSubTitle,
            style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: RSSizes.spaceBtwItems * 2),

        ///Form
        Form(
          child: TextFormField(
            decoration: InputDecoration(
                labelText: RSTexts.email,
                prefixIcon: Icon(Iconsax.direct_right)),
          ),
        ),
        const SizedBox(height: RSSizes.spaceBtwSections),

        ///Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () => Get.toNamed(RSRoutes.resetPassword,
                  parameters: {'email': 'roguestore@gmail.com'}),
              child: Text(RSTexts.submit)),
        ),
        const SizedBox(height: RSSizes.spaceBtwItems * 2),
      ],
    );
  }
}
