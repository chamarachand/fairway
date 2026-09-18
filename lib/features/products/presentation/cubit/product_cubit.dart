import 'package:fairway/core/constants/app_constants.dart';
import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fairway/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;
  static const int _limit = AppConstants.paginationLimit;

  ProductCubit({required this.repository}) : super(ProductInitial());

  String getCurrentQuery() {
    return state is ProductsLoaded ? (state as ProductsLoaded).searchQuery : '';
  }

  PriceSort getCurrentSortOption() {
    return state is ProductsLoaded
        ? (state as ProductsLoaded).priceSort
        : PriceSort.none;
  }

  String? getCurrentCategory() {
    if (state is ProductsLoaded) {
      return (state as ProductsLoaded).category;
    }
    return null;
  }

  Future<void> getProducts() async {
    await _loadProducts(clearQuery: true);
  }

  Future<void> refreshProducts() async {
    await _loadProducts(category: getCurrentCategory());
  }

  Future<void> searchProducts(String query) async {
    await _loadProducts(query: query, clearCategory: true);
  }

  Future<void> filterByCategory(String? category) async {
    if (category == 'ALL') {
      await _loadProducts(clearCategory: true, clearQuery: true);
    } else {
      await _loadProducts(category: category, clearQuery: true);
    }
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
    final targetCategory = clearCategory
        ? null
        : (category ?? getCurrentCategory());
    final targetQuery = clearQuery ? '' : (query ?? getCurrentQuery());
    final targerSortOption = sortOption ?? getCurrentSortOption();

    emit(ProductsLoading(category: targetCategory));

    try {
      debugPrint('category: $category');
      final (:products, :isOffline) = await repository.fetchProducts(
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
          category: isOffline ? null : targetCategory,
          priceSort: targerSortOption,
          isLast: products.length < _limit,
          isOffline: isOffline,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message, category: targetCategory));
    } catch (e) {
      emit(
        ProductsError(
          message: 'Something went wrong. Please try again',
          category: category,
        ),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    if (state is! ProductsLoaded) return;
    final currentState = state as ProductsLoaded;

    if (currentState.isLast || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final (products: newProducts, :isOffline) = await repository
          .fetchProducts(
            category: currentState.category,
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

  void addProduct(Product product, {required String category}) async {
    await _loadProducts(category: category);

    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      final updatedList = List<Product>.from(currentState.products);

      final targetIndex = _getSortedIndex(
        updatedList,
        product,
        currentState.priceSort,
      );
      updatedList.insert(targetIndex, product);
      emit(currentState.copyWith(products: updatedList));
    }
  }

  int _getSortedIndex(
    List<Product> products,
    Product newProduct,
    PriceSort sortOption,
  ) {
    switch (sortOption) {
      case PriceSort.lowToHigh:
        final index = products.indexWhere((p) => p.price > newProduct.price);
        return index == -1 ? products.length : index;

      case PriceSort.highToLow:
        final index = products.indexWhere((p) => p.price < newProduct.price);
        return index == -1 ? products.length : index;

      case PriceSort.none:
        return 0;
    }
  }
}
