import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}

class SearchProduct extends ProductEvent {
  final String query;

  const SearchProduct(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshProducts extends ProductEvent {}