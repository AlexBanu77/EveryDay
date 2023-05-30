import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:hello_world/shared/register_screen.dart';

// Mock http.Client class
class MockClient extends Mock implements http.Client {}

void main() {
  group('RegisterScreen', () {
    late RegisterScreen registerScreen;
    late MockClient mockClient;

    setUp(() {
      // Create a mock client instance
      mockClient = MockClient();

      // Initialize the RegisterScreen with the mock client
      registerScreen = RegisterScreen();
    });
      client = mockClient; // well technically we should have client declared inside the registerscreen class instead of globally but...

    testWidgets('Register screen has a title', (WidgetTester tester) async {
      // Build the register screen widget
      await tester.pumpWidget(MaterialApp(home: registerScreen));

      // Expect to find the app bar title widget with the expected text
      expect(find.text('EveryDay'), findsOneWidget);
    });

    testWidgets('Register screen displays username and password fields',
        (WidgetTester tester) async {
      // Build the register screen widget
      await tester.pumpWidget(MaterialApp(home: registerScreen));

      // Expect to find the username and password text fields
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Confirm Password'), findsOneWidget);
    });

    testWidgets('Register screen validates password match',
        (WidgetTester tester) async {
      // Build the register screen widget
      await tester.pumpWidget(MaterialApp(home: registerScreen));

      // Enter different passwords in the password and confirm password fields
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password1');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password2');

      // Tap the register button
      await tester.tap(find.widgetWithText(GestureDetector, 'REGISTER'));
      await tester.pump();

      // Expect to find an alert dialog with the expected title and content
      expect(find.widgetWithText(AlertDialog, 'Registration Failed'), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, 'Passwords do not match.'), findsOneWidget);
    });

    testWidgets('Register screen successfully registers a user',
        (WidgetTester tester) async {
      // Build the register screen widget
      await tester.pumpWidget(MaterialApp(home: registerScreen));

      // Set up the mock HTTP response for successful registration
      when(mockClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Enter valid values in the username, password, and confirm password fields
      await tester.enterText(find.widgetWithText(TextField, 'Username'), 'testuser');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password');

      // Tap the register button
      await tester.tap(find.widgetWithText(GestureDetector, 'REGISTER'));
      await tester.pump();

      // Expect to find an alert dialog with the expected title and content
      expect(find.widgetWithText(AlertDialog, 'Registration Successful'), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, 'You have successfully registered.'), findsOneWidget);
    });

    testWidgets('Register screen handles user already exists',
        (WidgetTester tester) async {
      // Build the register screen widget
      await tester.pumpWidget(MaterialApp(home: registerScreen));

      // Set up the mock HTTP response for user already exists
      when(mockClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"success": false}', 200));

      // Enter valid values in the username, password, and confirm password fields
      await tester.enterText(find.widgetWithText(TextField, 'Username'), 'existinguser');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password');

      // Tap the register button
      await tester.tap(find.widgetWithText(GestureDetector, 'REGISTER'));
      await tester.pump();

      // Expect to find an alert dialog with the expected title and content
      expect(find.widgetWithText(AlertDialog, 'Registration Failed'), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, 'User already exists!'), findsOneWidget);
    });
  });
}
