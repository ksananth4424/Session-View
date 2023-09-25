import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isVerified;
  final String name;
  final bool isAdmin;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isVerified,
    required this.name,
    this.isAdmin = true,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isVerified: user.emailVerified,
        name: user.displayName!,
      );
}
