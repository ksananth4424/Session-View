import 'package:club_reviews/screens/sessions_screen/sessions_widget.dart';
import 'package:club_reviews/services/cloud/firebase_cloud_storage.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/utilities/dialogs/start_reviews_dialog.dart';
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

  void stopReviewing({required Session session}) async {}

  void showReviews({required Session session}) async {
    
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
                return ListView.builder(
                  itemCount: allSessions.length,
                  itemBuilder: (context, index) {
                    return SessionWidget(
                      session: allSessions.elementAt(index),
                      press: startReview,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
