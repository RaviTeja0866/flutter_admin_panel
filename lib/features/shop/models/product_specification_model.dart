import 'package:flutter/material.dart';

class ProductSpecifications {
  final String id;

  // All Top Wear
  String fabric;
  String pattern;
  String fit;
  String neck;
  String sleeve;
  String style;
  String washCare;

  // All Bottom Wear
  // Some properties are shared with top wear
  String waistRise;
  // Add other properties as needed
  String material;
  String color;
  String weight;
  String dimension;
  String warranty;
  String brand;
  String origin;

  ProductSpecifications({
    required this.id,
    this.fabric = '',
    this.pattern = '',
    this.fit = '',
    this.neck = '',
    this.sleeve = '',
    this.style = '',
    this.washCare = '',
    this.waistRise = '',
    this.material = '',
    this.color = '',
    this.weight = '',
    this.dimension = '',
    this.warranty = '',
    this.brand = '',
    this.origin = '',
  });

  /// Create an empty specifications model
  static ProductSpecifications empty() => ProductSpecifications(id: '');

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Fabric': fabric,
      'Pattern': pattern,
      'Fit': fit,
      'Neck': neck,
      'Sleeve': sleeve,
      'Style': style,
      'WashCare': washCare,
      'WaistRise': waistRise,
      'Material': material,
      'Color': color,
      'Weight': weight,
      'Dimension': dimension,
      'Warranty': warranty,
      'Brand': brand,
      'Origin': origin,
    };
  }

  /// Factory constructor for creating an object from JSON
  factory ProductSpecifications.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductSpecifications.empty();

    return ProductSpecifications(
      id: data['Id'] ?? '',
      fabric: data['Fabric'] ?? '',
      pattern: data['Pattern'] ?? '',
      fit: data['Fit'] ?? '',
      neck: data['Neck'] ?? '',
      sleeve: data['Sleeve'] ?? '',
      style: data['Style'] ?? '',
      washCare: data['WashCare'] ?? '',
      waistRise: data['WaistRise'] ?? '',
      material: data['Material'] ?? '',
      color: data['Color'] ?? '',
      weight: data['Weight'] ?? '',
      dimension: data['Dimension'] ?? '',
      warranty: data['Warranty'] ?? '',
      brand: data['Brand'] ?? '',
      origin: data['Origin'] ?? '',
    );
  }

  /// Get all available specification types from the model - without using mirrors
  static List<String> getAvailableSpecificationTypesNoMirrors() {
    // This is a manually maintained list of all the property names
    // Each name's first letter is capitalized for UI display
    return [
      'Fabric',
      'Pattern',
      'Fit',
      'Neck',
      'Sleeve',
      'Style',
      'WashCare',
      'WaistRise',
      'Material',
      'Color',
      'Weight',
      'Dimension',
      'Warranty',
      'Brand',
      'Origin',
    ];
  }
}