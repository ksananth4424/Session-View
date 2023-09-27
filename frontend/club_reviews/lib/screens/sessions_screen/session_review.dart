import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/utilities/custom_appbar.dart';
import 'package:flutter/material.dart';

class SessionReviews extends StatelessWidget {
  final Session session;
  SessionReviews({super.key, required this.session});
  final clubName = AuthService.firebase().currentUser!.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        preferredSize: const Size(0, 70),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '$clubName • ${session.date}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 30),
              Text(
                session.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              buildReviewBar(
                name: 'Management',
                field: managementField,
              ),
              const SizedBox(height: 40),
              buildReviewBar(
                name: 'Topic Level',
                field: topicLevelField,
              ),
              const SizedBox(
                height: 40,
              ),
              buildReviewBar(
                name: 'Length of Session',
                field: lengthField,
              ),
              const SizedBox(height: 40),
              buildReviewBar(
                name: 'Beginner Friendly',
                field: beginnerFriendlyField,
              ),
              const SizedBox(height: 40),
              buildReviewBar(
                name: 'Informative',
                field: informativeField,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildReviewBar({
    required String field,
    required String name,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF00D0FE),
          value: (session.tags[field] == 0 ? 0.0 : session.tags[field]),
        )
      ],
    );
  }
}
