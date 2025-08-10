import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FISys/network/model/users.dart';
import 'package:FISys/network/api/api_provider.dart';
import 'package:FISys/functions.dart';
import 'package:FISys/sql_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String apiUrl = '';

  @override
  void initState() {
    super.initState();
    Functions().checkLoginStatus(context).then((url) {
      setState(() {
        apiUrl = url;
      });
    });
  }

  Future<void> _addData(Users loginData) async {
    //Input user info into SQLite
    final idUser = loginData.data.idUser;
    final userLogin = loginData.data.userLogin;
    final nama = loginData.data.nama;
    final user = loginData.data.user;
    final idXpdc = loginData.data.idXpdc;
    final tipeUser = loginData.data.tipeUser;
    await SQLHelper.createItem(idUser, userLogin, nama, user, idXpdc, tipeUser);
  }

  Future<void> processLogin(context) async {
    // Login processing logic here
    final dynamic msg;
    try {
      ApiProvider().setUrl(apiUrl);
      var res = await ApiProvider()
          .login(_usernameController.text, _passwordController.text);
      Users user = res;

      _addData(user);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      Functions().navigateToDestination(context, '/home');
    } catch (e) {
      msg = e;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 160,
              width: 160,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_usernameController.text == 'admin' &&
                    _passwordController.text == 'admin') {
                  // If input is `admin` and `admin`
                  Navigator.pushReplacementNamed(
                      context, '/admin'); // Head to `Url Set` page
                } else {
                  processLogin(context); // Else, process login
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40)),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
