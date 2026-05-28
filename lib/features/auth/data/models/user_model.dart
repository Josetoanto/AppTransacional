import 'package:apptransaccional/features/auth/domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.email,
    required this.token,
    this.id,
  });

  final String email;
  final String token;
  final String? id;

  factory UserModel.fromJson(Map<String, dynamic> json, {required String email}) {
    return UserModel(
      email: email,
      token: json['token'] as String,
      id: json['id']?.toString() ?? email,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'token': token,
      'id': id,
    };
  }

  User toEntity() {
    return User(email: email, token: token, id: id);
  }
}
