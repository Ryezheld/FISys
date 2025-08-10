import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FISys/functions.dart';

class UrlSet extends StatefulWidget {
  const UrlSet({Key? key}) : super(key: key);

  @override
  UrlSetState createState() => UrlSetState();
}

class UrlSetState extends State<UrlSet> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Functions().checkLoginStatus(context).then((apiUrl) {
      // Check login status
      setState(() {
        _urlController.text =
            apiUrl; // Setting the textfield input into the current `apiUrl`
      });
    });
  }

  Future<void> setApiUrl(String apiUrl, context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('apiUrl', apiUrl);
    _snackBarDialog();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _snackBarDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('API URL has been updated.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Set URL baru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'API URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                final apiUrl = _urlController.text;
                await setApiUrl(apiUrl, context);
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40)),
              child: const Text(
                'Set URL',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
