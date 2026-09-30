import 'package:flutter/foundation.dart';
import 'package:minimal_furniture_app/core/app_data.dart';
import 'package:minimal_furniture_app/core/models/cart_line.dart';
import 'package:minimal_furniture_app/core/models/product.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() : _cartLines = AppData.demoCartLines();

  List<CartLine> _cartLines;
  final Set<String> _favoriteIds = {};
  final Map<String, int> _selectedColorIndexes = {};

  List<CartLine> get cartLines => List.unmodifiable(_cartLines);

  double get subtotal => _cartLines.fold(0, (sum, line) => sum + line.lineTotal);

  double get total => subtotal + AppData.deliveryCharge;

  int selectedColorIndex(String productId) => _selectedColorIndexes[productId] ?? 2;

  void selectColor(String productId, int index) {
    _selectedColorIndexes[productId] = index;
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _cartLines.indexWhere((line) => line.product.id == product.id);
    if (index == -1) {
      _cartLines = [..._cartLines, CartLine(product: product, quantity: quantity)];
    } else {
      final line = _cartLines[index];
      _cartLines = [
        ..._cartLines.sublist(0, index),
        line.copyWith(quantity: line.quantity + quantity),
        ..._cartLines.sublist(index + 1),
      ];
    }
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (quantity < 1 || index < 0 || index >= _cartLines.length) return;
    _cartLines = [
      ..._cartLines.sublist(0, index),
      _cartLines[index].copyWith(quantity: quantity),
      ..._cartLines.sublist(index + 1),
    ];
    notifyListeners();
  }
}
