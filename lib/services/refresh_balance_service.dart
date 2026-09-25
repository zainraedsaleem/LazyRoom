import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/auth_service.dart';

class RefreshBalanceService {
  //refreshBalance
  static Future<String> refreshBalance(BuildContext context) async {
    final response = await http.get(
      Uri.parse("$baseUrl/balance"),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['balance'].toString();
    } else {
      throw Exception('Failed to refresh balance');
    }
  }
}
