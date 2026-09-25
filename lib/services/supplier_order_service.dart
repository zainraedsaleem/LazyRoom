import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:takroom/models/supplier_order_model.dart';
import 'package:takroom/services/auth_service.dart';

class SupplierOrderService {
  //getSupplierOrders
  static Future<List<SupplierOrderModel>> getSupplierOrders(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/supplier/orders'),

      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data['orders'] as List)
          .map((e) => SupplierOrderModel.fromJson(e))
          .toList();
    }

    throw Exception(data['message']);
  }

  //acceptOrder
  static Future<String> acceptOrder({
    required String token,
    required int orderId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderId/accept'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    } else {
      throw Exception(data['message']);
    }
  }

  //rejectOrder
  static Future<String> rejectOrder({
    required String token,
    required int orderId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderId/reject'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    } else {
      throw Exception(data['message']);
    }
  }
}
