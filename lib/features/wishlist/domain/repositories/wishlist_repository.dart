import '../../../products/domain/entities/product.dart';

abstract class WishlistRepository {
  List<Product> getWishlist();

  Future<void> addToWishlist(Product product);

  Future<void> removeFromWishlist(int productId);

  bool isFavorite(int productId);
}