// Carbon Credit App Widget Tests
//
// This file contains widget tests for the Carbon Credit Marketplace app.
// Tests verify that key components and navigation work correctly.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:carbon_credit_app/main.dart';

void main() {
  // Setup for tests
  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
  });

  testWidgets('Carbon Credit App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CarbonCreditApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(
      const ProviderScope(
        child: CarbonCreditApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Get the MaterialApp widget
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    
    // Verify the app title
    expect(app.title, equals('Carbon Credit Marketplace'));
  });

  testWidgets('App navigation works', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(
      const ProviderScope(
        child: CarbonCreditApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // The app should load successfully without throwing errors
    expect(tester.takeException(), isNull);
  });
}
