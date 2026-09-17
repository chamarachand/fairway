import 'package:fairway/core/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorageService localStorageService;

  ThemeCubit({required this.localStorageService})
    : super(
        localStorageService.getIsDarkMode() ? ThemeMode.dark : ThemeMode.light,
      );

  void toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;

    emit(nextMode);
    await localStorageService.saveIsDarkMode(nextMode == ThemeMode.dark);
  }
}
