// ignore_for_file: use_build_context_synchronously

import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/main.dart';
import 'package:club_reviews/services/auth/auth_exceptions.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void login() async {
    final email = _email.text;
    final password = _password.text;

    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      await AuthService.firebase().login(
        email: email,
        password: password,
      );

      Navigator.of(context).pop();

      final user = AuthService.firebase().currentUser;
      if (user?.isVerified ?? false) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
      } else {
        Navigator.of(context).pushNamed(verifyRoute);
      }
    } on UserNotFoundException catch (_) {
      Navigator.of(context).pop();
      await showErrorDialog(
        context: context,
        error: 'User Not Found',
      );
    } on WrongPasswordException catch (_) {
      Navigator.of(context).pop();
      await showErrorDialog(
        context: context,
        error: 'Wrong Password',
      );
    } on GenericAuthException catch (_) {
      Navigator.of(context).pop();
      await showErrorDialog(
        context: context,
        error: 'Authentication Error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          color: const Color(0xFF28292B),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 470,
                  child: Center(
                    child: Text(
                      'Reviews',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.titleMedium?.apply(
                        color: const Color(0xFFDDDDDD),
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'email',
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        color: Color(0xFF545454),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    labelText: 'password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                        color: Color(0xFF545454),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.email_outlined,
                    color: Color.fromARGB(255, 255, 148, 112),
                  ),
                  label: Text(
                    'Login with email address',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () => login(),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (_) => false,
                    );
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: 'Register here!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.apply(color: const Color(0xFF00D0FE)),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
