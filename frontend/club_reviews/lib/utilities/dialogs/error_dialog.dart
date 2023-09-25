import 'package:club_reviews/utilities/dialogs/generic_diaglog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String error,
}) {
  return showGenericDialog<void>(
    context: context,
    title: 'An Error Occured',
    content: error,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
