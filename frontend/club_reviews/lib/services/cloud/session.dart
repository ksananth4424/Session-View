import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:flutter/material.dart';

@immutable
class Session {
  final String doucmentId;
  final String clubId;
  final String name;
  final String description;
  final DateTime date;
  final Map<String, dynamic>? tags;
  final int state;

  const Session({
    required this.doucmentId,
    required this.clubId,
    required this.name,
    required this.description,
    required this.date,
    required this.tags,
    required this.state,
  });

  factory Session.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Session(
      doucmentId: snapshot.id,
      clubId: snapshot.data()[clubIdField],
      name: snapshot.data()[nameField],
      description: snapshot.data()[descriptionField],
      date: snapshot.data()[dateField],
      tags: snapshot.data()[tagsField],
      state: snapshot.data()[stateField],
    );
  }
}
