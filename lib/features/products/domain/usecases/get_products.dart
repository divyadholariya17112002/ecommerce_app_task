import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call({
    required int limit,
    required int skip,
  }) {
    return repository.getProducts(
      limit: limit,
      skip: skip,
    );
  }
}