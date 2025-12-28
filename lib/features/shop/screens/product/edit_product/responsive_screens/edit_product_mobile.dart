import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/product_images_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/additional_images.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/attributes_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/bottom_navigation_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/brand_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/categories_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/product_type_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/stock_pricing_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/thumbnail_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/title_description.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/variations_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/visibility_widget.dart';

import '../../../../models/product_model.dart';
import '../widgets/product_stats.dart';

class EditProductMobileScreen extends StatelessWidget {
  const EditProductMobileScreen({super.key, required this.product});

  final ProductModel product;


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());

    return  Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Create product', breadcrumbItems: ['Create product']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Create Product
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  RSProductStats(product: product),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Basic Information
                  ProductTitleAndDescription(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Stock & Pricing
                  RSRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Heading
                        Text('Stock&Pricing', style: Theme.of(context).textTheme.headlineSmall),
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
                        Text('All Product Images',style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: RSSizes.spaceBtwItems),
                        ProductAdditionalImages(
                          additionalProductImagesURLs: controller.additionalProductImageUrls,
                          onTapToAddImages: () => controller.selectMultipleProductImages(),
                          onTapToRemoveImage:(index) => controller.removeImage(index),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  //Product Brand
                  ProductBrand(),
                  SizedBox(height: RSSizes.spaceBtwSections),

                  // Product Categories
                  ProductCategories(product: product),
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
