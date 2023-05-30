//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/shared/events_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:hello_world/shared/event_display_screen.dart';


class MockClient extends Mock implements http.Client {}

void main() {
  group('DisplayEvents', () {
    MockClient mockClient;
    DisplayEvents displayEvents;

    setUp(() {
      mockClient = MockClient();
      displayEvents = DisplayEvents();
    });

    testWidgets('Displays event details and deletes event', (WidgetTester tester) async {
      // Mock a response for the getAll request
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('''
        [
          {
            "id": 1,
            "date": "2022-01-01",
            "organizer": "Organizer 1",
            "location": "Location 1",
            "latitude": 0.0,
            "longitude": 0.0
          },
          {
            "id": 2,
            "date": "2022-02-02",
            "organizer": "Organizer 2",
            "location": "Location 2",
            "latitude": 0.0,
            "longitude": 0.0
          }
        ]
      ''', 200));

      await tester.pumpWidget(MaterialApp(home: displayEvents));

      // Ensure that there are two ListTile widgets initially
      expect(find.byType(ListTile), findsNWidgets(2));

      // Mock a response for the delete request
      when(mockClient.delete(any)).thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Tap the delete button on the first ListTile
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Ensure that there is only one ListTile left
      expect(find.byType(ListTile), findsOneWidget);
    });
  });
}
