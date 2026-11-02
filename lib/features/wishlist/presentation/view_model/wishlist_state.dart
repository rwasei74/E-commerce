import '../../../products/data/models/product.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState {
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.products = const [],
    this.message,
  });
  final WishlistStatus status;
  final List<Product> products;
  final String? message;

  bool contains(String productId) =>
      products.any((product) => product.id == productId);
}
