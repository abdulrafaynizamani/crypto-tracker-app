import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit()
    : super(
        Hive.box('settingsBox').get('isDark', defaultValue: false)
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  void toggleTheme() {
    final box = Hive.box('settingsBox');

    if (state == ThemeMode.light) {
      box.put('isDark', true);
      emit(ThemeMode.dark);
    } else {
      box.put('isDark', false);
      emit(ThemeMode.light);
    }
  }
}
