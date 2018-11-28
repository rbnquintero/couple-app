import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalRepository {
  static final String keyProfile = "key_perfil";

  static Future<Map<String, dynamic>> getPerfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String perfilString = prefs.getString(keyProfile);
    if (perfilString == null) {
      return null;
    }
    return json.decode(perfilString);
  }

  static void setPerfil(Map<String, dynamic> perfil) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (perfil == null) {
      prefs.remove(keyProfile);
      return;
    }
    String perfilString = json.encode(perfil);
    prefs.setString(keyProfile, perfilString);
  }
}
