class ProductAttributeModel {
  String? name;
  final List<String>? values;
  late final Map<String, dynamic>? additionalInfo; // To store color codes or image paths

  ProductAttributeModel({
    this.name,
    this.values,
    this.additionalInfo,
  });

  /// JSON Format
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Values': values,
      'AdditionalInfo': additionalInfo,
    };
  }

  /// Map JSON oriented document snapshot form Firebase to ProductAttributeModel
  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    if (document.isEmpty) return ProductAttributeModel();

    return ProductAttributeModel(
      name: document.containsKey('Name') ? document['Name'] : '',
      values: document.containsKey('Values') ? List<String>.from(document['Values']) : [],
    );
  }
}
