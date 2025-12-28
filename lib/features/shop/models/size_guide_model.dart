import 'package:cloud_firestore/cloud_firestore.dart';

class SizeGuideModel {
  String id;
  String garmentType;
  List<String> sizes;
  List<String> measurements;
  Map<String, Map<String, String>> sizeChart; // Change to store strings
  String imageURL;
  String measurementUnit;
  DateTime? createdAt;
  DateTime? updatedAt;

  SizeGuideModel({
    required this.id,
    required this.garmentType,
    required this.sizes,
    required this.measurements,
    required this.sizeChart,
    required this.imageURL,
    this.measurementUnit = 'Inches',
    this.createdAt,
    this.updatedAt,
  });

  // Static function to create an empty size guide model
  static SizeGuideModel empty() => SizeGuideModel(
    id: '',
    garmentType: '',
    sizes: [],
    imageURL: '',
    measurements: [],
    sizeChart: {},
    measurementUnit: 'Inches',
  );

  // Helper getter for formatted dates
  String get formattedCreatedDate => createdAt != null
      ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}'
      : '';

  String get formattedUpdatedDate => updatedAt != null
      ? '${updatedAt!.day}/${updatedAt!.month}/${updatedAt!.year}'
      : '';

  // Map to json
  Map<String, dynamic> toJson() {
    try {
      print('Converting SizeGuideModel to JSON: $this');
      return {
        'Id': id,
        'GarmentType': garmentType,
        'Sizes': sizes,
        'Measurements': measurements,
        'SizeChart': sizeChart, // No need for extra map conversion
        'MeasurementUnit': measurementUnit,
        'ImageUrl': imageURL,
        'CreatedAt': createdAt,
        'UpdatedAt': updatedAt,
      };
    } catch (e, stackTrace) {
      print('Error in toJson: $e\nStack trace: $stackTrace');
      return {};
    }
  }

  /// Factory method to create SizeGuideModel from Firebase snapshot
  factory SizeGuideModel.fromSnapshot(DocumentSnapshot snapshot) {
    print('Parsing snapshot: ${snapshot.id}');
    final data = snapshot.data() as Map<String, dynamic>;
    try {
      print('Raw Firestore Data: $data');

      return SizeGuideModel(
        id: snapshot.id,
        garmentType: data['GarmentType']?.toString() ?? '',
        sizes: data['Sizes'] != null
            ? List<String>.from(data['Sizes'])
            : [],
        measurements: data['Measurements'] != null
            ? List<String>.from(data['Measurements'])
            : [],
        sizeChart: (data['SizeChart'] ?? {}).map<String, Map<String, String>>(
              (key, value) {
            // Ensure we handle the LinkedMap correctly and convert it to the required type
            final linkedMap = value as Map<dynamic, dynamic>;
            return MapEntry(
              key.toString(),
              linkedMap.map<String, String>((k, v) {
                return MapEntry(k.toString(), v.toString());
              }),
            );
          },
        ),
        imageURL: data['ImageUrl'] ?? '',
        measurementUnit: data['MeasurementUnit']?.toString() ?? 'Inches',
        createdAt: data['CreatedAt'] != null
            ? (data['CreatedAt'] as Timestamp).toDate()
            : null,
        updatedAt: data['UpdatedAt'] != null
            ? (data['UpdatedAt'] as Timestamp).toDate()
            : null,
      );
    } catch (e, stackTrace) {
      print('Error parsing SizeGuideModel from Firestore: $e\nStack trace: $stackTrace');
      throw Exception('Failed to parse SizeGuideModel from Firestore: $e');
    }
  }

  // Helper method to validate the size chart structure
  bool validateSizeChart() {
    try {
      print('Validating Size Chart: Sizes: $sizes, Measurements: $measurements');
      if (sizes.isEmpty || measurements.isEmpty) return false;

      // Check if all sizes have measurements
      for (String size in sizes) {
        if (!sizeChart.containsKey(size)) {
          print('Missing size in sizeChart: $size');
          return false;
        }

        // Check if all measurements exist for each size
        for (String measurement in measurements) {
          if (!sizeChart[size]!.containsKey(measurement)) {
            print('Missing measurement $measurement for size $size');
            return false;
          }
        }
      }

      print('Size chart validation successful.');
      return true;
    } catch (e) {
      print('Error in validateSizeChart: $e');
      return false;
    }
  }
}
