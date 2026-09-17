import 'package:fairway/core/di/injection.dart';
import 'package:fairway/core/routing/router.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setUpDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CategoryCubit>()),
        BlocProvider(create: (_) => getIt<ProductCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Fairway',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
