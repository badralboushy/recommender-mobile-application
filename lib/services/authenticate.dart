import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:travel_guide/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_guide/services/config.dart';

class Authenticate {
  static String? email;

  static String? name;

  static String? token;

  static String? user_id;

  static void showAlert(context ,String message) {
    Alert(
      image: Icon(Icons.block, color: Colors.red, size: 80,),
      context: context,
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
    ).show();
  }
  static Future register(String name, String email, String password,
      String password_confirmation) async {
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    String API_URL =
        "http://${Constants.ServerIP}/api/register";

    final response = await http.post(Uri.parse(API_URL), body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation
    });
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      await saveInfo(data['token'], data['user']['name'], data['user']['email'],data['user']['id'].toString());
      return true;
    }
    return false;
  }

  static Future logIn(String email, String password) async {
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    String API_URL =
        "http://${Constants.ServerIP}/api/login";

    final response = await http.post(Uri.parse(API_URL), body: {
      'email': email,
      'password': password,
    });
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
     await saveInfo(data['token'], data['user']['name'], data['user']['email'],data['user']['id'].toString());

      return true;
    }
    return false;
  }

  static Future<void> saveInfo(String t, String n, String e , String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', t);
    sharedPreferences.setString('name', n);
    sharedPreferences.setString('email', e);
    sharedPreferences.setString('user_id', id);
    name = n;
    token = t;
    email = e;
    user_id = id;
  }

  static Future<String?> getToken() async {
    if (token != null) return token;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('token')) {
      token = sharedPreferences.getString('token');
      return token;
    } else {
      return null;
    }
  }

  static Future<String?> getUser_id() async {
    if (user_id != null) return user_id;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('user_id')) {
      user_id = sharedPreferences.getString('user_id');
      return user_id;
    }else
      return null;
  }

  static Future<String?> getName() async {
    if (name != null) return name;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('name')) {
      name = sharedPreferences.getString('name');
      return name;
    } else
      return null;
  }

  static Future<String?> getEmail() async {
    if (email != null) return email;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('email')) {
      email = sharedPreferences.getString('email');
      return email;
    } else
      return null;
  }

  static Future<void> deleteInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    name = null;
    email = null;
    token = null;
    user_id= null;
  }

  static Future logOut() async {
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    String API_URL =
        "http://${Constants.ServerIP}/api/logout";
    var token =await getToken();

    final response = await http.post(Uri.parse(API_URL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
     await deleteInfo();
     return true;
    }
    return false;
  }
}
