import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/category_state.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          final categories = categoryState is CategoryLoaded
              ? categoryState.categories
              : const <String>[];

          return BlocBuilder<ProductCubit, ProductState>(
            builder: (context, productState) {
              final selectedCategory = productState.category;

              if (categoryState is CategoryLoading) {
                return const SizedBox();
              }

              return SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final categoryName = isAll ? 'All' : categories[index - 1];
                    final isSelected = isAll
                        ? selectedCategory == null
                        : selectedCategory == categoryName;

                    return FilterChip(
                      label: Text(categoryName),
                      selected: isSelected,
                      onSelected: (_) {
                        context.read<ProductCubit>().filterByCategory(
                          isAll ? 'ALL' : categoryName,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
