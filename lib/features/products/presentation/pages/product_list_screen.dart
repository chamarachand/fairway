import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_state.dart';
import 'package:fairway/features/products/presentation/widgets/category_list.dart';
import 'package:fairway/features/products/presentation/widgets/product_card.dart';
import 'package:fairway/features/products/presentation/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategories();
    context.read<ProductCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    print('building again');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products", style: TextStyle(fontWeight: .bold)),
      ),
      body: Column(
        children: [
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
                print('State is $state');
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

                  return _ProductsGridView(displayProducts: state.products);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
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

class _ProductsGridView extends StatelessWidget {
  final List<Product> displayProducts;

  const _ProductsGridView({required this.displayProducts});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          childAspectRatio: 0.63,
        ),

        itemCount: displayProducts.length,
        itemBuilder: (context, index) {
          final product = displayProducts[index];

          return ProductCard(product: product, onTap: () {});
        },
      ),
    );
  }
}
