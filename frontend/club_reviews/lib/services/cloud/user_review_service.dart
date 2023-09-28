import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:club_reviews/services/cloud/user_review_exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as devtools show log;

class UserReviewService {
  final userId = AuthService.firebase().currentUser!;
  final clubs = FirebaseFirestore.instance.collection('clubs');
  final upcoming = FirebaseFirestore.instance.collection('upcoming_sessions');

  static final _shared = UserReviewService._sharedInstance();
  UserReviewService._sharedInstance();
  factory UserReviewService() => _shared;

  Stream<Iterable<Session>> sessionsOfAllClubs() {
    return upcoming.snapshots().map(
          (event) => event.docs.map((e) => Session.fromSnapshot(e)),
        );
  }

  Future<void> giveReview({
    required String text,
    required Session session,
  }) async {
    try {
      if (text.isEmpty) {
        throw CouldNotSendReviewException();
      }
      final documentRef = await FirebaseFirestore.instance
          .collection(
              'clubs/${session.clubId}/sessions/${session.doucmentId}/reviews')
          .add(
        {
          textField: text,
        },
      );

      final uri = Uri.parse('http://10.42.0.173:9000/submit_form');

      final request = {
        clubIdField: session.clubId,
        'session_id': session.doucmentId,
        'review_id': documentRef.id,
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request),
      );

      devtools.log(response.statusCode.toString());
    } catch (_) {
      devtools.log(_.toString());
      throw CouldNotSendReviewException();
    }
  }
}
