import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  Future<bool> login({required Map<String, dynamic> data}) async {
    final SharedPreferencesAsync pref = SharedPreferencesAsync();
    final String? userString = await pref.getString('users');
    final List users = jsonDecode(userString ?? '[]');

    final user = users.firstWhere(
      (user) => user['email'] == data['email'],
      orElse: () => {},
    );

    if (user.isNotEmpty && user['password'] == data['password']) {
      await pref.setString('user', jsonEncode(user));
      return true;
    }

    return false;
  }

  Future<String> saveUser({required Map<String, dynamic> user}) async {
    final SharedPreferencesAsync pref = SharedPreferencesAsync();
    final String? userString = await pref.getString('users');
    final List users = jsonDecode(userString ?? '[]');

    user['id'] = users.isNotEmpty ? users[users.length - 1]['id'] + 1 : 1;
    users.add(user);
    await pref.setString('users', jsonEncode(users));

    return "Berhasil Register";
  }

  Future<String> saveProfile({required Map<String, dynamic> user}) async {
    final SharedPreferencesAsync pref = SharedPreferencesAsync();
    final String? userString = await pref.getString('users');

    final List users = jsonDecode(userString ?? '[]');

    final userLogin = users.firstWhere(
      (item) => item['id'] == user['id'],
      orElse: () => {},
    );

    if (userLogin.isNotEmpty) {
      userLogin['name'] = user['name'];
      userLogin['email'] = user['email'];
      await pref.setString('user', jsonEncode(userLogin));
      await pref.setString('users', jsonEncode(users));
    }

    return "Profile disimpan";
  }

  Future<String> logout() async {
    final SharedPreferencesAsync pref = SharedPreferencesAsync();
    await pref.remove('user');
    return "Berhasil keluar";
  }

  Future<Map<String, dynamic>> getUserLogin() async {
    final SharedPreferencesAsync pref = SharedPreferencesAsync();
    final String? userString = await pref.getString('user');

    if (userString == null) {
      return {};
    }

    return jsonDecode(userString);
  }
}
