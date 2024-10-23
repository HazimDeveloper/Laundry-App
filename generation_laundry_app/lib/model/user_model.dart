class User {
  final int id;
  final String name;
  final String email;
  final String address;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      role: json['role'],
    );
  }
}