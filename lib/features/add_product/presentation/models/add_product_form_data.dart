import 'dart:io';

import 'package:fruit_hub_dashboard/features/add_product/domain/entities/product_entity.dart';
import 'package:fruit_hub_dashboard/features/add_product/domain/entities/review_entity.dart';

class AddProductFormData {
  const AddProductFormData({
    required this.name,
    required this.code,
    required this.description,
    required this.price,
    required this.expirationMonths,
    required this.numberOfCalories,
    required this.unitAmount,
    required this.image,
    required this.isFeatured,
    required this.isOrganic,
  });

  final String name;
  final String code;
  final String description;
  final num price;
  final num expirationMonths;
  final num numberOfCalories;
  final num unitAmount;
  final File image;
  final bool isFeatured;
  final bool isOrganic;

  ProductEntity toEntity() {
    return ProductEntity(
      name: name,
      reviews: [
        ReviewEntity(
          name: 'tharwat',
          image:
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pexels.com%2Fsearch%2Fbeautiful%2F&psig=AOvVaw19xjUBre0RXfV2IZ-cEAEV&ust=1726749821993000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCPCJ3L_CzIgDFQAAAAAdAAAAABAE',
          ratting: 5,
          date: DateTime.now().toIso8601String(),
          reviewDescription: 'Nice product',
        ),
      ],
      isOrganic: isOrganic,
      code: code,
      description: description,
      expirationsMonths: expirationMonths.toInt(),
      numberOfCalories: numberOfCalories.toInt(),
      unitAmount: unitAmount.toInt(),
      price: price,
      image: image,
      isFeatured: isFeatured,
    );
  }
}
