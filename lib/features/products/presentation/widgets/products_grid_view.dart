import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductsGridView extends StatefulWidget {
  final List<Product> displayProducts;
  final Set<int> favouriteIds;
  final bool isLoadingMore;

  const ProductsGridView({
    super.key,
    required this.displayProducts,
    required this.favouriteIds,
    required this.isLoadingMore,
  });

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProductCubit>().refreshProducts();
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.63,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = widget.displayProducts[index];
                final isFavourite = widget.favouriteIds.contains(product.id);

                return ProductCard(
                  product: product,
                  onTap: () {
                    context.push<String>(
                      '/product/${product.id}',
                      extra: product,
                    );
                  },
                  isFavourite: isFavourite,
                  onFavouriteToggle: () {
                    context.read<ProductCubit>().toggleFavourite(product.id);
                  },
                );
              }, childCount: widget.displayProducts.length),
            ),
          ),
          if (widget.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
