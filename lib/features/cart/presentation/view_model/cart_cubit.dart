import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_models.dart';
import '../../data/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(const CartState());
  final CartRepository _repository;

  Future<void> load() async {
    final cached = await _repository.getCachedCart();
    if (cached != null) {
      emit(CartState(status: CartStatus.success, cart: cached));
    }
    await _run(_repository.getCart, keepCacheOnError: cached != null);
  }

  Future<void> add(String id) => _run(() => _repository.addProduct(id));
  Future<void> changeQuantity(String id, int count) => _run(
    () => count < 1
        ? _repository.removeProduct(id)
        : _repository.updateCount(id, count),
  );
  Future<void> remove(String id) => _run(() => _repository.removeProduct(id));
  Future<void> checkout({
    required String details,
    required String phone,
    required String city,
  }) async {
    if (state.cart.id.isEmpty) {
      return;
    }
    emit(CartState(status: CartStatus.loading, cart: state.cart));
    try {
      await _repository.checkout(
        cartId: state.cart.id,
        details: details,
        phone: phone,
        city: city,
      );
      emit(const CartState(status: CartStatus.success));
    } catch (error) {
      emit(
        CartState(
          status: CartStatus.failure,
          cart: state.cart,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _run(
    Future<CartData> Function() request, {
    bool keepCacheOnError = false,
  }) async {
    emit(CartState(status: CartStatus.loading, cart: state.cart));
    try {
      emit(CartState(status: CartStatus.success, cart: await request()));
    } catch (error) {
      emit(
        CartState(
          status: keepCacheOnError ? CartStatus.success : CartStatus.failure,
          cart: state.cart,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
