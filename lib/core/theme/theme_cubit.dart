import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<bool> {
  static const String boxName = 'settings';
  static const String darkModeKey = 'darkMode';

  late final Box _box;

  ThemeCubit() : super(false) {
    _initialize();
  }

  Future<void> _initialize() async {
    _box = await Hive.openBox(boxName);

    final isDark =
    _box.get(darkModeKey, defaultValue: false);

    emit(isDark);
  }

  Future<void> toggleTheme() async {
    final newValue = !state;

    await _box.put(
      darkModeKey,
      newValue,
    );

    emit(newValue);
  }
}