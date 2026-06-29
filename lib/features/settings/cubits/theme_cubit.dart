import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/helper/shared_pref_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await SharedPrefHelper.getBool('is_dark_mode');
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme(bool isDark) async {
    await SharedPrefHelper.setData('is_dark_mode', isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
