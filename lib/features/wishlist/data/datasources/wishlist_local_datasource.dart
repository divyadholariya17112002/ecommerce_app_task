import 'package:hive/hive.dart';

import '../../../products/data/models/product_hive_model.dart';

class WishlistLocalDataSource {
  final Box<ProductHiveModel> box;

  WishlistLocalDataSource(this.box);

  List<ProductHiveModel> getWishlist() {
    return box.values.toList();
  }

  Future<void> addToWishlist(
      ProductHiveModel product,
      ) async {
    await box.put(
      product.id,
      product,
    );
  }

  Future<void> removeFromWishlist(
      int productId,
      ) async {
    await box.delete(productId);
  }

  bool isFavorite(int productId) {
    return box.containsKey(productId);
  }
}