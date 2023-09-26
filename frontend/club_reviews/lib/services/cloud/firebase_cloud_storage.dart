import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/auth/auth_user.dart';
import 'package:club_reviews/services/cloud/cloud_storage_exceptions.dart';
import 'package:club_reviews/services/cloud/session.dart';

class FirebaseCloudStorage {
  late final String clubId;
  late final String sessionsPath;
  final CollectionReference<Map<String, dynamic>> clubs =
      FirebaseFirestore.instance.collection('clubs');

  Future<void> initialize({required AuthUser user}) async {
    clubId = AuthService.firebase().currentUser!.id;
    sessionsPath = 'clubs/$clubId/sessions';

    try {
      await createClub(club: user);
    } catch (_) {}
  }

  static final _shared = FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<void> startReviewing({required Session session}) async {
    try {
      await FirebaseFirestore.instance
          .collection(sessionsPath)
          .doc(session.doucmentId)
          .update({
        stateField: 1,
      });
    } catch (_) {
      throw CouldNotStartReviewsException();
    }
  }

  Future<void> stopReviewing({required Session session}) async {
    try {
      await FirebaseFirestore.instance
          .collection(sessionsPath)
          .doc(session.doucmentId)
          .update({
        stateField: 2,
      });
    } catch (_) {
      throw CouldNotStopReviewsException();
    }
  }

  Stream<Iterable<Session>> allSessions() {
    return FirebaseFirestore.instance.collection(sessionsPath).snapshots().map(
          (event) => event.docs.map(
            (doc) => Session.fromSnapshot(doc),
          ),
        );
  }

  Future<Session> createSession({
    required String name,
    required String description,
    required String date,
  }) async {
    try {
      final document =
          await FirebaseFirestore.instance.collection(sessionsPath).add({
        clubIdField: clubId,
        dateField: date,
        nameField: name,
        descriptionField: description,
        tagsField: null,
        stateField: 0,
      });

      if (name.isEmpty || date.isEmpty || description.isEmpty) {
        throw CouldNotCreateSessionException();
      }

      // dummy
      await document.collection('reviews').add({
        'rating': 5,
        'text': 'good one',
      });
      final sessionSnapshot = await document.get();
      return Session(
        clubId: clubId,
        description: description,
        name: name,
        state: 0,
        tags: null,
        date: date,
        doucmentId: sessionSnapshot.id,
      );
    } catch (_) {
      throw CouldNotCreateSessionException();
    }
  }

  Future<void> deleteSession({required String sessionId}) async {
    try {
      await FirebaseFirestore.instance
          .collection(sessionsPath)
          .doc(sessionId)
          .delete();
    } catch (_) {
      throw CouldNotDeleteSessionException();
    }
  }

  Future<void> createClub({required AuthUser club}) async {
    try {
      await clubs.doc(clubId).set({
        nameField: club.name,
        isAdminField: club.isAdmin,
      });
    } catch (_) {}
  }
}
