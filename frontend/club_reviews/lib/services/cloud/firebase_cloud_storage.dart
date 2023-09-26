import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/auth/auth_user.dart';
import 'package:club_reviews/services/cloud/cloud_storage_exceptions.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:intl/intl.dart';

class FirebaseCloudStorage {
  late final String clubId;
  late final String sessionsPath;
  final CollectionReference<Map<String, dynamic>> clubs =
      FirebaseFirestore.instance.collection('clubs');

  static final _shared = FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Stream<Iterable<Session>> pastSessions() {
    return FirebaseFirestore.instance.collection(sessionsPath).snapshots().map(
          (event) =>
              event.docs.where((doc) => doc.data()[stateField] == '2').map(
                    (doc) => Session.fromSnapshot(doc),
                  ),
        );
  }

  Stream<Iterable<Session>> upcomingSessions() {
    return FirebaseFirestore.instance.collection(sessionsPath).snapshots().map(
          (event) =>
              event.docs.where((doc) => doc.data()[stateField] != '2').map(
                    (doc) => Session.fromSnapshot(doc),
                  ),
        );
  }

  Future<Session> createSession({
    required String name,
    required String description,
    required DateTime date,
  }) async {
    try {
      final document =
          await FirebaseFirestore.instance.collection(sessionsPath).add({
        clubId: clubId,
        dateField: DateFormat('DD MMMM YY').format(date),
        nameField: name,
        descriptionField: description,
        tagsField: null,
        stateField: 0,
      });

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
      clubId = AuthService.firebase().currentUser!.id;
      sessionsPath = 'clubs/$clubId';
      await clubs.add({
        nameField: club.name,
        isAdminField: club.isAdmin,
      });
    } catch (_) {
      throw CouldNotCreateClubException();
    }
  }
}
