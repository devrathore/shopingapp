import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _keyLoggedIn = 'loggedIn';
  static const _keyUserId = 'userId';

  static Future<void> saveUserData({
    required bool loggedIn,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, loggedIn);
    await prefs.setString(_keyUserId, userId);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    final userId = prefs.getString(_keyUserId) ?? '';
    return {'loggedIn': loggedIn, 'userId': userId};
  }

  // Clear user data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserId);
  }
}
