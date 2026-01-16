import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class CreateProductTabletScreen extends StatelessWidget {
  const CreateProductTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());

    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Create product',
                  breadcrumbItems: ['Create product'],
                onBack: () {
                  Get.offNamed(RSRoutes.products);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Create Product
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  ProductTitleAndDescription(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Stock & Pricing
                  RSRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Heading
                        Text('Stock&Pricing',
                            style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        //ProductType
                        ProductTypeWidget(),
                        SizedBox(height: RSSizes.spaceBtwInputFields),

                        //Stock
                        ProductStockAndPricing(),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        //Attributes
                        ProductAttributes(),
                        SizedBox(height: RSSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Variations
                  ProductVariations(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Product Thumbnail
                  ProductThumbnailImage(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  RSRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Product Images',
                            style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: RSSizes.spaceBtwItems),
                        ProductAdditionalImages(
                          additionalProductImagesURLs:
                              controller.additionalProductImageUrls,
                          onTapToAddImages: () =>
                              controller.selectMultipleProductImages(),
                          onTapToRemoveImage: (index) =>
                              controller.removeImage(index),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  //Product Brand
                  ProductBrand(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Product Categories
                  ProductCategories(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Product Visibility
                  ProductVisibilityWidget(),
                  SizedBox(height: RSSizes.spaceBtwSections)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
