import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';

import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart';
import '../../../wishlist/presentation/bloc/wishlist_state.dart';

import 'product_details_page.dart';
import '../../../wishlist/presentation/pages/wishlist_page.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ScrollController _scrollController =
  ScrollController();

  final TextEditingController _searchController =
  TextEditingController();

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadProducts());

    _scrollController.addListener(_onScroll);
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 300) {
  //     context.read<ProductBloc>().add(
  //       LoadMoreProducts(),
  //     );
  //   }
  // }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<ProductBloc>().add(
        LoadMoreProducts(),
      );
    }
  }
  Future<void> _onRefresh() async {
    context.read<ProductBloc>().add(
      RefreshProducts(),
    );

    await context.read<ProductBloc>().stream.firstWhere(
          (state) =>
      state.status != ProductStatus.loading,
    );
  }
  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WishlistPage(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),


          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return IconButton(
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: Icon(
                  isDark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                LogoutRequested(),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state.status == ProductStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == ProductStatus.failure) {
                  return _buildError(state.errorMessage);
                }

                if (state.status == ProductStatus.empty) {
                  return const Center(
                    child: Text('No products found'),
                  );
                }

                return RefreshIndicator(
                  // onRefresh: () async {
                  //   context.read<ProductBloc>().add(
                  //     RefreshProducts(),
                  //   );
                  // },
                  onRefresh: _onRefresh,
                  child: _buildProductGrid(state),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _searchDebounce?.cancel();

          _searchDebounce = Timer(
            const Duration(milliseconds: 500),
                () {
              context.read<ProductBloc>().add(
                SearchProduct(value.trim()),
              );
            },
          );
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              _searchController.clear();

              context.read<ProductBloc>().add(
                SearchProduct(''),
              );
            },
            icon: const Icon(Icons.clear),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductState state) {
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width >= 1200
        ? 5
        : width >= 900
        ? 4
        : width >= 600
        ? 3
        : 2;

    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: state.products.length +
          (state.status == ProductStatus.loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final product = state.products[index];

        return BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, wishlistState) {
            final isFavorite = wishlistState.products.any(
                  (item) => item.id == product.id,
            );

            return ProductCard(
              product: product,
              isFavorite: isFavorite,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsPage(
                      product: product,
                    ),
                  ),
                );
              },

              onWishlistTap: () {
                context.read<WishlistBloc>().add(
                  ToggleWishlist(product),
                );
              },
            );
          },
        );
        },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                LoadProducts(),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }


}