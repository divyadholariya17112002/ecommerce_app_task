import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_to_wishlist.dart';
import '../../domain/usecases/get_wishlist.dart';
import '../../domain/usecases/remove_from_wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc
    extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;

  WishlistBloc({
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  }) : super(const WishlistState()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  void _onLoadWishlist(
      LoadWishlist event,
      Emitter<WishlistState> emit,
      ) {
    emit(
      state.copyWith(
        products: getWishlist(),
      ),
    );
  }

  Future<void> _onToggleWishlist(
      ToggleWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    final isFavorite = state.products.any(
          (product) => product.id == event.product.id,
    );

    if (isFavorite) {
      await removeFromWishlist(event.product.id);
    } else {
      await addToWishlist(event.product);
    }

    emit(
      state.copyWith(
        products: getWishlist(),
      ),
    );
  }
}