import 'package:fairway/core/di/injection.dart';
import 'package:fairway/core/routing/router.dart';
import 'package:fairway/core/theme/app_theme.dart';
import 'package:fairway/features/create_product/presentation/cubit/create_product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:fairway/features/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpDependencies();
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
        BlocProvider(create: (_) => getIt<ProductDetailsCubit>()), // change
        BlocProvider(create: (_) => getIt<CreateProductCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Fairway',
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
