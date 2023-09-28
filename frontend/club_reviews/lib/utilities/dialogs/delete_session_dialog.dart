import 'package:club_reviews/utilities/dialogs/generic_diaglog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteSessionDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete the Session',
    content: 'Are you sure you want to delete the session?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
