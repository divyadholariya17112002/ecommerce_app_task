import '../repositories/wishlist_repository.dart';

class RemoveFromWishlist {
  final WishlistRepository repository;

  RemoveFromWishlist(this.repository);

  Future<void> call(int productId) {
    return repository.removeFromWishlist(
      productId,
    );
  }
}