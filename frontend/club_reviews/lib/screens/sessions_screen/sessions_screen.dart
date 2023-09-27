import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/utilities/custom_drawer.dart';
import 'package:club_reviews/utilities/custom_appbar.dart';
import 'package:club_reviews/screens/sessions_screen/all_sessions.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final club = AuthService.firebase().currentUser!;
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cloudStorage.initialize(user: club),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
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
                body: const UpcomingSessions(),
                drawer: CustomDrawer(
                  club: club,
                  context: context,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(createSession);
                  },
                  child: const Icon(Icons.add),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
