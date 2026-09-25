import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/models/supplier_product.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/auth_service.dart';

class ProductService {
  //getProducts
  static Future<List<Product>> getProducts(BuildContext context) async {
    final response = await http.get(
      Uri.parse("$baseUrl/allProducts"),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List productsJson = data['data'];
      Provider.of<UserProvider>(context, listen: false).products = productsJson
          .map((e) => Product.fromJson(e))
          .toList();
      return productsJson.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  //getSupplierProducts
  static Future<List<SupplierProduct>> getSupplierProducts(
    BuildContext context,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/supplier/products"),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List productsJson = data['products'];
      Provider.of<UserProvider>(context, listen: false).supplierproducts =
          productsJson.map((e) => SupplierProduct.fromJson(e)).toList();
      return productsJson.map((e) => SupplierProduct.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  //getProductsByCategory
  static Future<List<Product>> getProductsByCategory(
    BuildContext context, {
    required id,
  }) async {
    final response = await http.get(
      Uri.parse("$baseUrl/product/category/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List products = data['data'];
      Provider.of<UserProvider>(context, listen: false).products = products
          .map((e) => Product.fromJson(e))
          .toList();
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed");
    }
  }

  //addProduct
  static Future<bool> addProduct(
    BuildContext context, {
    required String name,
    required String description,
    required int price,
    required int category_id,
    required int stock,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/storeProduct"),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer ${Provider.of<UserProvider>(context, listen: false).user!.token}",
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'category_id': category_id,
        'stock': stock,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201)
      return true;
    else
      return false;
  }

  //updateProduct
  static Future<bool> updateProduct(
    BuildContext context, {
    required int productId,
    required String name,
    required String description,
    required int price,
    required int category_id,
    required int stock,
  }) async {
    try {
      final token = Provider.of<UserProvider>(
        context,
        listen: false,
      ).user!.token;

      final response = await http.put(
        Uri.parse("$baseUrl/updateProduct/$productId"),

        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "name": name,
          "description": description,
          "price": price,
          "category_id": category_id,
          "stock": stock,
        }),
      );

      debugPrint(response.body);

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  //deleteProduct
  static Future<void> deleteProduct(BuildContext context, int productId) async {
    final token = Provider.of<UserProvider>(context, listen: false).user!.token;

    final response = await http.delete(
      Uri.parse("$baseUrl/deleteProduct/$productId"),

      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      debugPrint("Product deleted successfully");
    } else {
      throw Exception("Failed to delete product");
    }
  }
}
