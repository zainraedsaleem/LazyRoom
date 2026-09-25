class AccountModel {
  final int id;
  final String name;
  final String email;
  final String role;
  double balance;
  bool isBanned;

  AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.balance,
    required this.isBanned,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      balance: double.parse(json['balance']),
      isBanned: json['is_banned'] == 0 ? false : true,
    );
  }
}
