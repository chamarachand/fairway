import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_state.dart';
import 'package:fairway/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SimilarProductsListView extends StatelessWidget {
  const SimilarProductsListView({super.key});

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
            if (similarProducts.isEmpty) {
              return const SizedBox.shrink();
            }

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
                    scrollDirection: Axis.horizontal,
                    itemCount: similarProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final product = similarProducts[index];
                      return SizedBox(
                        width: 180,
                        child: ProductCard(
                          product: product,
                          onTap: () async {
                            await context.push<String>(
                              '/product/${product.id}',
                              extra: product,
                            );
                          },
                        ),
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
