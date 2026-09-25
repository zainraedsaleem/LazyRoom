import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:takroom/models/account_model.dart';
import 'package:takroom/services/auth_service.dart';

class AdminService {
  static Map<String, String> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Get Accounts
  static Future<List<AccountModel>> getAccounts({
    required String token,
    required String type,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts?type=$type'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data['data'] as List)
          .map((e) => AccountModel.fromJson(e))
          .toList();
    }

    throw Exception(data['message'] ?? 'Failed to load accounts');
  }

  // Create Account
  static Future<String> createAccount({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data['message'];
    }

    throw Exception(data['message'] ?? 'Failed to create account');
  }

  // Delete Account
  static Future<String> deleteAccount({
    required String token,
    required int userId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/accounts/$userId'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    }

    throw Exception(data['message'] ?? 'Failed to delete account');
  }

  // Ban User
  static Future<String> banUser({
    required String token,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ban/$userId'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    }

    throw Exception(data['message'] ?? 'Failed to ban user');
  }

  // Unban User
  static Future<String> unbanUser({
    required String token,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/unban/$userId'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    }

    throw Exception(data['message'] ?? 'Failed to unban user');
  }

  // Deposit To Customer
  static Future<String> depositToCustomer({
    required String token,
    required int customerId,
    required int amount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deposit'),
      headers: _headers(token),
      body: jsonEncode({'customer_id': customerId, 'amount': amount}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    }

    throw Exception(data['message'] ?? 'Deposit failed');
  }

  // Withdraw From Supplier
  static Future<String> withdrawFromSupplier({
    required String token,
    required int supplierId,
    required int amount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/withdraw'),
      headers: _headers(token),
      body: jsonEncode({'supplier_id': supplierId, 'amount': amount}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    }

    throw Exception(data['message'] ?? 'Withdraw failed');
  }
}
