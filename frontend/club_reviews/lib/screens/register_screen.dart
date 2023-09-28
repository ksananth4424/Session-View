// ignore_for_file: use_build_context_synchronously

import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/services/auth/auth_exceptions.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  void register() async {
    final name = _name.text;
    final email = _email.text;
    final password = _password.text;

    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      await AuthService.firebase().createUser(
        email: email,
        password: password,
        name: name,
      );

      await AuthService.firebase().sendEmailVerification();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(verifyRoute);
    } on WeakPasswordException catch (_) {
      Navigator.of(context).pop();
      showErrorDialog(
        context: context,
        error: 'Weak Password',
      );
    } on InvalidEmailException catch (_) {
      Navigator.of(context).pop();
      showErrorDialog(
        context: context,
        error: 'Invalid Email',
      );
    } on EmailAlreadyInUseException catch (_) {
      Navigator.of(context).pop();
      showErrorDialog(
        context: context,
        error: 'Email Already in use',
      );
    } on GenericAuthException catch (_) {
      Navigator.of(context).pop();
      showErrorDialog(
        context: context,
        error: 'Authentication Error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Text('Reviews',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
              Text(
                'Create a New Account!',
                style: Theme.of(context).textTheme.titleMedium?.apply(
                      color: const Color(0xFFDDDDDD),
                    ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _name,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelText: 'username',
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
                  'Register with email address',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () => register(),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: 'Login here!',
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
    );
  }
}
