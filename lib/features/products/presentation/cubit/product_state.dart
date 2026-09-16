import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  ProductsLoaded({required this.products});
}

class ProductsError extends ProductState {
  final String message;

  ProductsError({required this.message});
}

class ProductsEmpty extends ProductState {}
