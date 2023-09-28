// ignore_for_file: use_build_context_synchronously

import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/auth/auth_user.dart';
import 'package:club_reviews/utilities/dialogs/error_dialog.dart';
import 'package:club_reviews/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.club,
    required this.context,
  });

  final AuthUser club;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      surfaceTintColor: Color(0xF415151A),
      backgroundColor: Color(0xF415151A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              // color: Color(0x0015151A),
              border: Border(
                bottom: BorderSide(
                    color: Color.fromARGB(255, 113, 114, 114), width: 0.50),
              ),
            ),
            accountName: Text(
              club.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            accountEmail: Text(
              club.email,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            currentAccountPicture: ClipOval(
              child: Image.asset(
                'assets/images/lorem-photo.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            currentAccountPictureSize: const Size(60, 60),
          ),
          ListTile(
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onTap: () async {
              try {
                final shouldLogout = await showLogoutDialog(context);
                if (!shouldLogout) {
                  return;
                }
                AuthService.firebase().logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (_) => false);
              } catch (_) {
                showErrorDialog(
                    context: context, error: 'Something went wrong');
              }
            },
          ),
        ],
      ),
    );
  }
}
