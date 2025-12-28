import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class CategoriesDesktopScreen extends StatelessWidget {
  const CategoriesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller  = Get.put(CategoryController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // BreadCrumbs
             RSBreadcrumbsWithHeading(heading: 'Categories', breadcrumbItems: ['Categories']),
             SizedBox(height: RSSizes.spaceBtwSections),

             // Table Body

               // Show Loader
               RSRoundedContainer(
                 child: Column(
                   children: [
                     RSTableHeader(buttonText: 'Create New Category',
                         onPressed: () => Get.toNamed(RSRoutes.createCategory),
                         searchController: controller.searchController,
                       searchOnChanged:(query) => controller.searchQuery(query),
                     ),
                     SizedBox(height: RSSizes.spaceBtwItems),

                     // Table
                     Obx(() {
                       if(controller.isLoading.value)  return RSLoaderAnimation();
                         return CategoryTable();
                     }),
                   ],
                 ),
               ),
           ],
         ),

        ),
      ),
    );
  }
}
