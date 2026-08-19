import 'package:hive/hive.dart';

import '../models/product_hive_model.dart';

class ProductLocalDataSource {
  final Box<ProductHiveModel> box;

  ProductLocalDataSource(this.box);

  Future<void> cacheProducts(
      List<ProductHiveModel> products,
      ) async {
    await box.clear();

    await box.addAll(products);
  }

  List<ProductHiveModel> getCachedProducts() {
    return box.values.toList();
  }

  Future<void> clearCache() async {
    await box.clear();
  }
}