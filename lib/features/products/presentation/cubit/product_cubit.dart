import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fairway/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;
  static const int _limit = 20;

  ProductCubit({required this.repository}) : super(ProductInitial());

  String getCurrentQuery() {
    return state is ProductsLoaded ? (state as ProductsLoaded).searchQuery : '';
  }

  PriceSort getCurrentSortOption() {
    return state is ProductsLoaded
        ? (state as ProductsLoaded).priceSort
        : PriceSort.none;
  }

  Future<void> getProducts() async {
    await _loadProducts(clearQuery: true);
  }

  Future<void> refreshProducts(String? category) async {
    await _loadProducts(category: category);
  }

  Future<void> searchProducts(String query) async {
    await _loadProducts(query: query, clearCategory: true);
  }

  Future<void> filterByCategory(String? category) async {
    await _loadProducts(category: category, clearQuery: true);
  }

  Future<void> sortByPrice(PriceSort sort, {String? category}) async {
    await _loadProducts(sortOption: sort, category: category);
  }

  Future<void> _loadProducts({
    String? category,
    String? query,
    PriceSort? sortOption,
    bool clearQuery = false,
    bool clearCategory = false,
  }) async {
    final targetCategory = clearCategory ? null : category;
    final targetQuery = clearQuery ? '' : (query ?? getCurrentQuery());
    final targerSortOption = sortOption ?? getCurrentSortOption();

    emit(ProductsLoading());

    try {
      final products = await repository.fetchProducts(
        category: targetCategory,
        query: targetQuery,
        sortOrder: targerSortOption,
        limit: _limit,
        skip: 0,
      );

      emit(
        ProductsLoaded(
          products: products,
          searchQuery: targetQuery,
          priceSort: targerSortOption,
          isLast: products.length < _limit,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> loadMoreProducts({String? category}) async {
    if (state is! ProductsLoaded) return;
    final currentState = state as ProductsLoaded;

    if (currentState.isLast || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final newProducts = await repository.fetchProducts(
        category: category,
        query: currentState.searchQuery,
        sortOrder: currentState.priceSort,
        limit: _limit,
        skip: currentState.products.length,
      );

      if (newProducts.isEmpty) {
        emit(currentState.copyWith(isLast: true, isLoadingMore: false));
      } else {
        emit(
          currentState.copyWith(
            products: List.of(currentState.products)..addAll(newProducts),
            isLast: newProducts.length < _limit,
            isLoadingMore: false,
          ),
        );
      }
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  void removeProduct(String productId) {
    if (state is! ProductsLoaded) return;
    final currentState = state as ProductsLoaded;

    final newProducts = currentState.products
        .where((product) => product.id.toString() != productId)
        .toList();

    emit(currentState.copyWith(products: newProducts));
  }
}
