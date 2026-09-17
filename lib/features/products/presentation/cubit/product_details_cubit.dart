import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailState> {
  final ProductRepository repository;

  ProductDetailsCubit({required this.repository})
    : super(ProductDetailsInitial());

  Future<void> loadDetails({required String id, Product? product}) async {
    Product? currentProduct = product;
    // navigate from list view
    if (product != null) {
      emit(ProductDetailsLoaded(product: product));
    } else {
      // Deep-link
      emit(ProductDetailsLoading());
      try {
        currentProduct = await repository.getProductById(id);
        emit(
          ProductDetailsLoaded(
            product: currentProduct,
            isSimilarProductsLoading: true,
          ),
        );
      } catch (e) {
        emit(ProductDetailError(message: 'Failed to load listing details.'));
        return;
      }
    }

    // get similar items
    try {
      final similarProducts = await repository.fetchSimilarProducts(
        category: currentProduct!.category,
      );

      // remove current product
      similarProducts.removeWhere((product) => product.id.toString() == id);

      emit(
        ProductDetailsLoaded(
          product: currentProduct,
          similarProducts: similarProducts,
        ),
      );
    } catch (e) {
      debugPrint('loadDetails: $e');
      emit(ProductDetailsLoaded(product: currentProduct!));
    }
  }

  Future<bool> deleteProduct() async {
    final currentState = state;
    if (currentState is! ProductDetailsLoaded) return false;

    emit(currentState.copyWith(isDeleting: true));

    try {
      await repository.deleteProduct(currentState.product.id.toString());
      return true;
    } on AppException {
      emit(currentState.copyWith(isDeleting: false));
      return false;
    } catch (e) {
      emit(currentState.copyWith(isDeleting: false));
      return false;
    }
  }
}
