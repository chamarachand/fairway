import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class CreateProductState {}

class CreateProductInitial extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {
  final Product product;
  CreateProductSuccess(this.product);
}

class CreateProductError extends CreateProductState {
  final String message;
  CreateProductError(this.message);
}
