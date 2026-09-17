import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/create_product/data/repository/create_product_repository.dart';
import 'package:fairway/features/create_product/presentation/cubit/create_product_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final CreateProductRepository repository;

  CreateProductCubit({required this.repository})
    : super(CreateProductInitial());

  Future<void> submitListing({
    required String title,
    required double price,
    required String category,
    required String description,
    required String condition,
  }) async {
    emit(CreateProductLoading());

    try {
      final product = await repository.createProduct(
        title: title,
        price: price,
        category: category,
        description: description,
        condition: condition,
      );
      emit(CreateProductSuccess(product));
    } on AppException catch (e, stack) {
      print(e.message);
      print(stack);

      emit(CreateProductError(e.message));
    } catch (_) {
      emit(CreateProductError("Something went wrong. Please try again"));
    }
  }
}
