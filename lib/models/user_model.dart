class UserModel {
  final String token;
  final String name;
  final String email;
  final String role;
  String balance;
  final String building;
  final String room_number;

  UserModel({
    required this.token,
    required this.name,
    required this.email,
    required this.role,
    required this.balance,
    required this.building,
    required this.room_number,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      name: json['user']['name'],
      email: json['user']['email'],
      role: json['user']['role'],
      balance: json['user']['balance'],
      building: json['user']['building'] ?? '',
      room_number: json['user']['room_number'] ?? '',
    );
  }
}
