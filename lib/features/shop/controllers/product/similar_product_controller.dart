import 'package:get/get.dart';
import 'dart:developer';

import '../../../../data/repositories/product/similar_product_repository.dart';
import '../../models/product_model.dart';

class SimilarProductController extends GetxController {
  static SimilarProductController get instance => Get.find();

  final similarProductRepo = Get.put(SimilarProductRepository());

  /// RxList to store similar products for UI updates
  RxList<ProductModel> similarProducts = <ProductModel>[].obs;

  /// Track processing state
  final isProcessing = false.obs;



  /// Get similar products using a scoring algorithm
  Future<List<ProductModel>> getSimilarProductsByScore({
    required ProductModel currentProduct,
    int limit = 10,
    String? targetAudience,
  }) async {
    log('Fetching similar products by score for product ID: ${currentProduct.id}');
    isProcessing.value = true;

    try {
      // Use the current product's target audience if none is specified
      targetAudience = targetAudience ?? currentProduct.targetAudience;
      log('Filtering similar products for target audience: $targetAudience');

      final productPool = await similarProductRepo.getProductPool(
        limit: 50, // Increase pool size for better recommendations
        excludeId: currentProduct.id,
        targetAudience: targetAudience, // Filter by audience at database level for efficiency
      );

      log('Scoring ${productPool.length} products for similarity');

      // Define weight map for different similarity factors
      const weightMap = {
        'category': 5.0,  // Changed to double
        'type': 4.0,      // Changed to double
        'audience': 3.0,  // Changed to double
        'price': 3.0,     // Changed to double
        'attributes': 2.0, // Changed to double
        'tags': 2.0,      // Changed to double
        'isFeatured': 1.0, // Changed to double
      };

      Map<String, double> similarityScores = {};

      List<Map<String, dynamic>> scoredProducts = productPool.map((product) {
        double score = 0.0;

        // Category matching - safely handle null values
        if (product.categoryId != null &&
            currentProduct.categoryId != null &&
            product.categoryId == currentProduct.categoryId) {
          score += weightMap['category']!;
          log('Category match for product ${product.id}: +${weightMap['category']}');
        }

        // Product type matching - safely handle null values
        if (product.productType == currentProduct.productType) {
          score += weightMap['type']!;
          log('Type match for product ${product.id}: +${weightMap['type']}');
        }

        // Target audience matching - safely handle null values
        if (product.targetAudience == currentProduct.targetAudience) {
          score += weightMap['audience']!;
          log('Audience match for product ${product.id}: +${weightMap['audience']}');
        }

        // Price range matching (within 20% above or below)
        final priceMin = currentProduct.price * 0.8;
        final priceMax = currentProduct.price * 1.2;
        if (product.price >= priceMin && product.price <= priceMax) {
          score += weightMap['price']!;
          log('Price match for product ${product.id}: +${weightMap['price']}');
        }

        // Product attributes matching - safely handle null values
        if (currentProduct.productAttributes != null &&
            product.productAttributes != null) {
          for (var attr1 in currentProduct.productAttributes!) {
            for (var attr2 in product.productAttributes!) {
              if (attr1.name == attr2.name &&
                  attr1.values != null &&
                  attr2.values != null &&
                  attr1.values!.any((v) => attr2.values!.contains(v))) {
                score += weightMap['attributes']!;
                log('Attribute match for product ${product.id}: +${weightMap['attributes']}');
                break; // Count each attribute match only once
              }
            }
          }
        }

        // Tags matching - safely handle null values
        if (currentProduct.tags != null &&
            product.tags != null &&
            currentProduct.tags!.isNotEmpty &&
            product.tags!.isNotEmpty) {
          for (var tag in currentProduct.tags!) {
            if (product.tags!.contains(tag)) {
              score += weightMap['tags']!;
              log('Tag match for product ${product.id}: +${weightMap['tags']}');
              break; // Count tag match only once
            }
          }
        }

        // Featured status matching - Fix for nullable expression
        // isFeatured might be nullable, so check if it's non-null before comparing
        if (currentProduct.isFeatured == true && product.isFeatured == true) {
          score += weightMap['isFeatured']!;
          log('Featured match for product ${product.id}: +${weightMap['isFeatured']}');
        }

        // Add slight randomization to break ties
        score += ((DateTime.now().millisecond % 3) - 1).toDouble();

        // Store final score
        similarityScores[product.id] = score;
        log('Final score for product ${product.id}: $score');

        return {'product': product, 'score': score};
      }).toList();

      // Sort by score (highest first) - with safer comparison
      scoredProducts.sort((a, b) {
        final scoreA = a['score'] as double;
        final scoreB = b['score'] as double;
        return scoreB.compareTo(scoreA);
      });

      log('Returning top $limit scored products');

      // Update similarity scores in Firestore
      await similarProductRepo.updateSimilarityScores(currentProduct.id, similarityScores);

      // Take top results and update observable list
      final result = scoredProducts.take(limit).map((item) => item['product'] as ProductModel).toList();
      similarProducts.assignAll(result);
      return result;
    } catch (e) {
      log('Error in getSimilarProductsByScore: $e');
      return [];
    } finally {
      isProcessing.value = false;
    }
  }
  Future<void> updateSimilaritiesAfterProductChange(ProductModel newProduct) async {
    // Update similarity scores for the new product itself
    await getSimilarProductsByScore(currentProduct: newProduct);

    // Update similarity scores for other existing products that may be similar to the new product
    await similarProductRepo.updateSimilarityForExistingProducts(newProduct);
  }
}