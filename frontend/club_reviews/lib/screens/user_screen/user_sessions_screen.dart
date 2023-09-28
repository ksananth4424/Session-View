import 'package:club_reviews/screens/user_screen/user_review_screen.dart';
import 'package:club_reviews/screens/user_screen/user_session_widget.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/services/cloud/user_review_service.dart';
import 'package:flutter/material.dart';

class UserSessionsScreen extends StatefulWidget {
  const UserSessionsScreen({super.key});

  @override
  State<UserSessionsScreen> createState() => _UserSessionsScreenState();
}

class _UserSessionsScreenState extends State<UserSessionsScreen> {
  late final UserReviewService _reviewService;

  @override
  void initState() {
    _reviewService = UserReviewService();
    super.initState();
  }

  void showGiveReviewPage({required Session session}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserReviewScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _reviewService.sessionsOfAllClubs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (snapshot.hasData) {
              final allSessions = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  itemCount: allSessions.length,
                  itemBuilder: (context, index) {
                    final session = allSessions.elementAt(index);
                    return UserSessionWidget(
                      session: session,
                      navToReview: showGiveReviewPage,
                      press: showGiveReviewPage,
                    );
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
