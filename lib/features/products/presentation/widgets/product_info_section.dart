import 'package:fairway/core/constants/app_constants.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            '${AppConstants.currency}${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Chip(label: Text(product.category.toUpperCase())),
          const SizedBox(height: 24),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (product.stock > 0)
                  _DetailTile(
                    label: 'Stock',
                    value: '${product.stock} items available',
                  ),
                if (product.weight > 0)
                  _DetailTile(label: 'Weight', value: '${product.weight} kg'),
                if (product.warrantyInformation.isNotEmpty)
                  _DetailTile(
                    label: 'Warranty',
                    value: product.warrantyInformation,
                  ),
                if (product.shippingInformation.isNotEmpty)
                  _DetailTile(
                    label: 'Shipping',
                    value: product.shippingInformation,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;

  const _DetailTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160, // Fixed width ensures all values align perfectly
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
