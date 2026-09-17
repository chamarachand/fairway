import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_state.dart';
import 'package:fairway/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final Product? product;
  const ProductDetailsPage({super.key, required this.productId, this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().loadDetails(
      id: widget.productId,
      product: widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              BlocBuilder<ProductDetailsCubit, ProductDetailState>(
                builder: (context, state) {
                  if (state is ProductDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductDetailsLoaded) {
                    final product = state.product;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isWideScreen = constraints.maxWidth > 600;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isWideScreen)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: _ProductImage(
                                      product: product,
                                      isWideScreen: isWideScreen,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    flex: 5,
                                    child: _ProductInfo(product: product),
                                  ),
                                ],
                              )
                            else ...[
                              _ProductImage(
                                product: product,
                                isWideScreen: false,
                              ),
                              const SizedBox(height: 24),
                              _ProductInfo(product: product),
                            ],
                          ],
                        );
                      },
                    );
                  }

                  if (state is ProductDetailError) {
                    return const Center(child: Text("Some error occured"));
                  }

                  return const SizedBox.shrink();
                },
              ),
              const _SimilarProdutsListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatefulWidget {
  final Product product;
  final bool isWideScreen;

  const _ProductImage({required this.product, required this.isWideScreen});

  @override
  State<_ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<_ProductImage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.thumbnail];

    return SizedBox(
      height: widget.isWideScreen ? 400 : 300,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.contain,
              );
            },
          ),
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentIndex + 1}/${images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            'LKR${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Chip(label: Text(product.category.toUpperCase())),
          const SizedBox(height: 24),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _SimilarProdutsListView extends StatelessWidget {
  const _SimilarProdutsListView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<ProductDetailsCubit, ProductDetailState, List<Product>>(
          selector: (state) {
            if (state is ProductDetailsLoaded) {
              return state.similarProducts;
            }
            return const [];
          },
          builder: (context, similarProducts) {
            return Column(
              children: [
                const SizedBox(height: 32),
                Text(
                  'Similar Products',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: .horizontal,
                    itemCount: similarProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final product = similarProducts[index];
                      return SizedBox(
                        width: 180,
                        child: ProductCard(product: product, onTap: () {}),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
