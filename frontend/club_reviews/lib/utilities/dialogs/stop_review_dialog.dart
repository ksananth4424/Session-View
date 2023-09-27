import 'package:club_reviews/utilities/dialogs/generic_diaglog.dart';
import 'package:flutter/material.dart';

Future<bool> showStopReviewDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Stop Reviewing',
    content: 'Are you sure you want to stop reviewing?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
