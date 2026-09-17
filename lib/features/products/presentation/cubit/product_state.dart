import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProductState {
  final String? category;
  const ProductState({this.category});
}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {
  const ProductsLoading({super.category});
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final String searchQuery;
  final PriceSort priceSort;
  final bool isLast;
  final bool isLoadingMore;
  final bool isOffline;

  const ProductsLoaded({
    required this.products,
    this.searchQuery = '',
    this.priceSort = PriceSort.none,
    super.category,
    this.isLast = false,
    this.isLoadingMore = false,
    this.isOffline = false,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    String? searchQuery,
    PriceSort? priceSort,
    String? category,
    bool clearCategory = false,
    bool? isLast,
    bool? isLoadingMore,
    bool? isOffline,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      priceSort: priceSort ?? this.priceSort,
      category: clearCategory ? null : (category ?? this.category),
      isLast: isLast ?? this.isLast,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class ProductsError extends ProductState {
  final String message;

  const ProductsError({required this.message, super.category});
}
