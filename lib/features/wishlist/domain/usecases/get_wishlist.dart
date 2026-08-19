import '../../../products/domain/entities/product.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlist {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  List<Product> call() {
    return repository.getWishlist();
  }
}