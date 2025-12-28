import 'package:get/get.dart';

class ProductVariationModel {
  final String id;
  String sku;
  RxList<String> images;  // RxList for reactive images
  String? description;
  double price;
  double salePrice;
  int stock;
  int soldQuantity;
  Map<String, String> attributeValues;
  final Map<String, dynamic>? metadata; // For storing color codes and other variation metadata


  ProductVariationModel({
    required this.id,
    this.sku = '',
    List<String> images = const [],  // Default empty list
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
    this.soldQuantity = 0,
    required this.attributeValues,
    this.metadata,
  }) : images = RxList<String>(images);

  static ProductVariationModel empty() => ProductVariationModel(id: '', attributeValues: {});

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Images': images,  // Reactive list of images
      'Description': description,
      'Price': price,
      'SalePrice': salePrice,
      'SKU': sku,
      'Stock': stock,
      'SoldQuantity': soldQuantity,
      'AttributeValues': attributeValues,
      'Metadata': metadata,
    };
  }

  /// Factory constructor for creating an object from JSON
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: data['Id'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      sku: data['SKU'] ?? '',
      stock: data['Stock'] ?? 0,
      soldQuantity: data['SoldQuantity'] ?? 0,
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      images: List<String>.from(data['Images'] ?? []),  // Reactive list of images
      attributeValues: Map<String, String>.from(data['AttributeValues']),
      description: data['Description'] ?? '',
      metadata: document['Metadata'] != null
          ? Map<String, dynamic>.from(document['Metadata'])
          : null,
    );
  }
}
