import '../../data/models/cart_models.dart';

enum CartStatus { initial, loading, success, failure }

class CartState {
  const CartState({
    this.status = CartStatus.initial,
    this.cart = const CartData.empty(),
    this.message,
  });

  final CartStatus status;
  final CartData cart;
  final String? message;
}
