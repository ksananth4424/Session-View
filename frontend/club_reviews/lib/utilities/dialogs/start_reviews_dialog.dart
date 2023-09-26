import 'package:club_reviews/utilities/dialogs/generic_diaglog.dart';
import 'package:flutter/material.dart';

Future<bool> showStartReviewDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Start Reviewing',
    content: 'Are you sure you want to start reviewing?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
