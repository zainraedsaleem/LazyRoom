import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:takroom/models/cart_item_model.dart';
import 'package:takroom/models/customer_order_model.dart';
import 'package:takroom/models/order_request_item.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/auth_service.dart';

class OrderService {
  //createOrder
  static Future<String> createOrder(
    BuildContext context, {
    required List<OrderRequestItem> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}',
      },

      body: jsonEncode({"items": items.map((e) => e.toJson()).toList()}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return "Order sent";
    } else {
      throw Exception(data['message']);
    }
  }

  //createMulteOrder
  static Future<String> createMulteOrder(
    BuildContext context, {
    required List<CartItem> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}',
      },

      body: jsonEncode({"items": items.map((e) => e.toJson()).toList()}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return "Orders sent";
    } else {
      throw Exception(data['message']);
    }
  }

  //cancelOrder
  static Future<void> cancelOrder({
    required String token,
    required int orderId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/orders/$orderId/cancel"),

      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Failed to cancel order");
    }
  }

  //completeOrder
  static Future<void> completeOrder({
    required String token,
    required int orderId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/orders/$orderId/complete"),

      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Failed to cancel order");
    }
  }

  //getCustomerOrders
  static Future<List<CustomerOrderModel>> getCustomerOrders(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/my-orders"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List ordersJson = data['orders'];

      return ordersJson.map((e) => CustomerOrderModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load orders");
    }
  }
}
