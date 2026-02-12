import 'package:cofeenator/ui/widgets/coffeenator_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  group('CoffeenatorButton', () {
    testWidgets('renders label text without icon when no icon is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorButton(
              onTap: () {},
              label: 'Press Me',
            ),
          ),
        ),
      );

      expect(find.text('Press Me'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('renders label and icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorButton(
              onTap: () {},
              label: 'With Icon',
              icon: LineIcons.heartAlt,
            ),
          ),
        ),
      );

      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(LineIcons.heartAlt), findsOneWidget);
    });

    testWidgets('fires onTap callback when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorButton(
              onTap: () => tapped = true,
              label: 'Tap Me',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });
  });
}
