import 'package:flutter/material.dart';
import 'package:minimal_furniture_app/core/app_colors.dart';
import 'package:minimal_furniture_app/core/asset_res.dart';
import 'package:minimal_furniture_app/core/models/cart_line.dart';
import 'package:minimal_furniture_app/core/models/product.dart';

class AppData {
  static const double deliveryCharge = 50;

  static const List<Color> defaultColorOptions = [
    Color(0xff9E9E9E),
    Color(0xffFF8C42),
    AppColors.whiteColor,
    AppColors.accentTealColor,
    Color(0xff8B5A2B),
  ];

  static const List<Product> products = [
    Product(
      id: 'boogly-chair',
      name: 'Boogly chair',
      price: 180,
      image: AssetRes.booglyChairImg,
      isNew: true,
      colors: defaultColorOptions,
    ),
    Product(
      id: 'modern-sofa',
      name: 'Modern sofa',
      price: 200,
      image: AssetRes.modernSofaImg,
      isNew: true,
      colors: defaultColorOptions,
    ),
    Product(
      id: 'arm-chair',
      name: 'Arm chair',
      price: 150,
      image: AssetRes.armChairImg,
      isNew: true,
      colors: defaultColorOptions,
    ),
  ];

  static Product? productById(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  static List<Product> productsExcept(String id) {
    return products.where((product) => product.id != id).toList();
  }

  static List<CartLine> demoCartLines() {
    return products.map((product) => CartLine(product: product, quantity: 3)).toList();
  }

  static String cartDisplayName(Product product) {
    switch (product.id) {
      case 'boogly-chair':
        return 'Boogly Chair';
      case 'modern-sofa':
        return 'Modern Sofa';
      case 'arm-chair':
        return 'Arm Chair';
      default:
        return product.name;
    }
  }
}
