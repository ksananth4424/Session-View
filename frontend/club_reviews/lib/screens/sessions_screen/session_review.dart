import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/utilities/custom_appbar.dart';
import 'package:flutter/material.dart';

class SessionReviews extends StatelessWidget {
  final Session session;
  const SessionReviews({super.key, required this.session});

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
      
    );
  }
}
