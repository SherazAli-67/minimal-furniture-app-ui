import 'package:minimal_furniture_app/core/models/product.dart';

class CartLine {
  const CartLine({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}
