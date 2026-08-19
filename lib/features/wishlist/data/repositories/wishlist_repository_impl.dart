import '../../../products/data/models/product_hive_model.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_datasource.dart';

class WishlistRepositoryImpl
    implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  List<Product> getWishlist() {
    return localDataSource
        .getWishlist()
        .map((product) => product.toEntity())
        .toList();
  }

  @override
  Future<void> addToWishlist(
      Product product,
      ) async {
    final hiveProduct =
    ProductHiveModel.fromEntity(product);

    await localDataSource.addToWishlist(
      hiveProduct,
    );
  }

  @override
  Future<void> removeFromWishlist(
      int productId,
      ) async {
    await localDataSource.removeFromWishlist(
      productId,
    );
  }

  @override
  bool isFavorite(int productId) {
    return localDataSource.isFavorite(
      productId,
    );
  }
}