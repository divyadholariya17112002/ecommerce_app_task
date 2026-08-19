import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  loadingMore,
  failure,
  empty,
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> products;
  final String errorMessage;
  final bool hasMore;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.hasMore = true,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? errorMessage,
    bool? hasMore,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    errorMessage,
    hasMore,
  ];
}