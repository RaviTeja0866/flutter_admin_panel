import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';

import '../../../utils/constants/sizes.dart';
import '../texts/page_heading.dart';

class RSBreadcrumbsWithHeading extends StatelessWidget {
  const RSBreadcrumbsWithHeading({
    super.key,
    required this.heading,
    required this.breadcrumbItems,
    this.onBack,
    this.backRoute,
    this.returnToPreviousScreen = false,
  });

  // The heading For page
  final String heading;

  //List of BreadCrumb items representing the navigation path
  final List<String> breadcrumbItems;

  // flag indicating whether to include a button to return to the previous Screen
  final bool returnToPreviousScreen;

  /// Custom back action (highest priority)
  final VoidCallback? onBack;

  /// Named route to navigate back to
  final String? backRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb Trail
        Row(children: [
          // Dashboard Link
          InkWell(
            onTap: () => Get.offAllNamed(RSRoutes.dashboard),
            child: Padding(
              padding: EdgeInsets.all(RSSizes.xs),
              child: Text(
                'Dashboard',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .apply(fontWeightDelta: -1),
              ),
            ),
          ),

          for (int i = 0; i < breadcrumbItems.length; i++)
            Row(
              children: [
                const Text('/'), // Separator
                InkWell(
                  onTap: i == breadcrumbItems.length - 1
                      ? null
                      : () => Get.toNamed(breadcrumbItems[i]),
                  child: Padding(
                    padding: EdgeInsets.all(RSSizes.xs),

                    // Format breadcrumbs item: capitalize and remove leading '/'
                    child: Text(
                      i == breadcrumbItems.length - 1
                          ? breadcrumbItems[i].capitalize.toString()
                          : Capitalize(breadcrumbItems[i].substring(1)),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(fontWeightDelta: -1),
                    ),
                  ),
                ),
              ],
            )
        ]),

        SizedBox(height: RSSizes.sm),
        // Heading of the Page
        Row(
          children: [
            if (returnToPreviousScreen)
              IconButton(
                icon: const Icon(Iconsax.arrow_left),
                onPressed: () {
                  if (onBack != null) {
                    onBack!();
                  } else if (backRoute != null) {
                    Get.offNamed(backRoute!);
                  } else {
                    // fallback – overlay safe
                    while (Get.isOverlaysOpen) {
                      Get.back();
                    }
                    if (Get.key.currentState?.canPop() ?? false) {
                      Get.back();
                    }
                  }
                },
              ),
            if (returnToPreviousScreen) SizedBox(width: RSSizes.spaceBtwItems),
            RSPageHeading(heading: heading),
          ],
        )
      ],
    );
  }

  // Function to capitalize the first letter to String
  String Capitalize(String s) {
    return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  }
}
