import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairway/features/products/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  final Product product;
  final bool isWideScreen;

  const ProductImageGallery({
    super.key,
    required this.product,
    required this.isWideScreen,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.thumbnail];

    return SizedBox(
      height: widget.isWideScreen ? 400 : 300,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final imageUrl = images[index];

              if (imageUrl.isEmpty) {
                return const Center(
                  child: Icon(Icons.image_not_supported, size: 80),
                );
              } else {
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  fadeInDuration: Duration.zero,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.image_not_supported, size: 80),
                );
              }
            },
          ),
          if (images.any((img) => img.trim().isNotEmpty))
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentIndex + 1}/${images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
