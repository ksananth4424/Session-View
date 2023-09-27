import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/auth/auth_user.dart';
import 'package:club_reviews/services/cloud/cloud_storage_exceptions.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as devtools show log;

class FirebaseCloudStorage {
  late String clubId;
  late String sessionsPath;
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

      await FirebaseFirestore.instance
          .collection('upcoming_sessions')
          .doc(session.doucmentId)
          .set(
        {
          clubIdField: session.clubId,
          nameField: session.name,
          descriptionField: session.description,
          dateField: session.date,
          stateField: 1,
          tagsField: {
            managementField: 0,
            topicLevelField: 0,
            beginnerFriendlyField: 0,
            lengthField: 0,
            informativeField: 0,
          },
        },
      );
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
        stateField: 3,
      });

      await FirebaseFirestore.instance
          .collection('upcoming_sessions')
          .doc(session.doucmentId)
          .delete();

      final uri = Uri.parse(
        'http://10.42.0.173:9000/stop',
      );

      final request = {
        clubIdField: session.clubId,
        'session_id': session.doucmentId,
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request),
      );

      devtools.log(response.statusCode.toString());
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
        tagsField: {
          managementField: 0,
          topicLevelField: 0,
          beginnerFriendlyField: 0,
          lengthField: 0,
          informativeField: 0,
        },
        stateField: 0,
      });

      if (name.isEmpty || date.isEmpty || description.isEmpty) {
        throw CouldNotCreateSessionException();
      }

      final sessionSnapshot = await document.get();
      return Session(
        clubId: clubId,
        description: description,
        name: name,
        state: 0,
        tags: const {
          managementField: 0,
          topicLevelField: 0,
          beginnerFriendlyField: 0,
          lengthField: 0,
          informativeField: 0,
        },
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
        isAdminField: true,
      });
    } catch (_) {}
  }
}
