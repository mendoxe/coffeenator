import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeenatorErrorWidget', () {
    testWidgets('renders error message text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoffeenatorErrorWidget(),
          ),
        ),
      );

      expect(find.text('Ups, something went wrong.'), findsOneWidget);
    });
  });
}
