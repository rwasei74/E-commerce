import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/wishlist_repository.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(this._repository) : super(const WishlistState());
  final WishlistRepository _repository;

  Future<void> load() async {
    final cached = await _repository.getCachedWishlist();
    if (cached != null) {
      emit(WishlistState(status: WishlistStatus.success, products: cached));
    }
    emit(
      WishlistState(status: WishlistStatus.loading, products: state.products),
    );
    try {
      final products = await _repository.getWishlist();
      emit(WishlistState(status: WishlistStatus.success, products: products));
    } catch (error) {
      emit(
        WishlistState(
          status: WishlistStatus.failure,
          products: state.products,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> toggle(String productId) async {
    emit(
      WishlistState(status: WishlistStatus.loading, products: state.products),
    );
    try {
      if (state.contains(productId)) {
        await _repository.remove(productId);
      } else {
        await _repository.add(productId);
      }
      final products = await _repository.getWishlist();
      emit(WishlistState(status: WishlistStatus.success, products: products));
    } catch (error) {
      emit(
        WishlistState(
          status: WishlistStatus.failure,
          products: state.products,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> remove(String productId) async {
    emit(
      WishlistState(status: WishlistStatus.loading, products: state.products),
    );
    try {
      await _repository.remove(productId);
      final products = await _repository.getWishlist();
      emit(WishlistState(status: WishlistStatus.success, products: products));
    } catch (error) {
      emit(
        WishlistState(
          status: WishlistStatus.failure,
          products: state.products,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
