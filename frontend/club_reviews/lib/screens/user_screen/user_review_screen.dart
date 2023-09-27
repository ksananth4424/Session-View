import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/services/cloud/user_review_service.dart';
import 'package:club_reviews/utilities/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:club_reviews/services/auth/auth_service.dart';

import 'package:club_reviews/utilities/custom_appbar.dart';

class UserReviewScreen extends StatefulWidget {
  final Session session;
  const UserReviewScreen({
    super.key,
    required this.session,
  });

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  late final TextEditingController _text;
  late UserReviewService _reviewService;
  final club = AuthService.firebase().currentUser!;

  @override
  void initState() {
    _reviewService = UserReviewService();
    _text = TextEditingController();
    super.initState();
  }

  Future<void> sendReview() async {
    final text = _text.text;
    _reviewService.giveReview(
      text: text,
      session: widget.session,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        preferredSize: const Size.fromHeight(70),
        child: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            color: const Color.fromARGB(255, 221, 221, 221),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF28292B),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          right: 20,
          left: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Give Review',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                title: 'review',
                controller: _text,
                maxLines: 8,
              ),
              const SizedBox(height: 100),
              OutlinedButton.icon(
                icon: const Icon(
                  Icons.check,
                  color: Color(0xFFDDDDDD),
                ),
                label: Text(
                  'Send Review',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () async {
                  await sendReview();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
