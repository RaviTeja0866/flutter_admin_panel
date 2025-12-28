import 'dart:developer';

class CartItemModel {
  final String productId;
  final String title;
  final String? brandName;
  final String? categoryId;
  final double price;
  final double originalPrice;
  final String image;
  final int quantity;
  final String? variationId;
  final Map<String, dynamic>? selectedVariation;

  CartItemModel({
    required this.productId,
    required this.title,
    this.brandName = '',
    this.categoryId,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.quantity,
    this.variationId = '',
    this.selectedVariation,
  }) {
    log(
      'CartItemModel created: productId=$productId, title=$title, price=$price, quantity=$quantity',
      name: 'CartItemModel',
    );
  }

  static CartItemModel empty() {
    return CartItemModel(
      productId: '',
      title: '',
      brandName: '',
      categoryId: '',
      price: 0.0,
      originalPrice: 0.0,
      image: '',
      quantity: 0,
      variationId: '',
      selectedVariation: {},
    );
  }
  /// Computed property for total amount
  double get totalAmount {
    final total = price * quantity;
    return total;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = {
      'productId': productId,
      'title': title,
      'brandName': brandName ?? '',
      'categoryId': categoryId,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'quantity': quantity,
      'variationId': variationId ?? '',
      'selectedVariation': selectedVariation,
    };
    return json;
  }

  /// Create instance from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final instance = CartItemModel(
      productId: json['productId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      brandName: json['brandName']?.toString() ?? '',
      categoryId: json['categoryId']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      image: json['image']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      variationId: json['variationId'] != null ? json['variationId'].toString() : '',
      selectedVariation: json['selectedVariation'] as Map<String, dynamic>?,
    );
    return instance;
  }

  /// Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.productId == productId &&
        other.variationId == variationId;
  }

  /// Override hashCode
  @override
  int get hashCode => productId.hashCode ^ variationId.hashCode;
}
