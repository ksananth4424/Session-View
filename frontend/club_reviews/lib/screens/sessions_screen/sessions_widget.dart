import 'package:club_reviews/services/auth/auth_service.dart';
import 'package:club_reviews/services/cloud/session.dart';
import 'package:flutter/material.dart';

class SessionWidget extends StatelessWidget {
  final Session session;
  final String clubName = AuthService.firebase().currentUser!.name;
  final void Function({required Session session}) press;

  SessionWidget({
    super.key,
    required this.session,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(
              color: Color(0xFF545454),
            ),
          ),
          color: const Color(0xFF28292B),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.name,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$clubName • ${session.date}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            session.description,
                            style: Theme.of(context).textTheme.labelMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(session.state == 0
                          ? Icons.arrow_forward
                          : Icons.check),
                      onPressed: () => press(session: session),
                      color: const Color.fromARGB(255, 221, 221, 221),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
