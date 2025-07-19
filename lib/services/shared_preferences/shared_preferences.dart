import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Token methods
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // User data methods with proper JSON serialization
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = jsonEncode(userData);
      await prefs.setString(_userKey, userDataJson);
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);

      if (userDataString == null) return null;

      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Utility methods
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing preferences: $e');
      rethrow;
    }
  }

  static Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error removing token: $e');
      rethrow;
    }
  }

  static Future<void> removeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error removing user data: $e');
      rethrow;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Additional utility methods
  static Future<bool> hasUserData() async {
    try {
      final userData = await getUserData();
      return userData != null && userData.isNotEmpty;
    } catch (e) {
      print('Error checking user data: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      await removeToken();
      await removeUserData();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}