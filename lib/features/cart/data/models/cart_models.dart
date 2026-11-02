import '../../../products/data/models/product.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.count,
    required this.product,
  });

  final String id;
  final int count;
  final Product product;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['_id'] as String? ?? '',
    count: json['count'] as int? ?? 1,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
  );
}

class CartData {
  const CartData({
    required this.id,
    required this.items,
    required this.totalPrice,
  });

  const CartData.empty() : id = '', items = const [], totalPrice = 0;

  final String id;
  final List<CartItem> items;
  final num totalPrice;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json['_id'] as String? ?? '',
    items: (json['products'] as List<dynamic>? ?? const [])
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList(),
    totalPrice: json['totalCartPrice'] as num? ?? 0,
  );
}
