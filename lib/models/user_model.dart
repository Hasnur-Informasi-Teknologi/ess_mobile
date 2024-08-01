class UserModel {
  final bool status;
  late final String token;

  UserModel({
    required this.status,
    required this.token,
  });

  factory UserModel.fromJson(json) {
    return UserModel(
      status: json['status'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
