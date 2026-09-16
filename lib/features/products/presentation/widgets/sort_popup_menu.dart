import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/category_state.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortPopupMenu extends StatelessWidget {
  const SortPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final currentSort = state is ProductsLoaded
            ? state.priceSort
            : PriceSort.none;

        return PopupMenuButton<PriceSort>(
          icon: const Icon(Icons.sort),
          initialValue: currentSort,
          onSelected: (PriceSort newOrder) {
            final categoryState = context.read<CategoryCubit>().state;

            final currentCategory = (categoryState is CategoryLoaded)
                ? categoryState.selectedCategory
                : null;

            print('current category: $currentCategory');

            context.read<ProductCubit>().sortByPrice(
              newOrder,
              category: currentCategory,
            );
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: PriceSort.none, child: Text('Default')),
            const PopupMenuItem(
              value: PriceSort.lowToHigh,
              child: Text('Price: Low to High'),
            ),
            const PopupMenuItem(
              value: PriceSort.highToLow,
              child: Text('Price: High to Low'),
            ),
          ],
        );
      },
    );
  }
}
