import 'package:flutter/material.dart';

import '../models/family_module.dart';
import '../services/local_storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({required this.storageService}) {
    _load();
  }

  final LocalStorageService storageService;

  ThemeMode _themeMode = ThemeMode.system;
  final Set<FamilyModule> _enabledModules =
      FamilyModule.values.toSet();
  bool _loading = true;

  ThemeMode get themeMode => _themeMode;

  bool get isLoading => _loading;

  Set<FamilyModule> get enabledModules => _enabledModules;

  Future<void> _load() async {
    final storedTheme = await storageService.loadThemeMode();
    final storedModules = await storageService.loadEnabledModules();

    if (storedTheme != null) {
      _themeMode = storedTheme;
    }

    if (storedModules != null && storedModules.isNotEmpty) {
      _enabledModules
        ..clear()
        ..addAll(storedModules);
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    await storageService.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> toggleModule(FamilyModule module, {bool? enabled}) async {
    final bool newValue = enabled ?? !_enabledModules.contains(module);
    if (newValue) {
      _enabledModules.add(module);
    } else {
      _enabledModules.remove(module);
    }

    await storageService.saveEnabledModules(_enabledModules.toList());
    notifyListeners();
  }

  bool isModuleEnabled(FamilyModule module) {
    return _enabledModules.contains(module);
  }
}
