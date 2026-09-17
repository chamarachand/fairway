import 'package:fairway/core/widgets/theme_toggle_button.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_state.dart';
import 'package:fairway/features/products/presentation/widgets/category_list.dart';
import 'package:fairway/features/products/presentation/widgets/offline_banner.dart';
import 'package:fairway/features/products/presentation/widgets/product_card.dart';
import 'package:fairway/features/products/presentation/widgets/search_box.dart';
import 'package:fairway/features/products/presentation/widgets/sort_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products", style: TextStyle(fontWeight: .bold)),
        actions: const [SortPopupMenu(), ThemeToggleButton()],
      ),
      body: Column(
        children: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoaded && state.isOffline) {
                return const OfflineBanner();
              }
              return const SizedBox.shrink();
            },
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const SearchBox(),
            ),
          ),
          const CategoryList(),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductsError) {
                  return _ProductErrorView(
                    msg: state.message,
                    onRetry: () => context.read<ProductCubit>().getProducts(),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return _ProductEmptyView(
                      isSearchActive: state.searchQuery.isNotEmpty,
                    );
                  }

                  return _ProductsGridView(
                    displayProducts: state.products,
                    isLoadingMore: state.isLoadingMore,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push<String>('create-product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductEmptyView extends StatelessWidget {
  final bool isSearchActive;

  const _ProductEmptyView({required this.isSearchActive});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearchActive ? Icons.search_off : Icons.inventory_2_outlined,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              isSearchActive
                  ? "No products match your search"
                  : "No products available",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductErrorView extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;

  const _ProductErrorView({required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: 60,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsGridView extends StatefulWidget {
  final List<Product> displayProducts;
  final bool isLoadingMore;

  const _ProductsGridView({
    required this.displayProducts,
    required this.isLoadingMore,
  });

  @override
  State<_ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<_ProductsGridView> {
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
                return ProductCard(
                  product: product,
                  onTap: () async {
                    final deletedId = await context.push<String>(
                      '/product/${product.id}',
                      extra: product,
                    );

                    if (deletedId != null && context.mounted) {
                      context.read<ProductCubit>().removeProduct(deletedId);
                    }
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
