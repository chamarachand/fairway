import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fairway/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(ProductInitial());

  Future<void> getProducts() async {
    final priceSort = (state is ProductsLoaded)
        ? (state as ProductsLoaded).priceSort
        : PriceSort.none;

    final currentQuery = (state is ProductsLoaded)
        ? (state as ProductsLoaded).searchQuery
        : '';

    emit(ProductsLoading());

    try {
      final products = await repository.fetchProducts(
        sortOrder: priceSort,
        query: currentQuery,
      );
      emit(
        ProductsLoaded(
          products: products,
          searchQuery: currentQuery,
          priceSort: priceSort,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> searchProducts(String query) async {
    final priceSort = (state is ProductsLoaded)
        ? (state as ProductsLoaded).priceSort
        : PriceSort.none;

    emit(ProductsLoading());

    try {
      final products = await repository.searchProducts(
        query,
        sortOrder: priceSort,
      );

      emit(
        ProductsLoaded(
          products: products,
          searchQuery: query,
          priceSort: priceSort,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> filterByCategory(String? category) async {
    final priceSort = (state is ProductsLoaded)
        ? (state as ProductsLoaded).priceSort
        : PriceSort.none;

    emit(ProductsLoading());

    try {
      final products = (category == null || category.isEmpty)
          ? await repository.fetchProducts(sortOrder: priceSort)
          : await repository.fetchProductsByCategory(
              category,
              sortOrder: priceSort,
            );

      emit(
        ProductsLoaded(
          products: products,
          searchQuery: '',
          priceSort: priceSort,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> sortByPrice(PriceSort priceSort, {String? category}) async {
    final query = (state is ProductsLoaded)
        ? (state as ProductsLoaded).searchQuery
        : '';

    emit(ProductsLoading());

    try {
      final products = (category == null)
          ? (query.isEmpty)
                ? await repository.fetchProducts(sortOrder: priceSort)
                : await repository.searchProducts(query, sortOrder: priceSort)
          : await repository.fetchProductsByCategory(
              category,
              sortOrder: priceSort,
            );

      emit(
        ProductsLoaded(
          products: products,
          searchQuery: query,
          priceSort: priceSort,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }
}
