import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../wishlist/presentation/bloc/wishlist_bloc.dart';
import '../../../wishlist/presentation/bloc/wishlist_event.dart';
import '../../../wishlist/presentation/bloc/wishlist_state.dart';
class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {
  int _selectedImageIndex = 0;


  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              final isFavorite = state.products.any(
                    (item) => item.id == widget.product.id,
              );

              return IconButton(
                onPressed: () {
                  context.read<WishlistBloc>().add(
                    ToggleWishlist(widget.product),
                  );
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
              );
            },
          ),        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(product),

            const SizedBox(height: 24),

            Text(
              product.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.brand,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            _buildRating(product),

            const SizedBox(height: 16),

            _buildPrice(product),

            const SizedBox(height: 16),

            _buildProductInfo(product),

            const SizedBox(height: 24),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                final isFavorite = state.products.any(
                      (item) => item.id == widget.product.id,
                );

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<WishlistBloc>().add(
                        ToggleWishlist(widget.product),
                      );
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite
                          ? 'Remove from Wishlist'
                          : 'Add to Wishlist',
                    ),
                  ),
                );
              },
            ),          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(Product product) {
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: images[_selectedImageIndex],
              fit: BoxFit.contain,
              placeholder: (_, _) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorWidget: (_, _, _) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected =
                  index == _selectedImageIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
                child: Container(
                  width: 70,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context)
                          .colorScheme
                          .primary
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRating(Product product) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        const SizedBox(width: 6),
        Text(
          product.rating.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(Product product) {
    return Row(
      children: [
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${product.discountPercentage.toStringAsFixed(0)}% OFF',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      children: [
        _infoRow(
          'Category',
          product.category,
        ),
        _infoRow(
          'Brand',
          product.brand,
        ),
        _infoRow(
          'Stock',
          product.stock.toString(),
        ),
      ],
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}