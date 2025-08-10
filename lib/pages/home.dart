import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FISys/widgets/menu_box.dart';
import 'package:FISys/providers/user_provider.dart';
import 'package:FISys/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String apiUrl = '';

  @override
  void initState() {
    super.initState();
    Functions().readData(context); // Getting user info
    Functions().checkLoginStatus(context).then((url) {
      // Check login status
      setState(() {
        apiUrl = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // Top body
          Container(
            height: 200, // Change height as needed
            color: Colors.cyan, //Change color as needed
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 160,
                  width: 160,
                ),
              ),
              userProvider.users
                      .isNotEmpty // Do a check for the user info in Provider
                  ? Text(
                      'Welcome, ${userProvider.users[0].user}', // If user info exists
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Loading...'), //else
            ]),
          ),
          // Lower body
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                InkWell(
                  // Button to access `Unit Stuffing`
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/unit');
                  },
                  child: const MenuWidget(icon: Icons.motorcycle, text: "Unit"),
                ),
                InkWell(
                  // Button to access `List Stuffing`
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/list');
                  },
                  child: const MenuWidget(icon: Icons.view_list, text: "List"),
                ),
                InkWell(
                  // Logout Button
                  onTap: () {
                    Functions().logout(context);
                  },
                  child:
                      const MenuWidget(icon: Icons.exit_to_app, text: "Logout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
