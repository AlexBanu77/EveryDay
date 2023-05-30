// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:hello_world/shared/login_screen.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('LoginScreen', () {
    MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    testWidgets('login - successful', (WidgetTester tester) async {
      when(mockHttpClient.post(any, body: anyNamed('body'))).thenAnswer((_) async =>
          http.Response(jsonEncode(true), 200));

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.enterText(find.byKey(Key('usernameTextField')), 'testuser');
      await tester.enterText(find.byKey(Key('passwordTextField')), 'password');
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle();

      verify(mockHttpClient.post(
        Uri.parse('http://192.168.172.24:5001/users/'),
        body: {
          'username': 'testuser',
          'password': 'password',
        },
      )).called(1);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Credentials not valid.'), findsNothing);
      expect(find.text('Events Screen'), findsOneWidget);
    });

    testWidgets('login - unsuccessful', (WidgetTester tester) async {
      when(mockHttpClient.post(any, body: anyNamed('body'))).thenAnswer((_) async =>
          http.Response(jsonEncode(false), 200));

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.enterText(find.byKey(Key('usernameTextField')), 'testuser');
      await tester.enterText(find.byKey(Key('passwordTextField')), 'password');
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle();

      verify(mockHttpClient.post(
        Uri.parse('http://192.168.172.24:5001/users/'),
        body: {
          'username': 'testuser',
          'password': 'password',
        },
      )).called(1);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Credentials not valid.'), findsOneWidget);
      expect(find.text('Events Screen'), findsNothing);
    });
  });
}
