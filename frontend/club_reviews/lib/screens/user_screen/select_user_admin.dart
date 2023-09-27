import 'package:club_reviews/screens/sessions_screen/sessions_screen.dart';
import 'package:club_reviews/screens/user_screen/user_screen.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class SelectUserAdmin extends StatelessWidget {
  const SelectUserAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().isAdmin(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final isAdmin = snapshot.data as bool;
            if (isAdmin) {
              return const SessionsScreen();
            } else {
              return const UserScreen();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
