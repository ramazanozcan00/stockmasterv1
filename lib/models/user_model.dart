class User {
  final String userId;
  final String username;
  final String email;
  final String branchId;
  final String branchName;
  final String token;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.branchId,
    required this.branchName,
    required this.token,
  });

  // JSON'dan (API verisinden) Nesneye dönüştürme
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? "",
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      branchId: json['branchId'] ?? "",
      branchName: json['branchName'] ?? "",
      token: json['token'] ?? "",
    );
  }

  // Nesneden JSON'a dönüştürme (Kaydetmek için lazım olabilir)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'branchId': branchId,
      'branchName': branchName,
      'token': token,
    };
  }
}
