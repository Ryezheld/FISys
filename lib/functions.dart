import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:FISys/network/model/users.dart';
import 'package:FISys/providers/user_provider.dart';
import 'sql_helper.dart';

class Functions {
  Future<void> readData(context) async {
    // Get user info saved in SQLite for usage by Provider
    final data = await SQLHelper.getItems();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (data.isNotEmpty) {
      final usersList = data
          .map((item) => UserData(
                idUser: item['id_user'],
                userLogin: item['user_login'],
                nama: item['nama'],
                user: item['user'],
                idXpdc: item['id_xpdc'],
                tipeUser: item['tipe_user'],
              ))
          .toList();

      userProvider.setUsers(usersList);
      // print('Provider set');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data ada')));
    } else {
      showDialog(
          context: context,
          builder: ((context) => const AlertDialog(
                title: Text('Notification'),
                content: Text('Data tidak ada'),
              )));
    }
  }

  Future<void> deleteData(context) async {
    // Delete user info in SQLite when logging out
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final deleteTarget = userProvider.users[0].idUser;
    await SQLHelper.deleteItem(deleteTarget);
    // print('Data dihapus');
  }

  Future<void> navigateToDestination(context, String destination) async {
    Navigator.pushReplacementNamed(context, destination);
  }

  Future<String> checkLoginStatus(context) async {
    // Check for login status and return the saved `apiUrl`
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (isLoggedIn) {
      if (currentRoute == null ||
          currentRoute == '/login' ||
          currentRoute == '/admin') {
        navigateToDestination(context, '/home');
      }
    } else {
      if (currentRoute == null || currentRoute == '/home') {
        navigateToDestination(context, '/login');
      }
    }

    final apiUrl = prefs.getString('apiUrl') ??
        'http://portal.daya-wisesa.com/api_fisys/dev/api.php';
    return apiUrl;
  }

  Future<void> logout(context) async {
    // Logout processing logic here
    final dynamic msg;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      deleteData(context);
      prefs.setBool('isLoggedIn', false);
      Provider.of<UserProvider>(context, listen: false).setUsers([]);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      msg = e;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
