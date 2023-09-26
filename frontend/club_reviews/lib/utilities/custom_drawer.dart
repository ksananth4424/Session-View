import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/auth/auth_user.dart';
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
      backgroundColor: const Color(0xDC151518),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF151518),
              border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 40, 41, 43), width: 2.0)),
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
            onTap: () {
              AuthService.firebase().logout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (_) => false);
            },
          ),
        ],
      ),
    );
  }
}
