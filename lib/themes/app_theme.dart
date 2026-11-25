import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

class AppTheme {
  // guarda o tema atual, o MaterialApp escuta esse notifier no main.dart
  static final ValueNotifier<ThemeMode> modoTema =
      ValueNotifier(ThemeMode.light);

  static const Color corPrincipal = Colors.indigo;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: corPrincipal,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: const CardThemeData(elevation: 2),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: corPrincipal,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: const CardThemeData(elevation: 2),
    );
  }

  static bool get temaEscuro => modoTema.value == ThemeMode.dark;

  static Future<void> alterarTema(bool escuro) async {
    modoTema.value = escuro ? ThemeMode.dark : ThemeMode.light;
    await PreferencesService().salvarTemaEscuro(escuro);
  }

  static Color corPrioridade(String prioridade) {
    switch (prioridade) {
      case 'Alta':
        return Colors.red;
      case 'Média':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  static IconData iconePrioridade(String prioridade) {
    switch (prioridade) {
      case 'Alta':
        return Icons.keyboard_double_arrow_up;
      case 'Média':
        return Icons.drag_handle;
      default:
        return Icons.keyboard_double_arrow_down;
    }
  }
}
