import 'package:flutter/material.dart';

@immutable
sealed class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;

  CategoryLoaded({required this.categories});
}
