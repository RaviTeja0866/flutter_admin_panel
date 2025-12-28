import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/create_product/widgets/coupon_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/create_product/widgets/is_featured_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/create_product/widgets/offer_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/create_product/widgets/tag_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/create_product/widgets/target_audience_widget.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/create_product/widgets/title_description.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/size_guide_widget.dart';
import '../widgets/specifications_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class CreateProductDesktopScreen extends StatelessWidget {
  const CreateProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImagesController());
    return  Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BreadCrumbs
            RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Create product', breadcrumbItems: ['Create product']),
            SizedBox(height: RSSizes.spaceBtwSections),

            // Create Product
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: RSDeviceUtils.isTabletScreen(context) ? 2: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information
                        ProductTitleAndDescription(),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        ProductSpecificationsWidget(),
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
                        SizedBox(height: RSSizes.spaceBtwItems),

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
                        ProductCategories(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Target Audience
                        RSTargetAudienceWidget(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Size Guide
                        RSProductSizeGuide(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Coupon Widget
                        RSCouponWidget(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        RSOfferWidget(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        //Product Tag
                        ProductTag(),
                        SizedBox(height: RSSizes.spaceBtwItems),

                        // Is Featured
                        IsFeaturedWidget(),
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
