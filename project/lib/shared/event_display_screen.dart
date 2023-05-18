import 'package:flutter/material.dart';

class Event {
  final DateTime date;
  final String organizer;
  final String location;

  Event({required this.date, required this.organizer, required this.location});
}

class EventDisplay extends StatelessWidget {
  final Event event;

  EventDisplay({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date: ${event.date}'),
        Text('Organizer: ${event.organizer}'),
        Text('Location: ${event.location}'),
      ],
    );
  }
}