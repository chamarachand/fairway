import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final String searchQuery;
  final PriceSort priceSort;
  final bool isLast;
  final bool isLoadingMore;
  final bool isOffline;

  ProductsLoaded({
    required this.products,
    this.searchQuery = '',
    this.priceSort = PriceSort.none,
    this.isLast = false,
    this.isLoadingMore = false,
    this.isOffline = false,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    String? searchQuery,
    PriceSort? priceSort,
    bool? isLast,
    bool? isLoadingMore,
    bool? isOffline,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      priceSort: priceSort ?? this.priceSort,
      isLast: isLast ?? this.isLast,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class ProductsError extends ProductState {
  final String message;

  ProductsError({required this.message});
}
