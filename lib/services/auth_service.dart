import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:takroom/models/register_request_model.dart';
import 'package:takroom/models/user_model.dart';
import 'package:takroom/providers/user_provider.dart';

const String baseUrl = "http://10.235.157.233:8000/api";

class AuthService {
  //register
  static Future<bool> register(
    BuildContext context,
    RegisterRequestModel user,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      UserModel user = UserModel.fromJson(jsonDecode(response.body));
      Provider.of<UserProvider>(context, listen: false).user = user;
      return true;
    } else {
      return false;
    }
  }

  //login
  static Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      UserModel user = UserModel.fromJson(jsonDecode(response.body));
      Provider.of<UserProvider>(context, listen: false).user = user;
      return true;
    } else {
      return false;
    }
  }
}
