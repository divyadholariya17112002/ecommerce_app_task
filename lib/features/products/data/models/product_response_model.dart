import 'product_model.dart';

class ProductResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductResponseModel(
      products: (json['products'] as List)
          .map(
            (e) => ProductModel.fromJson(e),
      )
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}