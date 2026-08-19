import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';

class WishlistState extends Equatable {
  final List<Product> products;

  const WishlistState({
    this.products = const [],
  });

  WishlistState copyWith({
    List<Product>? products,
  }) {
    return WishlistState(
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [products];
}