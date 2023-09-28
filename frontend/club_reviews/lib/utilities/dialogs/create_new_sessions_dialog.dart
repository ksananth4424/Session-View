import 'package:club_reviews/utilities/dialogs/generic_diaglog.dart';
import 'package:flutter/material.dart';

Future<bool> showCreateSessionDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Create New Session',
    content: 'Are you sure you want to create a new session?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
