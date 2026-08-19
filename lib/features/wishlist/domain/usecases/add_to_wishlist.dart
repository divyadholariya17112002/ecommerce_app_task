import '../../../products/domain/entities/product.dart';
import '../repositories/wishlist_repository.dart';

class AddToWishlist {
  final WishlistRepository repository;

  AddToWishlist(this.repository);

  Future<void> call(Product product) {
    return repository.addToWishlist(product);
  }
}