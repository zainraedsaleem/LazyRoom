class CustomerOrderModel {
  final int orderId;
  String state;
  final String totalPrice;
  final String createdAt;
  final List<OrderItemModel> items;

  CustomerOrderModel({
    required this.orderId,
    required this.state,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderModel(
      orderId: json['id'],
      state: json['state'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int itemId;
  final String productName;
  final int quantity;
  final String pricePerItem;
  final String subtotal;

  OrderItemModel({
    required this.itemId,
    required this.productName,
    required this.quantity,
    required this.pricePerItem,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      itemId: json['id'],
      productName: json['product']['name'],
      quantity: json['quantity'],
      pricePerItem: json['price'],
      subtotal: json['product']['price'],
    );
  }
}
