import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ProductDetailState {}

class ProductDetailsInitial extends ProductDetailState {}

class ProductDetailsLoading extends ProductDetailState {}

class ProductDetailsLoaded extends ProductDetailState {
  final Product product;
  final bool isSimilarProductsLoading;
  final List<Product> similarProducts;

  ProductDetailsLoaded({
    required this.product,
    this.isSimilarProductsLoading = false,
    this.similarProducts = const [],
  });
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError({required this.message});
}
