import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_hive_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );

      // Cache only the first page.
      // This avoids clearing the cache every time
      // pagination loads another page.
      if (skip == 0) {
        final hiveProducts = response.products
            .map(
          ProductHiveModel.fromEntity,
        )
            .toList();

        await localDataSource.cacheProducts(
          hiveProducts,
        );
      }

      return response.products;
    } catch (e) {
      // Use cached data only for the first page.
      if (skip == 0) {
        final cachedProducts =
        localDataSource.getCachedProducts();

        if (cachedProducts.isNotEmpty) {
          return cachedProducts
              .map((product) => product.toEntity())
              .toList();
        }
      }

      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    try {
      final response =
      await remoteDataSource.searchProducts(
        query: query,
        limit: limit,
        skip: skip,
      );

      return response.products;
    } catch (e) {
      rethrow;
    }
  }
}