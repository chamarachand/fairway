import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fairway/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(ProductInitial());

  Future<void> getProducts() async {
    emit(ProductsLoading());

    try {
      final products = await repository.fetchProducts();
      emit(ProductsLoaded(products: products, searchQuery: ''));
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(ProductsLoading());

    try {
      final products = await repository.searchProducts(query);

      emit(ProductsLoaded(products: products, searchQuery: query));
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> filterByCategory(String? category) async {
    emit(ProductsLoading());

    try {
      final products = (category == null || category.isEmpty)
          ? await repository.fetchProducts()
          : await repository.fetchProductsByCategory(category);

      emit(ProductsLoaded(products: products, searchQuery: ''));
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }
}
