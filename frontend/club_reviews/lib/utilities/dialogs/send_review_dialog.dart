import 'package:club_reviews/utilities/dialogs/generic_diaglog.dart';
import 'package:flutter/material.dart';

Future<bool> showSendReviewDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Send Review',
    content: 'Are you sure you want to send the review?',
    optionBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
