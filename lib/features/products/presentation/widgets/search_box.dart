import 'dart:async';

import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/category_state.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductCubit>().getProducts();
    setState(() {});
  }

  void _clearSearchText() {
    _searchController.clear();
    setState(() {});
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final trimmed = value.trim();

      if (trimmed.isNotEmpty) {
        context.read<CategoryCubit>().changeCategory(null);
        context.read<ProductCubit>().searchProducts(value);
      } else {
        context.read<ProductCubit>().getProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(12);

    return BlocListener<CategoryCubit, CategoryState>(
      listenWhen: (previous, current) {
        if (current is CategoryLoaded) {
          return current.selectedCategory != null;
        }
        return false;
      },
      listener: (context, state) => _clearSearchText(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search Products...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.clear),
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: colorScheme.primary, width: 1),
            ),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }
}
