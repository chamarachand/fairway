import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/category_state.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoaded) {
            return SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: .horizontal,
                itemCount: state.categories.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = (index == 0);
                  final categoryName = isAll
                      ? 'All'
                      : state.categories[index - 1];
                  final isSelected = isAll
                      ? state.selectedCategory == null
                      : state.selectedCategory == categoryName;

                  return FilterChip(
                    label: Text(categoryName),
                    selected: isSelected,
                    onSelected: (value) {
                      final selectedValue = isAll ? null : categoryName;

                      context.read<ProductCubit>().filterByCategory(
                        selectedValue,
                      );

                      context.read<CategoryCubit>().changeCategory(
                        selectedValue,
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox(height: 40);
        },
      ),
    );
  }
}
