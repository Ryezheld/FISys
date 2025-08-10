import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;

import '../model/users.dart';
import '../model/unit.dart';
import '../model/list_stuffing.dart';
import '../model/detail_stuffing.dart';

class ApiProvider {
  Client client = Client();
  static String _apiUrl = '';

  // Url Setter. Always call this before using any of the functions or methods below.
  void setUrl(String url) {
    _apiUrl = url;
  }

  // Login Functions and Methods
  Future<Users> login(String username, String password) async {
    final url = Uri.parse('${_apiUrl}login');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': username,
        'password': password,
      },
    );

    try{
      if (response.statusCode == 200) {
        return Users.fromJson(json.decode(response.body));
      } else {
        throw Exception('login(): There is an error');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Unit Stuffing Functions and Methods
  Future<Unit> fetchUnit(String uname) async {
    final url = Uri.parse('${_apiUrl}list_unit_stuffing');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user': uname
      },
    );

    try {
      if (response.statusCode == 200) {
        return Unit.fromJson(json.decode(response.body));
      } else {
        throw Exception("fetchUnit(): There is an error");
      }
    } catch (e) {
      throw Exception('$e - API URL: $_apiUrl');
    }
  }

  Future<Unit> checkNoSin(String nomesin) async {
    final url = Uri.parse('${_apiUrl}cek_nosin');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'nomesin': nomesin
      }
    );
    
    try {
      if (response.statusCode == 200) {
        return Unit.fromJson(json.decode(response.body));
      } else {
        throw Exception("fetchUnit(): There is an error");
      }
    } catch (e) {
      throw Exception(e);
    }    
  }

  Future<Unit> submitUnit(String uname, String noMesin) async {
    final url = Uri.parse('${_apiUrl}submit_nosin');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user': uname,
        'nomesin': noMesin
      },
    );

    try {
      if (response.statusCode == 200) {
        return Unit.fromJson(json.decode(response.body));
      } else {
        throw Exception("submitUnit(): There is an error");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Unit> hapusUnit(String uname, String noMesin) async {
    final url = Uri.parse('${_apiUrl}hapus_nosin');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user': uname,
        'nomesin': noMesin
      },
    );

    try {
      if (response.statusCode == 200) {
        return Unit.fromJson(json.decode(response.body));
      } else {
        throw Exception("hapusUnit(): There is an error");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // List Stuffing functions and methods
  Future<ListStuffing> fetchListStuffing (String tgl1, String tgl2, String uname) async {
    final url = Uri.parse('${_apiUrl}list_stuffing');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'tgl_1': tgl1,
        'tgl_2': tgl2,
        'user': uname
      },
    );

    try {
      if (response.statusCode == 200) {
        return ListStuffing.fromJson(json.decode(response.body));
      } else {
        throw Exception("fetchListStuffing(): There is an error");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Stuffing> fetchDetailStuffing (String noStl) async {
    final url = Uri.parse('${_apiUrl}detail_stuffing');
    final response = await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'no_stl': noStl
      },
    );

    try {
      if (response.statusCode == 200) {
        return Stuffing.fromJson(json.decode(response.body));
      } else {
        throw Exception("fetchDetailStuffing(): There is an error");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}