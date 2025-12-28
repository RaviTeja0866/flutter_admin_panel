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
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../controllers/product/product_images_controller.dart';
import '../widgets/offer_widget.dart';
import '../widgets/specifications_widget.dart';

class EditProductDesktopScreen extends StatelessWidget {
  const EditProductDesktopScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());
    return  Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BreadCrumbs
            RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Update product', breadcrumbItems: ['Update product']),
            SizedBox(height: RSSizes.spaceBtwSections),

            // Create Product
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: RSDeviceUtils.isTabletScreen(context) ? 2: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        RSProductStats(product: product),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Basic Information
                        ProductTitleAndDescription(),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Product specifications section
                        const RSProductSpecificationsWidget(),
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
                      ],
                    )),
            SizedBox(width: RSSizes.defaultSpace),

                // SideBar
                Expanded(
                    child: Column(
                      children: [
                        // Product Thumbnail
                        ProductThumbnailImage(),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Product Images
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
                        SizedBox(height: RSSizes.spaceBtwItems),

                        //Product Brand
                        ProductBrand(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Product Categories
                        ProductCategories(product: product),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        RSTargetAudienceWidget(initialTargetAudience: product.targetAudience),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        RSCouponWidget(product: product),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        RSOfferWidget(product: product),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        //Product Brand
                        ProductTag(initialTags: [],),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Is Featured widget
                        IsFeaturedWidget(product: product),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Product Visibility
                        ProductVisibilityWidget(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                      ],
                    )),
        ],
            )
          ],
        ),
        ),
      ),
    );
  }
}
