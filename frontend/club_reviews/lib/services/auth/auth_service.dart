import 'package:club_reviews/services/auth/auth_provider.dart';
import 'package:club_reviews/services/auth/auth_user.dart';
import 'package:club_reviews/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<bool> isAdmin() => provider.isAdmin();

  final AuthProvider provider;

  AuthService({required this.provider});

  factory AuthService.firebase() =>
      AuthService(provider: FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String name,
  }) =>
      provider.createUser(
        email: email,
        password: password,
        name: name,
      );

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
