class FieldModel {
  final int id;
  final String name;
  final String? cropType;
  final double? area;

  FieldModel({required this.id, required this.name, this.cropType, this.area});

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'],
      name: json['name'],
      cropType: json['crop_type'],
      area: (json['area_m2'] as num?)?.toDouble(),
    );
  }
}
