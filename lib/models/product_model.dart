class Product {
  final int id;
  final int category_id;
  final String name;
  final String price;
  final Supplier supplier;

  Product({
    required this.id,
    required this.category_id,
    required this.name,
    required this.price,
    required this.supplier,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      category_id: json['category_id'],
      price: json['price'],
      name: json['name'],
      supplier: Supplier.fromJson(json['supplier']),
    );
  }
}

class Supplier {
  final int id;
  final String name;

  Supplier({required this.id, required this.name});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(id: json['id'], name: json['name']);
  }
}
