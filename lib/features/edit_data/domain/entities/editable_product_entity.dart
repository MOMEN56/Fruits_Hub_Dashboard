class EditableProductEntity {
  const EditableProductEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.expirationsMonths,
    required this.numberOfCalories,
    required this.unitAmount,
    required this.isOrganic,
    required this.isFeatured,
    required this.isVisible,
  });

  final String id;
  final String name;
  final String code;
  final String description;
  final double price;
  final String imageUrl;
  final int expirationsMonths;
  final int numberOfCalories;
  final int unitAmount;
  final bool isOrganic;
  final bool isFeatured;
  final bool isVisible;

  EditableProductEntity copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    double? price,
    String? imageUrl,
    int? expirationsMonths,
    int? numberOfCalories,
    int? unitAmount,
    bool? isOrganic,
    bool? isFeatured,
    bool? isVisible,
  }) {
    return EditableProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      expirationsMonths: expirationsMonths ?? this.expirationsMonths,
      numberOfCalories: numberOfCalories ?? this.numberOfCalories,
      unitAmount: unitAmount ?? this.unitAmount,
      isOrganic: isOrganic ?? this.isOrganic,
      isFeatured: isFeatured ?? this.isFeatured,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'expirations_months': expirationsMonths,
      'number_of_calories': numberOfCalories,
      'unit_amount': unitAmount,
      'is_organic': isOrganic,
      'is_featured': isFeatured,
      'is_visible': isVisible,
    };
  }

  factory EditableProductEntity.fromJson(Map<String, dynamic> json) {
    return EditableProductEntity(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: _toDouble(json['price']),
      imageUrl: (json['image_url'] ?? '').toString(),
      expirationsMonths: _toInt(json['expirations_months']),
      numberOfCalories: _toInt(json['number_of_calories']),
      unitAmount: _toInt(json['unit_amount']),
      isOrganic: _toBool(json['is_organic']),
      isFeatured: _toBool(json['is_featured']),
      isVisible:
          json.containsKey('is_visible') ? _toBool(json['is_visible']) : true,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}
