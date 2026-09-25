import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveUserData({
    required String token,
    required String role,
    required String name,
    required String email,
    required String balance,
    required String build,
    required String room_number,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('balance', balance);
    await prefs.setString('build', build);
    await prefs.setString('room_number', room_number);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      return null;
    }

    return {
      'token': prefs.getString('token'),
      'role': prefs.getString('role'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'balance': prefs.getString('balance'),
      'build': prefs.getString('build'),
      'room_number': prefs.getString('room_number'),
    };
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
