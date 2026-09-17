import 'package:fairway/features/products/data/models/product.dart';
import 'package:fairway/features/products/presentation/pages/product_details_page.dart';
import 'package:fairway/features/products/presentation/pages/product_list_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProductListScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final product = state.extra as Product?;

        return ProductDetailsPage(productId: id, product: product);
      },
    ),
  ],
);
