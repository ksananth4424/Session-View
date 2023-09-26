import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  const CustomAppBar({
    super.key,
    required this.context,
    required super.preferredSize,
    required super.child,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(preferredSize.height),
      child: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            'Reviews',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        leading: child,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 41, 43),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFF545454), width: 1.0),
        ),
      ),
    );
  }
}
