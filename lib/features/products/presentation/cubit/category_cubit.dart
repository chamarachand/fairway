import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:fairway/features/products/presentation/cubit/category_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final ProductRepository repository;

  CategoryCubit({required this.repository}) : super(CategoryInitial()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await repository.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      debugPrint('fetchCategories error: $e');
    }
  }

  void changeCategory(String? category) {
    if (state is CategoryLoaded) {
      final current = state as CategoryLoaded;
      emit(CategoryLoaded(categories: current.categories));
    }
  }
}
