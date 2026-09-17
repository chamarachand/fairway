import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ProductDetailState {}

class ProductDetailsInitial extends ProductDetailState {}

class ProductDetailsLoading extends ProductDetailState {}

class ProductDetailsLoaded extends ProductDetailState {
  final Product product;
  final List<Product> similarProducts;
  final bool isSimilarProductsLoading;
  final bool isDeleting;

  ProductDetailsLoaded({
    required this.product,
    this.similarProducts = const [],
    this.isSimilarProductsLoading = false,
    this.isDeleting = false,
  });

  ProductDetailsLoaded copyWith({
    Product? product,
    List<Product>? similarProducts,
    bool? isSimilarProductsLoading,
    bool? isDeleting,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      similarProducts: similarProducts ?? this.similarProducts,
      isSimilarProductsLoading:
          isSimilarProductsLoading ?? this.isSimilarProductsLoading,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError({required this.message});
}
