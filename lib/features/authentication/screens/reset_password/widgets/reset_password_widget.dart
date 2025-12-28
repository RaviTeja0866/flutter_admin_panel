import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class RestPasswordWidget extends StatelessWidget {
  const RestPasswordWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final email = Get.parameters['email'] ?? '';
    return Column(
      children: [
        ///Header
        Row(
           children: [
            IconButton(
                onPressed: () => Get.offAllNamed(RSRoutes.login),
                icon: Icon(CupertinoIcons.clear)),
          ],
        ),
        SizedBox(height: RSSizes.spaceBtwItems),

        ///Image
        const Image(
            image: AssetImage(RSImages.deliveredEmailIllustration),
            width: 300,
            height: 300),
        SizedBox(height: RSSizes.spaceBtwItems),

        ///Title & Subtitle
        Text(RSTexts.changeYourPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center),
        SizedBox(height: RSSizes.spaceBtwItems),
        Text(email,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center),
        SizedBox(height: RSSizes.spaceBtwItems),
        Text(RSTexts.changeYourPasswordTitle,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center),
        SizedBox(height: RSSizes.spaceBtwSections),

        //Buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () => Get.back(), child: const Text(RSTexts.done)),
        ),
        SizedBox(height: RSSizes.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: TextButton(onPressed: () {}, child: Text(RSTexts.resendEmail)),
        ),
      ],
    );
  }
}
