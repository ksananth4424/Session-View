// ignore_for_file: use_build_context_synchronously

import 'package:club_reviews/constants/routes.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        color: const Color(0xFF28292B),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 500,
                child: Center(
                  child: Text('Session View',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
              Text(
                'Verify Email',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'we have sent an email verification. Please verify your email to proceed.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: OutlinedButton(
                  child: Text(
                    'Send Email Verification',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () async {
                    await AuthService.firebase().sendEmailVerification();
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: OutlinedButton(
                  child: Text(
                    'Restart Application',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () async {
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
