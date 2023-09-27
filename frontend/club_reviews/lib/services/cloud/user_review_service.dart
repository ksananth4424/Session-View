import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/cloud/cloud_storage_exceptions.dart';
import 'package:club_reviews/services/cloud/session.dart';

class UserReviewService {
  final userId = AuthService.firebase().currentUser!;
  final clubs = FirebaseFirestore.instance.collection('clubs');

  static final _shared = UserReviewService._sharedInstance();
  UserReviewService._sharedInstance();
  factory UserReviewService() => _shared;

  // Stream<Iterable<Session>> sessionsOfAllClubs() {}

  Future<void> giveReview({
    required String text,
    required Session session,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'clubs/${session.clubId}/sessions/${session.doucmentId}/reviews')
          .add({textField: text});
    } catch (_) {
      throw CouldNotGiveReviewException();
    }
  }
}
