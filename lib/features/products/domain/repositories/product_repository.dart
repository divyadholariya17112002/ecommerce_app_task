import 'package:ecommerce_app_task/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    required int limit,
    required int skip,
  });

  Future<List<Product>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  });
}