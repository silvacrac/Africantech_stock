import 'package:shared_preferences/shared_preferences.dart';

class GestorToken {
  static const String _chaveToken = "JWT_TOKEN_AFRICANTECH";

  static Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveToken, token);
  }

  static Future<String?> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chaveToken);
  }

  static Future<void> removerToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveToken);
  }
}