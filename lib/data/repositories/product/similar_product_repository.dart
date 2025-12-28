import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/product_model.dart';

class SimilarProductRepository extends GetxController {
  static SimilarProductRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get products by category
  Future<List<ProductModel>> getProductsByCategory(String categoryId, {int limit = 10, String excludeId = ''}) async {
    try {
      print('Fetching products for category: $categoryId with limit: $limit, excluding: $excludeId');
      final snapshot = await _db
          .collection('Products')
          .where('CategoryId', isEqualTo: categoryId)
          .limit(limit + 1) // Fetch an extra product in case `excludeId` needs filtering
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .where((product) => product.id != excludeId) // Manual filtering
          .take(limit)
          .toList();

      print('Fetched ${products.length} products for category: $categoryId');
      return products;
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }



  /// Get products by type and audience
  Future<List<ProductModel>> getProductsByTypeAndAudience(
      String productType, String targetAudience, {int limit = 10, String excludeId = ''}) async {
    try {
      print('Fetching products for type: $productType and audience: $targetAudience with limit: $limit, excluding: $excludeId');
      final snapshot = await _db
          .collection('Products')
          .where('ProductType', isEqualTo: productType)
          .where('TargetAudience', isEqualTo: targetAudience)
          .limit(limit + 1)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .where((product) => product.id != excludeId)
          .take(limit)
          .toList();

      print('Fetched ${products.length} products for type: $productType and audience: $targetAudience');
      return products;
    } catch (e) {
      print('Error fetching products by type and audience: $e');
      return [];
    }
  }

  /// Get featured products
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10, String excludeId = ''}) async {
    try {
      print('Fetching featured products with limit: $limit, excluding: $excludeId');
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(limit + 1)
          .get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .where((product) => product.id != excludeId)
          .take(limit)
          .toList();

      print('Fetched ${products.length} featured products');
      return products;
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  /// Get a pool of products for similarity scoring
    Future<List<ProductModel>> getProductPool({
    int limit = 10,
    String excludeId = '',
    String? targetAudience,
  }) async {
    try {
      print('Fetching product pool with limit: $limit, excluding: $excludeId, audience: $targetAudience');

      Query query = _db.collection('Products').limit(limit + 1);

      // Add filter by target audience if provided
      if (targetAudience != null && targetAudience.isNotEmpty) {
        query = query.where('TargetAudience', isEqualTo: targetAudience);
      }

      final snapshot = await query.get();

      final products = snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .where((product) => product.id != excludeId)
          .take(limit)
          .toList();

      print('Fetched ${products.length} products in the pool for audience: ${targetAudience ?? "all"}');
      return products;
    } catch (e) {
      print('Error fetching product pool: $e');
      return [];
    }
  }

  Future<void> updateSimilarityForExistingProducts(ProductModel newProduct) async {
    final productPool = await getProductPool(
      limit: 100,
      excludeId: newProduct.id,
      targetAudience: newProduct.targetAudience,
    );

    for (final oldProduct in productPool) {
      double score = 0.0;

      // Scoring logic - same as in controller or extract to a shared method
      if (oldProduct.categoryId == newProduct.categoryId) score += 5.0;
      if (oldProduct.productType == newProduct.productType) score += 4.0;
      if (oldProduct.targetAudience == newProduct.targetAudience) score += 3.0;
      if ((oldProduct.price >= newProduct.price * 0.8) &&
          (oldProduct.price <= newProduct.price * 1.2)) score += 3.0;

      // Add more criteria here if needed (attributes, tags, featured, etc.)

      if (score > 0) {
        final oldProductDoc = await _db.collection('Products').doc(oldProduct.id).get();
        Map<String, dynamic>? oldScores = oldProductDoc.data()?['SimilarityScores'];
        oldScores ??= {};

        oldScores[newProduct.id] = score;
        await _db.collection('Products').doc(oldProduct.id).update({
          'SimilarityScores': oldScores,
        });
      }
    }
  }

  Future<void> updateSimilarityScores(String productId, Map<String, double> scores) async {
    try {
      await _db.collection('Products').doc(productId).update({
        'SimilarityScores': scores,
      });
    } catch (e) {
      print('Error updating similarity scores: $e');
    }
  }

}
