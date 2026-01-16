import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';
import 'package:roguestore_admin_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/coupon_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/is_featured_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/product_stats.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/size_guide_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/additional_images.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/attributes_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/bottom_navigation_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/brand_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/categories_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/product_type_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/stock_pricing_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/tag_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/thumbnail_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/title_description.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/variations_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets/visibility_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/edit_product/widgets//target_audience_widget.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/product/edit_product_controller.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../widgets/offer_widget.dart';
import '../widgets/specifications_widget.dart';

class EditProductDesktopScreen extends StatelessWidget {
  const EditProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;
    final imagesController = Get.put(ProductImagesController());

    return Obx(() {
      final product = productController.product.value;

      // ⛔ WAIT until product is loaded (refresh-safe)
      if (product == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        bottomNavigationBar: ProductBottomNavigationButtons(product: product),
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

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT COLUMN
                    Expanded(
                      flex: RSDeviceUtils.isTabletScreen(context) ? 2 : 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RSProductStats(product: product),
                          SizedBox(height: RSSizes.spaceBtwSections),

                          ProductTitleAndDescription(),
                          SizedBox(height: RSSizes.spaceBtwSections),

                          const RSProductSpecificationsWidget(),
                          SizedBox(height: RSSizes.spaceBtwSections),

                          // Stock & Pricing
                          RSRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stock & Pricing',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
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

                          ProductVariations(),
                        ],
                      ),
                    ),

                    SizedBox(width: RSSizes.defaultSpace),

                    // RIGHT SIDEBAR
                    Expanded(
                      child: Column(
                        children: [
                          ProductThumbnailImage(),
                          SizedBox(height: RSSizes.spaceBtwSections),

                          // Additional Images
                          RSRoundedContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'All Product Images',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: RSSizes.spaceBtwItems),
                                ProductAdditionalImages(
                                  additionalProductImagesURLs: imagesController
                                      .additionalProductImageUrls,
                                  onTapToAddImages: imagesController
                                      .selectMultipleProductImages,
                                  onTapToRemoveImage:
                                      imagesController.removeImage,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          ProductBrand(),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          ProductCategories(product: product),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          RSTargetAudienceWidget(
                            initialTargetAudience: product.targetAudience,
                          ),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          RSCouponWidget(product: product),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          RSOfferWidget(product: product),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          ProductTag(initialTags: product.tags ?? []),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          IsFeaturedWidget(product: product),
                          SizedBox(height: RSSizes.spaceBtwItems),

                          ProductVisibilityWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
