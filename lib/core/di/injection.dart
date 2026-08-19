import 'package:hive/hive.dart';

import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/models/product_hive_model.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';

import '../../features/wishlist/data/datasources/wishlist_local_datasource.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/usecases/add_to_wishlist.dart';
import '../../features/wishlist/domain/usecases/get_wishlist.dart';
import '../../features/wishlist/domain/usecases/remove_from_wishlist.dart';
import '../../features/wishlist/presentation/bloc/wishlist_bloc.dart';

import '../network/dio_client.dart';

class Injection {
  static ProductBloc createProductBloc() {
    final dioClient = DioClient();

    final remoteDataSource =
    ProductRemoteDataSource(dioClient);

    final productsBox =
    Hive.box<ProductHiveModel>('products');

    final localDataSource =
    ProductLocalDataSource(productsBox);

    final repository =
    ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    return ProductBloc(
      getProducts: GetProducts(repository),
      searchProducts: SearchProducts(repository),
    );
  }

  static WishlistBloc createWishlistBloc() {
    final wishlistBox =
    Hive.box<ProductHiveModel>('wishlist');

    final localDataSource =
    WishlistLocalDataSource(wishlistBox);

    final repository =
    WishlistRepositoryImpl(
      localDataSource,
    );

    return WishlistBloc(
      getWishlist: GetWishlist(repository),
      addToWishlist: AddToWishlist(repository),
      removeFromWishlist: RemoveFromWishlist(repository),
    );
  }
}