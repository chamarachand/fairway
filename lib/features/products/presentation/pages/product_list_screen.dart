import 'package:fairway/core/widgets/theme_toggle_button.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_state.dart';
import 'package:fairway/features/products/presentation/widgets/category_list.dart';
import 'package:fairway/features/products/presentation/widgets/offline_banner.dart';
import 'package:fairway/features/products/presentation/widgets/product_empty_view.dart';
import 'package:fairway/features/products/presentation/widgets/product_error_view.dart';
import 'package:fairway/features/products/presentation/widgets/products_grid_view.dart';
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
                  return ProductErrorView(
                    msg: state.message,
                    onRetry: () => context.read<ProductCubit>().getProducts(),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return ProductEmptyView(
                      isSearchActive: state.searchQuery.isNotEmpty,
                    );
                  }

                  return ProductsGridView(
                    displayProducts: state.products,
                    favouriteIds: state.favouriteIds,
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
