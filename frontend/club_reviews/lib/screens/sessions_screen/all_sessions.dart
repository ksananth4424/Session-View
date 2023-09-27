import 'package:club_reviews/screens/sessions_screen/session_review.dart';
import 'package:club_reviews/screens/sessions_screen/sessions_widget.dart';
import 'package:club_reviews/services/cloud/firebase_cloud_storage.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/utilities/dialogs/start_reviews_dialog.dart';
import 'package:club_reviews/utilities/dialogs/stop_review_dialog.dart';
import 'package:flutter/material.dart';

class UpcomingSessions extends StatefulWidget {
  const UpcomingSessions({super.key});

  @override
  State<UpcomingSessions> createState() => _UpcomingSessionsState();
}

class _UpcomingSessionsState extends State<UpcomingSessions> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  void startReview({required Session session}) async {
    final shouldReview = await showStartReviewDialog(context);
    if (shouldReview) {
      _cloudStorage.startReviewing(session: session);
    }
  }

  void stopReviewing({required Session session}) async {
    final shouldStop = await showStopReviewDialog(context);
    if (shouldStop) {
      _cloudStorage.stopReviewing(session: session);
    }
  }

  void showReviews({required Session session}) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionReviews(session: session),
      ),
    );
  }

  void Function({required Session session}) getFunc(Session session) {
    if (session.state == 0) {
      return startReview;
    } else if (session.state == 1) {
      return stopReviewing;
    } else if (session.state == 2) {
      return showReviews;
    } else {
      return ({required Session session}) {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cloudStorage.allSessions(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (snapshot.hasData) {
              final allSessions = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: allSessions.length,
                  itemBuilder: (context, index) {
                    final session = allSessions.elementAt(index);
                    return SessionWidget(
                      session: session,
                      navToReview: showReviews,
                      press: getFunc(session),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
