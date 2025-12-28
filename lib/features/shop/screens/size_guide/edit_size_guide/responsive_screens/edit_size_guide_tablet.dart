import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/edit_size_guide/widgets/edit_size_guide_form.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../models/size_guide_model.dart';

class EditSizeGuideTabletScreen extends StatelessWidget {
  const EditSizeGuideTabletScreen({super.key, required this.sizeGuide});

  final SizeGuideModel sizeGuide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Update SizeGuide', breadcrumbItems: [RSRoutes.sizeGuide, 'Update SizeGuide']),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditSizeGuideForm(sizeGuide: sizeGuide),
            ],
          ),
        ),
      ),
    );
  }
}