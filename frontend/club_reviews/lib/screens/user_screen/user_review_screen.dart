// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/services/cloud/user_review_exceptions.dart';
import 'package:club_reviews/services/cloud/user_review_service.dart';
import 'package:club_reviews/utilities/custom_text_field.dart';
import 'package:club_reviews/utilities/dialogs/error_dialog.dart';
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
    try {
      final text = _text.text;
      await _reviewService.giveReview(
        text: text,
        session: widget.session,
      );
      Navigator.of(context).pop();
    } on CouldNotSendReviewException catch (_) {
      await showErrorDialog(
        context: context,
        error: 'Could not send the review',
      );
    }
  }

  Future<String> getClubName() async {
    final name = await FirebaseFirestore.instance
        .collection('clubs')
        .doc(widget.session.clubId)
        .get();
    return name.data()![nameField];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getClubName(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.session.name,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.apply(
                                    color: const Color(0xFF00D0FE),
                                  ),
                        ),
                        Text(
                          '${snapshot.data} • ${widget.session.date}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          widget.session.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Give Review',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          title: 'Review',
                          controller: _text,
                          maxLines: 10,
                        ),
                        const SizedBox(height: 100),
                        Center(
                          child: OutlinedButton.icon(
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
