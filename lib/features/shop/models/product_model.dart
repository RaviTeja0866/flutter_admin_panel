import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_specification_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:roguestore_admin_panel/utils/formatters/formatter.dart';
import 'brand_model.dart';

class ProductModel {
  String id;
  String title;
  String thumbnail;
  String productType;
  String targetAudience;
  String? sizeGuide;
  String? coupon;
  int stock;
  int views;
  int wishlistCount;
  String? sku;
  String? description;
  String? categoryId;
  String? categoryName;
  String? categorySlug;
  double salePrice;
  String? offerTag;
  double price;
  bool? isFeatured;
  BrandModel? brand;
  List<String>? images;
  int soldQuantity;
  List<String>? tags;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;
  ProductSpecifications? specifications; // Add specifications field
  Map<String, double>? similarityScores; // New Field
  DateTime? createdAt;
  DateTime? updatedAt;


  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    required this.targetAudience,
    this.sizeGuide,
    this.coupon,
    this.sku,
    this.views = 0,
    this.wishlistCount = 0,
    this.brand,
    this.images,
    this.salePrice = 0.0,
    this.offerTag,
    this.isFeatured,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.description,
    this.soldQuantity = 0,
    this.tags,
    this.productAttributes,
    this.productVariations,
    this.specifications,
    this.similarityScores,
    this.createdAt,
    this.updatedAt,
  });

  String get formatedDate => RSFormatter.formatDate(createdAt);
  ///Create a Empty Function for clean code
  static ProductModel empty() {
    return ProductModel(id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '', targetAudience: 'unisex');
  }

  /// to json format
  toJson() {
    return{
      'SKU' : sku,
      'Title' : title,
      'Stock' : stock,
      'Views': views,
      'WishlistCount' : wishlistCount,
      'Price' : price,
      'Images' : images ?? [],
      'Thumbnail' : thumbnail,
      'SalePrice' : salePrice,
      'OfferTag' : offerTag,
      'IsFeatured' : isFeatured,
      'CategoryId' : categoryId,
      'CategoryName' : categoryName,
      'CategorySlug' : categorySlug,
      'Brand' : brand!.toJson(),
      'Description' : description,
      'ProductType' : productType,
      'TargetAudience': targetAudience,
      'SizeGuide': sizeGuide,
      'Coupon': coupon,
      'SoldQuantity': soldQuantity,
      'Tags': tags ?? [],
      'ProductAttributes' : productAttributes != null ? productAttributes!.map((e) => e.toJson()).toList() :[],
      'ProductVariations' : productVariations != null ? productVariations!.map((e) => e.toJson()).toList() :[],
      'Specifications': specifications?.toJson(),
      'SimilarityScores': similarityScores,
      'UpdatedAt': updatedAt ?? DateTime.now(),
      'CreatedAt': createdAt,
    };
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return ProductModel.empty();
    final data = document.data()!;
    try {
      return ProductModel(
        id: document.id,
        sku: data['SKU'],
        title: data['Title'],
        stock: int.tryParse(data['Stock']?.toString() ?? '') ?? 0, // Convert String to int
        views: int.tryParse(data['Views']?.toString() ?? '') ?? 0,
        wishlistCount: int.tryParse(data['WishlistCount']?.toString() ?? '') ?? 0,
        isFeatured: data['IsFeatured'] ?? false,
        price: double.tryParse(data['Price']?.toString() ?? '') ?? 0.0,
        salePrice: double.tryParse(data['SalePrice']?.toString() ?? '') ?? 0.0,
        soldQuantity: int.tryParse(data['SoldQuantity']?.toString() ?? '') ?? 0,
        offerTag: data['OfferTag'] ?? '',
        thumbnail: data['Thumbnail'] ?? '',
        categoryId: data['CategoryId'] ?? '',
        categoryName: data['CategoryName'] ?? '',
        categorySlug: data['CategorySlug'] ?? '',
        description: data['Description'] ?? '',
        productType: data['ProductType'] ?? '',
        targetAudience: data['TargetAudience'] ?? 'unisex',
        sizeGuide: data['SizeGuide'] ?? '',
        coupon: data['Coupon'] ?? '',
        brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
        images: data['Images'] != null ? List<String>.from(data['Images']) : [],
        tags: data['Tags'] != null ? List<String>.from(data['Tags']) : [],
        productAttributes: (data['ProductAttributes'] as List<dynamic>?)
            ?.map((e) => ProductAttributeModel.fromJson(e))
            .toList(),
        productVariations: (data['ProductVariations'] as List<dynamic>?)
            ?.map((e) => ProductVariationModel.fromJson(e))
            .toList(),
        specifications: data['Specifications'] != null
            ? ProductSpecifications.fromJson(data['Specifications'])
            : null,
        similarityScores: data['SimilarityScores'] != null
            ? _parseScoresMap(data['SimilarityScores'])
            : {},
        createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
        updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      );
    } catch (e) {
      print("Error parsing document ${document.id}: $e");
      print("Data: $data");
      return ProductModel.empty();
    }
  }

  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      sku: data['SKU'],
      title: data['Title'],
      stock: int.tryParse(data['Stock']?.toString() ?? '') ?? 0, // Handle String to int conversion
      views: int.tryParse(data['Views']?.toString() ?? '') ?? 0,
      wishlistCount: int.tryParse(data['WishlistCount']?.toString() ?? '') ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.tryParse(data['Price']?.toString() ?? '') ?? 0.0,
      salePrice: double.tryParse(data['SalePrice']?.toString() ?? '') ?? 0.0,
      soldQuantity: int.tryParse(data['SoldQuantity']?.toString() ?? '') ?? 0,
      offerTag: data['OfferTag'] ?? '',
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      categoryName: data['CategoryName'] ?? '',
      categorySlug: data['CategorySlug'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      targetAudience: data['TargetAudience'] ?? 'unisex',
      sizeGuide: data['SizeGuide'] ?? '',
      coupon: data['Coupon'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      tags: data['Tags'] != null ? List<String>.from(data['Tags']) : [],
      productAttributes: (data['ProductAttributes'] as List<dynamic>?)
          ?.map((e) => ProductAttributeModel.fromJson(e))
          .toList(),
      productVariations: (data['ProductVariations'] as List<dynamic>?)
          ?.map((e) => ProductVariationModel.fromJson(e))
          .toList(),
      specifications: data['Specifications'] != null
          ? ProductSpecifications.fromJson(data['Specifications'])
          : null,
      similarityScores: data['SimilarityScores'] != null
          ? _parseScoresMap(data['SimilarityScores'])
          : {},
      createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
      updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
    );
  }

  // Helper method to safely convert scores to Map<String, double>
  static Map<String, double> _parseScoresMap(dynamic scoresData) {
    Map<String, double> result = {};

    if (scoresData is Map) {
      scoresData.forEach((key, value) {
        if (key is String) {
          // Handle different numeric types (int, double) by converting to string first
          if (value is int) {
            result[key] = value.toDouble();
          } else if (value is double) {
            result[key] = value;
          } else {
            // Try to parse from string or other formats
            final doubleValue = double.tryParse(value.toString());
            if (doubleValue != null) {
              result[key] = doubleValue;
            }
          }
        }
      });
    }

    return result;
  }
}