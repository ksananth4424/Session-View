// ignore_for_file: use_build_context_synchronously

import 'package:club_reviews/services/cloud/firebase_cloud_storage.dart';
import 'package:club_reviews/utilities/custom_appbar.dart';
import 'package:club_reviews/utilities/custom_text_field.dart';
import 'package:club_reviews/utilities/dialogs/create_new_sessions_dialog.dart';
import 'package:club_reviews/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class CreateNewSession extends StatefulWidget {
  const CreateNewSession({super.key});

  @override
  State<CreateNewSession> createState() => _CreateNewSessionState();
}

class _CreateNewSessionState extends State<CreateNewSession> {
  late final TextEditingController _name;
  late final TextEditingController _date;
  late final TextEditingController _description;
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _name = TextEditingController();
    _date = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  Future<void> createSession() async {
    final name = _name.text;
    final description = _description.text;
    final date = _date.text;

    try {
      final shouldCreateSession = await showCreateSessionDialog(context);
      if (!shouldCreateSession) {
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      await _cloudStorage.createSession(
        name: name,
        description: description,
        date: date,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (_) {
      Navigator.of(context).pop();
      showErrorDialog(
        context: context,
        error: 'An error Ocurred',
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _date.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        preferredSize: const Size.fromHeight(70),
        child: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            color: const Color.fromARGB(255, 221, 221, 221),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF28292B),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          right: 20,
          left: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Create New Session',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                title: 'name',
                controller: _name,
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                title: 'date',
                controller: _date,
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                title: 'description',
                controller: _description,
                maxLines: 8,
              ),
              const SizedBox(height: 100),
              OutlinedButton.icon(
                icon: const Icon(
                  Icons.check,
                  color: Color(0xFF00D0FE),
                ),
                label: Text(
                  'Create',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () async {
                  await createSession();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
