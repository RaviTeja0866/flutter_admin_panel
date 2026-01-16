import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/edit_product_controller.dart';
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
  const EditProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editController = EditProductController.instance;
    final imagesController = Get.put(ProductImagesController());

    return Obx(() {
      final product = editController.product.value;

      // ⛔ WAIT until product is loaded (refresh-safe)
      if (product == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        bottomNavigationBar:
        ProductBottomNavigationButtons(product: product),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs
                RSBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Update Product',
                  breadcrumbItems: ['Products', 'Update'],
                  onBack: () {
                    Get.offNamed(RSRoutes.products);
                  },

                ),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Stats
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
                      Text(
                        'Stock & Pricing',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall,
                      ),
                      SizedBox(height: RSSizes.spaceBtwItems),

                      ProductTypeWidget(),
                      SizedBox(height: RSSizes.spaceBtwInputFields),

                      ProductStockAndPricing(),
                      SizedBox(height: RSSizes.spaceBtwSections),

                      ProductAttributes(),
                    ],
                  ),
                ),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Variations
                ProductVariations(),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Thumbnail
                ProductThumbnailImage(),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Additional Images
                RSRoundedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Product Images',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall,
                      ),
                      SizedBox(height: RSSizes.spaceBtwItems),
                      ProductAdditionalImages(
                        additionalProductImagesURLs:
                        imagesController.additionalProductImageUrls,
                        onTapToAddImages:
                        imagesController.selectMultipleProductImages,
                        onTapToRemoveImage:
                        imagesController.removeImage,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Brand
                ProductBrand(),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Categories
                ProductCategories(product: product),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Visibility
                ProductVisibilityWidget(),
                SizedBox(height: RSSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      );
    });
  }
}
