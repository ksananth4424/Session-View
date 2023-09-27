import 'package:club_reviews/screens/user_screen/user_sessions_screen.dart';
import 'package:club_reviews/utilities/custom_drawer.dart';
import 'package:club_reviews/utilities/custom_appbar.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final club = AuthService.firebase().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        preferredSize: const Size.fromHeight(70),
        child: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
            iconSize: 30,
            color: const Color.fromARGB(255, 221, 221, 221),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF28292B),
      body: const UserSessionsScreen(),
      drawer: CustomDrawer(
        club: club,
        context: context,
      ),
    );
  }
}
