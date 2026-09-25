import 'package:flutter/material.dart';
import 'package:takroom/models/account_model.dart';
import 'package:takroom/models/cart_item_model.dart';
import 'package:takroom/models/customer_order_model.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/models/supplier_order_model.dart';
import 'package:takroom/models/supplier_product.dart';
import 'package:takroom/models/user_model.dart';
import 'package:takroom/services/admin_service.dart';
import 'package:takroom/services/orders_service.dart';
import 'package:takroom/services/product_service.dart';
import 'package:takroom/services/refresh_balance_service.dart';
import 'package:takroom/services/supplier_order_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class UserProvider extends ChangeNotifier {
  //global variabls
  UserModel? _user;

  //Lists
  List<SupplierOrderModel> _supplier_orders = [];
  List<CustomerOrderModel> orders = [];
  List<Product> products = [];
  List<SupplierProduct> supplierproducts = [];
  List<CartItem> cart_items = [];
  List<AccountModel> accounts = [];

  //Booleans
  bool isLoadingAccounts = false;
  bool isLodingCustomerOrders = false;
  bool isLodingSupplierOrders = false;
  bool isLodingProducts = false;
  bool isLodingSupplierProducts = false;
  bool isLodingBalance = false;

  //Getters
  List<SupplierOrderModel> get supplier_orders => _supplier_orders;
  int get itemCount => cart_items.length;
  UserModel? get user => _user;
  double get totalPrice {
    return cart_items.fold(0, (sum, item) => sum + item.total);
  }

  //Seters
  //setSupplierOrders
  void setSupplierOrders(List<SupplierOrderModel> newOrders) {
    _supplier_orders = newOrders;
    notifyListeners();
  }

  //User Setter Used in Auth
  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  //setUser in SplashScreen After get Shared Performanse Data
  void setUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  //clearUser
  void clearUser() {
    user = null;
    notifyListeners();
  }

  //Function

  //Cart Functions---------------------------------------------------------------

  //addToCart
  void addToCart(BuildContext context, Product product, int quantity) {
    // إذا كانت السلة غير فارغة تحقق من أن المزود نفسه
    if (cart_items.isNotEmpty &&
        cart_items.first.product.supplier.id != product.supplier.id) {
      ShowSnackbar.showSnackbar(
        context,
        "You can only add products from one supplier at a time",
      );
      return;
    }
    final index = cart_items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (index != -1) {
      cart_items[index].quantity += quantity;
    } else {
      cart_items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  //removeFromCart
  void removeFromCart(int productId) {
    cart_items.removeWhere((item) => item.product.id == productId);

    notifyListeners();
  }

  //clearCart
  void clearCart() {
    cart_items.clear();
    notifyListeners();
  }

  //Admin-------------------------------------------------------------------------
  //fetchAccounts
  Future<void> fetchAccounts(String token, String type) async {
    try {
      isLoadingAccounts = true;
      notifyListeners();

      accounts = await AdminService.getAccounts(token: token, type: type);
    } catch (e) {
      rethrow;
    } finally {
      isLoadingAccounts = false;
      notifyListeners();
    }
  }

  //removeAccount
  void removeAccount(int accountId) {
    accounts.removeWhere((account) => account.id == accountId);
    notifyListeners();
  }

  //banAccount
  void banAccount(int accountId) {
    final index = accounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      accounts[index].isBanned = true;
      notifyListeners();
    }
  }

  //unbanAccount
  void unbanAccount(int accountId) {
    final index = accounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      accounts[index].isBanned = false;
      notifyListeners();
    }
  }

  //depositToCustomer
  void depositToCustomer(int accountId, int amount) {
    final index = accounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      accounts[index].balance += amount;
      notifyListeners();
    }
  }

  //withdrawFromSupplier
  void withdrawFromSupplier(int accountId, int amount) {
    final index = accounts.indexWhere((account) => account.id == accountId);

    if (index != -1) {
      accounts[index].balance -= amount;
      notifyListeners();
    }
  }

  //Customer-------------------------------------------------------------------------
  //fetchProducts
  Future<void> fetchProducts(BuildContext context, index) async {
    isLodingProducts = true;
    notifyListeners();
    try {
      products = await ProductService.getProductsByCategory(context, id: index);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingProducts = false;
    notifyListeners();
  }

  //RefreshBalance
  Future<void> RefreshBalance(BuildContext context) async {
    isLodingBalance = true;
    notifyListeners();
    try {
      _user!.balance = await RefreshBalanceService.refreshBalance(context);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingBalance = false;
    notifyListeners();
  }

  //fetchAllProducts
  Future<void> fetchAllProducts(BuildContext context) async {
    isLodingProducts = true;
    notifyListeners();
    try {
      products = await ProductService.getProducts(context);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingProducts = false;
    notifyListeners();
  }

  //fetchOrders
  Future<void> fetchOrders(String token) async {
    isLodingCustomerOrders = true;
    notifyListeners();
    try {
      orders = await OrderService.getCustomerOrders(token);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingCustomerOrders = false;
    notifyListeners();
  }

  //cancelOrder
  Future<void> cancelOrder(String token, int orderId) async {
    try {
      await OrderService.cancelOrder(token: token, orderId: orderId);
      final index = orders.indexWhere((o) => o.orderId == orderId);
      if (index != -1) {
        orders[index].state = "cancelled";
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  //completeOrder
  Future<void> completeOrder(String token, int orderId) async {
    try {
      await OrderService.completeOrder(token: token, orderId: orderId);
      final index = orders.indexWhere((o) => o.orderId == orderId);
      if (index != -1) {
        orders[index].state = "complete";
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  //Supplier-------------------------------------------------------------------------

  //fetchSupplierProducts
  Future<void> fetchSupplierProducts(BuildContext context) async {
    isLodingSupplierProducts = true;
    notifyListeners();
    try {
      supplierproducts = await ProductService.getSupplierProducts(context);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingSupplierProducts = false;
    notifyListeners();
  }

  //fetchSupplierOrders
  Future<void> fetchSupplierOrders(String token) async {
    isLodingSupplierOrders = true;
    notifyListeners();
    try {
      setSupplierOrders(await SupplierOrderService.getSupplierOrders(token));
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingSupplierOrders = false;
    notifyListeners();
  }
}
