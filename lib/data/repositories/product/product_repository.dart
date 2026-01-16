import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_category_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';

import '../../../features/shop/models/banner_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  // Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all Products from the 'Products' collection
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<ProductModel> getProductById(String productId) async {
    try {
      final doc =
      await _db.collection('Products').doc(productId).get();

      if (!doc.exists) {
        throw 'Product not found';
      }

      return ProductModel.fromSnapshot(doc);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch product';
    }
  }


  // Get all ProductCategories from the 'ProductCategory' collection
  Future<List<ProductCategoryModel>> getProductCategories(
      String productId) async {
    try {
      final snapshot = await _db
          .collection('ProductCategory')
          .where('productId', isEqualTo: productId)
          .get();
      return snapshot.docs
          .map((querySnapshot) =>
              ProductCategoryModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Fetch total views from Firestore
  Future<int> fetchTotalViews(String productId) async {
    try {
      print("Fetching views for Product: $productId...");

      DocumentSnapshot doc = await _db.collection('Products').doc(productId).get();

      if (doc.exists && doc.data() != null) {
        int productViews = (doc['views'] ?? 0) as int;
        print("✅ Product ID: $productId - Views: $productViews");
        return productViews;
      } else {
        print("❌ Product not found or has no views field.");
        return 0;
      }
    } catch (e) {
      print("❌ Error fetching product views: $e");
      return 0;
    }
  }

  /// Fetch total wishlistCount from Firestore
  Future<int> getWishlistCount(String productId) async {
    try {
      final productSnapshot = await _db.collection('Products').doc(productId).get();
      return productSnapshot.data()?['wishlistCount'] ?? 0;
    } catch (e) {
      print("Error fetching wishlist count: $e");
      return 0;
    }
  }

  Future<BannerModel?> getProductBanner(String productId) async {
    try {
      print("[BannerRepository] Fetching banner for product ID: $productId");

      // Fetch product details from Firestore
      final productDoc = await _db.collection('Products').doc(productId).get();

      if (!productDoc.exists) {
        print("[BannerRepository] Product not found: $productId");
        return null;
      }

      // Extract banner value from the product document
      final bannerValue = productDoc.data()?['OfferTag']?.toString();
      print("[BannerRepository] Retrieved banner value from product: $bannerValue");

      if (bannerValue == null || bannerValue.isEmpty) {
        print("[BannerRepository] No banner associated with product: $productId");
        return null; // No banner found
      }

      // Fetch the banner data from Banners collection using value
      print("[BannerRepository] Searching for banner in Firestore with value: $bannerValue");

      final bannerQuery = await _db
          .collection('Banners')
          .where('value', isEqualTo: bannerValue)
          .limit(1)
          .get();

      if (bannerQuery.docs.isEmpty) {
        print("[BannerRepository] No banner found in Firestore for value: $bannerValue");
        return null;
      }

      print("[BannerRepository] Banner found: ${bannerQuery.docs.first.id}");
      return BannerModel.fromSnapshot(bannerQuery.docs.first);
    } catch (e) {
      print("[BannerRepository] Unexpected error fetching banner: $e");
      return null;
    }
  }

// Get coupon for a specific product using the coupon title stored in product
  Future<CouponModel?> getProductCoupon(String productId) async {
    try {
      print("[CouponRepository] Fetching coupon for product ID: $productId");

      // Fetch product details from Firestore
      final productSnapshot =
      await _db.collection('Products').doc(productId).get();

      if (!productSnapshot.exists) {
        print("[CouponRepository] Product not found: $productId");
        return null;
      }

      // Extract coupon title
      final couponTitle = productSnapshot.data()?['Coupon'] ?? '';
      print(
          "[CouponRepository] Retrieved coupon title from product: $couponTitle");

      if (couponTitle.isEmpty) {
        print(
            "[CouponRepository] No coupon associated with product: $productId");
        return null; // No coupon found
      }

      // Fetch the coupon data from Coupons collection using title
      print(
          "[CouponRepository] Searching for coupon in Firestore with title: ${couponTitle.toLowerCase()}");

      final couponSnapshot = await _db
          .collection('Coupons')
          .where('Title', isEqualTo: couponTitle) // Remove toLowerCase()
          .limit(1)
          .get();

      if (couponSnapshot.docs.isEmpty) {
        print(
            "[CouponRepository] No coupon found in Firestore for title: ${couponTitle.toLowerCase()}");
        return null;
      }

      print("[CouponRepository] Coupon found: ${couponSnapshot.docs.first.id}");
      return CouponModel.fromSnapshot(couponSnapshot.docs.first);
    } on FirebaseException catch (e) {
      print("[CouponRepository] FirebaseException: ${e.code} - ${e.message}");
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      print("[CouponRepository] PlatformException: ${e.code} - ${e.message}");
      throw RSPlatformException(e.code).message;
    } catch (e) {
      print("[CouponRepository] Unexpected error: $e");
      throw 'Something went wrong. Please try again';
    }
  }

  // Get all Tags from the 'Products' collection
  Future<List<ProductModel>> getProductsByTag(String tag) async {
    try {
      final querySnapshot = await _db
          .collection('Products')
          .where('Tags', arrayContains: tag)
          .get();
      print('Query executed for tag: $tag');
      print('Number of documents found: ${querySnapshot.docs.length}');
      return querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Create a Product in the 'Products' collection
  Future<String> createProduct(ProductModel product) async {
    try {
      final result = await _db.collection('Products').add(product.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Create a ProductCategory in the 'ProductCategory' collection
  Future<String> createProductCategory(
      ProductCategoryModel productCategory) async {
    try {
      final result =
          await _db.collection('ProductCategory').add(productCategory.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update an Existing Product in the 'Products' collection
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _db.collection('Products').doc(product.id).update(product.toJson());
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update Specific Value in a Product
  Future<void> updateProductSpecificValue(id, Map<String, dynamic> data) async {
    try {
      await _db.collection('Products').doc(id).update(data);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteProductCategory(
      String productId, String categoryId) async {
    try {
      // Query Firestore for matching documents
      final querySnapshot = await _db
          .collection('ProductCategory')
          .where('productId', isEqualTo: productId)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return;
      }

      // Delete each document found
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Delete an Existing Product in the 'Products' collection
  Future<void> deleteProduct(ProductModel product) async {
    try {
      await _db.runTransaction((transaction) async {
        final productRef = _db.collection('Products').doc(product.id);
        final productSnap = await transaction.get(productRef);

        if (!productSnap.exists) {
          throw Exception('Product not found');
        }

        // Fetch Product Categories
        final productCategoriesSnapshot = await _db
            .collection('ProductCategory')
            .where('productId', isEqualTo: product.id)
            .get();
        final productCategories = productCategoriesSnapshot.docs
            .map((e) => ProductCategoryModel.fromSnapshot(e))
            .toList();

        if (productCategories.isNotEmpty) {
          for (var productCategory in productCategories) {
            transaction.delete(
                _db.collection('ProductCategory').doc(productCategory.id));
          }
        }
        transaction.delete(productRef);
      });
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
