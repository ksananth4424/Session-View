import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String email;
  final bool isVerified;
  final String name;
  bool isAdmin = true;

  AuthUser({
    required this.id,
    required this.email,
    required this.isVerified,
    required this.name,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isVerified: user.emailVerified,
        name: user.displayName!,
      );
}
