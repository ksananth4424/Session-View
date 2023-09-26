import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class SessionsScreeen extends StatefulWidget {
  const SessionsScreeen({super.key});

  @override
  State<SessionsScreeen> createState() => _SessionsScreeenState();
}

class _SessionsScreeenState extends State<SessionsScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
          onPressed: () => AuthService.firebase().logout(),
          child: const Center(child: Text('logout'))),
    );
  }
}
