import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF545454),
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          return TextButton(
            onPressed: () {
              final T value = options[optionTitle];
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              optionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }).toList(),
      );
    },
  );
}
