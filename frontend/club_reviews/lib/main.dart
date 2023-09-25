import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/screens/login_screen.dart';
import 'package:club_reviews/screens/register_screen.dart';
import 'package:club_reviews/screens/sessions.dart';
import 'package:club_reviews/screens/verify_email_screen.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/utilities/theme_data.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 140, 255)),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        verifyRoute: (context) => const VerifyEmailScreen(),
        sessionsRoute: (context) => const SessionsScreeen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isVerified) {
                return const SessionsScreeen();
              } else {
                return const VerifyEmailScreen();
              }
            } else {
              return const LoginScreen();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
