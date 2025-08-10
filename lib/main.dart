import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'app_config.dart';
import 'providers/user_provider.dart';
import 'package:FISys/pages/url_set.dart';
import 'package:FISys/pages/login.dart';
import 'package:FISys/pages/home.dart';
import 'package:FISys/pages/unit_stuffing.dart';
import 'package:FISys/pages/list_stuffing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String apiUrl = AppConfig.apiUrl;

  await prefs.setString('apiUrl', apiUrl);

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'FISYS',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        initialRoute: isLoggedIn ? '/home' : '/login',
        routes: {
          '/admin': (context) => const UrlSet(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/unit': (context) => const UnitStuffingPage(),
          '/list': (context) => const ListStuffingPage(),
        },
      ),
    ),
  );
}
