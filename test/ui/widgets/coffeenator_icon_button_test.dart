import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  group('CoffeenatorIconButton', () {
    testWidgets('renders the given icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorIconButton(
              icon: LineIcons.heartAlt,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(LineIcons.heartAlt), findsOneWidget);
    });

    testWidgets('fires onTap callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorIconButton(
              icon: LineIcons.heartAlt,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoffeenatorIconButton));
      expect(tapped, isTrue);
    });

    testWidgets('respects default buttonSize of 50', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorIconButton(
              icon: LineIcons.heartAlt,
              onTap: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CoffeenatorIconButton),
          matching: find.byType(SizedBox).first,
        ),
      );
      expect(sizedBox.width, 50);
      expect(sizedBox.height, 50);
    });

    testWidgets('respects custom buttonSize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoffeenatorIconButton(
              icon: LineIcons.heartAlt,
              onTap: () {},
              buttonSize: 80,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CoffeenatorIconButton),
          matching: find.byType(SizedBox).first,
        ),
      );
      expect(sizedBox.width, 80);
      expect(sizedBox.height, 80);
    });
  });
}
