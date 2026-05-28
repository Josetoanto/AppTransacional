class User {
  const User({
    required this.email,
    required this.token,
    this.id,
  });

  final String email;
  final String token;
  final String? id;
}
