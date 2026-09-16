import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fairway/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

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
      );

      emit(
        ProductsLoaded(
          products: products,
          searchQuery: targetQuery,
          priceSort: targerSortOption,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(message: e.message));
    } catch (e) {
      emit(ProductsError(message: 'Something went wrong. Please try again'));
    }
  }
}
