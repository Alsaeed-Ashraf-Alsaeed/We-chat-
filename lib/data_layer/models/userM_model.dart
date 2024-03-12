class UserModel {
  String name;

  int userId;

  String email;

  String password;

  List tokens;

  UserModel({
    required this.name,
    required this.userId,
    required this.email,
    required this.password,
    required this.tokens,
  });

  Map<String , dynamic> toJson() {
    return <String , dynamic>{
      'name': name,
      'userId': userId,
      'email': email,
      'password': password,
      'tokens': tokens
    };
  }

  factory UserModel.fromJson(Map data) {
    return UserModel(
        name: data['name'],
        userId: data['userId'],
        email: data['email'],
        password: data['password'],
        tokens: data['tokens']);
  }
}
