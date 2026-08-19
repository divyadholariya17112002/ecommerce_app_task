import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../../../core/error/app_exception.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;

  static const int pageSize = 10;

  int skip = 0;
  String currentQuery = '';

  ProductBloc({
    required this.getProducts,
    required this.searchProducts,
  }) : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<SearchProduct>(_onSearchProduct);
    on<RefreshProducts>(_onRefreshProducts);
  }

  String _getErrorMessage(Object error) {
    if (error is NetworkException) {
      return 'No internet connection.';
    }

    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }

    if (error is ServerException) {
      return error.message;
    }

    return 'Something went wrong. Please try again.';
  }
  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
      ),
    );

    try {
      skip = 0;

      final products = await getProducts(
        limit: pageSize,
        skip: skip,
      );

      if (products.isEmpty) {
        emit(
          state.copyWith(
            status: ProductStatus.empty,
            products: [],
            hasMore: false,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          hasMore: products.length == pageSize,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }


  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (!state.hasMore ||
        state.status == ProductStatus.loadingMore ||
        state.status == ProductStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: ProductStatus.loadingMore,
      ),
    );

    try {
      skip += pageSize;

      final products = currentQuery.isEmpty
          ? await getProducts(
        limit: pageSize,
        skip: skip,
      )
          : await searchProducts(
        query: currentQuery,
        limit: pageSize,
        skip: skip,
      );

      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: [
            ...state.products,
            ...products,
          ],
          hasMore: products.length == pageSize,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.success,
        ),
      );
    }
  }

  Future<void> _onSearchProduct(
      SearchProduct event,
      Emitter<ProductState> emit,
      ) async {
    currentQuery = event.query;
    skip = 0;

    if (event.query.trim().isEmpty) {
      add(LoadProducts());
      return;
    }

    emit(
      state.copyWith(
        status: ProductStatus.loading,
      ),
    );

    try {
      final products = await searchProducts(
        query: event.query,
        limit: pageSize,
        skip: 0,
      );

      emit(
        state.copyWith(
          status: products.isEmpty
              ? ProductStatus.empty
              : ProductStatus.success,
          products: products,
          hasMore: products.length == pageSize,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: 'Search failed',
        ),
      );
    }
  }

  Future<void> _onRefreshProducts(
      RefreshProducts event,
      Emitter<ProductState> emit,
      ) async {
    skip = 0;
    currentQuery = '';

    add(LoadProducts());
  }
}