import 'package:fairway/features/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final isDark = themeMode == ThemeMode.dark;

          return IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          );
        },
      ),
    );
  }
}
