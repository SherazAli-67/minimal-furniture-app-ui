import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.isNew = false,
    this.colors = const [],
  });

  final String id;
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final List<Color> colors;
}
