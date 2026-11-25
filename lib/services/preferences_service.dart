import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _chaveTemaEscuro = 'tema_escuro';

  Future<void> salvarTemaEscuro(bool temaEscuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveTemaEscuro, temaEscuro);
  }

  Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveTemaEscuro) ?? false;
  }
}
