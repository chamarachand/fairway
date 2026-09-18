import 'package:fairway/core/utils/snack_bar_helper.dart';
import 'package:fairway/core/widgets/theme_toggle_button.dart';
import 'package:fairway/features/create_product/presentation/cubit/create_product_cubit.dart';
import 'package:fairway/features/create_product/presentation/cubit/create_product_state.dart';
import 'package:fairway/features/create_product/presentation/widgets/custom_text_field.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/category_state.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String _selectedCondition = 'New';
  final List<String> _conditions = ['New', 'Like New', 'Used', 'Refurbished'];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    context.read<CreateProductCubit>().submitListing(
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      category: _selectedCategory!,
      description: _descriptionController.text.trim(),
      condition: _selectedCondition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Listing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: BlocConsumer<CreateProductCubit, CreateProductState>(
        listener: (context, state) {
          if (state is CreateProductSuccess) {
            final newProduct = state.product;
            final category = newProduct.category;
            context.read<CategoryCubit>().changeCategory(category);
            context.read<ProductCubit>().addProduct(
              newProduct,
              category: category,
            );
            SnackBarHelper.showSnackBar(
              context,
              'Listing created successfully!',
            );

            context.pushReplacement(
              '/product/${state.product.id}',
              extra: state.product,
            );
          } else if (state is CreateProductError) {
            SnackBarHelper.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is CreateProductLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Title
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Title *',
                        enabled: !isSubmitting,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Category
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          List<String> categories = [];
                          if (state is CategoryLoaded) {
                            categories = state.categories;
                          }

                          return DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            menuMaxHeight: 300,
                            decoration: InputDecoration(
                              labelText: 'Category *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: isSubmitting
                                ? null
                                : (val) {
                                    setState(() {
                                      _selectedCategory = val;
                                    });
                                  },
                            validator: (val) {
                              if (val == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Price
                      CustomTextField(
                        controller: _priceController,
                        labelText: 'Price (\$)*',
                        enabled: !isSubmitting,
                        prefixText: '\$ ',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Enter a price';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Condition
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCondition,
                        decoration: InputDecoration(
                          labelText: 'Condition *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: _conditions.map((cond) {
                          return DropdownMenuItem(
                            value: cond,
                            child: Text(cond),
                          );
                        }).toList(),
                        onChanged: isSubmitting
                            ? null
                            : (val) {
                                setState(() {
                                  _selectedCondition = val!;
                                });
                              },
                      ),
                      const SizedBox(height: 20),

                      // Description
                      CustomTextField(
                        controller: _descriptionController,
                        labelText: 'Description *',
                        enabled: !isSubmitting,
                        maxLines: 5,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Button
                      FilledButton.icon(
                        onPressed: isSubmitting ? null : _submitForm,
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(
                          isSubmitting ? 'Posting...' : 'Create Product',
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
