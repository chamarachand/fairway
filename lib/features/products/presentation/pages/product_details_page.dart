import 'package:fairway/core/utils/snack_bar_helper.dart';
import 'package:fairway/core/widgets/theme_toggle_button.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_state.dart';
import 'package:fairway/features/products/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:fairway/features/products/presentation/widgets/product_image_gallery.dart';
import 'package:fairway/features/products/presentation/widgets/product_info_section.dart';
import 'package:fairway/features/products/presentation/widgets/similar_products_list_view.dart';

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

  Future<void> _handleProductDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await context.read<ProductDetailsCubit>().deleteProduct();

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showSnackBar(context, 'Product deleted');
      Navigator.of(context).pop(widget.productId);
    } else {
      SnackBarHelper.showSnackBar(
        context,
        'Failed to delete listing. Please try again',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<ProductDetailsCubit, ProductDetailState>(
            builder: (context, state) {
              final isDeleting =
                  state is ProductDetailsLoaded && state.isDeleting;
              return IconButton(
                icon: isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete),
                onPressed: isDeleting ? null : _handleProductDelete,
              );
            },
          ),
          const ThemeToggleButton(),
        ],
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
                                    child: ProductImageGallery(
                                      key: const ValueKey(
                                        'product_images_widget',
                                      ),
                                      product: product,
                                      isWideScreen: isWideScreen,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    flex: 5,
                                    child: ProductInfoSection(product: product),
                                  ),
                                ],
                              )
                            else ...[
                              ProductImageGallery(
                                key: const ValueKey('product_images_widget'),
                                product: product,
                                isWideScreen: false,
                              ),
                              const SizedBox(height: 24),
                              ProductInfoSection(product: product),
                            ],
                          ],
                        );
                      },
                    );
                  }

                  if (state is ProductDetailError) {
                    return const Center(child: Text("Some error occurred"));
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SimilarProductsListView(),
            ],
          ),
        ),
      ),
    );
  }
}
