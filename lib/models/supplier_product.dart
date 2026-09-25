class SupplierProduct {
  final int id;
  final int supplierId;
  final int categoryId;
  final String name;
  final String price;
  final int stock;
  final String? description;

  SupplierProduct({
    required this.id,
    required this.supplierId,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
  });

  factory SupplierProduct.fromJson(Map<String, dynamic> json) {
    return SupplierProduct(
      id: json['id'],
      supplierId: json['supplier_id'],
      categoryId: json['category_id'],
      name: json['name'],
      price: json['price'].toString(),
      stock: json['stock'] ?? 0,
      description: json['description'],
    );
  }
}
