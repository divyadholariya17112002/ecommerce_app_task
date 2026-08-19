import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  final ProductRepository repository;

  SearchProducts(this.repository);

  Future<List<Product>> call({
    required String query,
    required int limit,
    required int skip,
  }) {
    return repository.searchProducts(
      query: query,
      limit: limit,
      skip: skip,
    );
  }
}