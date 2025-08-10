import 'package:flutter/material.dart';
import 'package:FISys/network/model/users.dart';

class UserProvider with ChangeNotifier {
  List<UserData> _users = [];

  List<UserData> get users => _users;

  void setUsers(List<UserData> newUsers) {
    _users = newUsers;
    notifyListeners();
  }
}
