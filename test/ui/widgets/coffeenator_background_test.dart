import 'package:cofeenator/ui/widgets/coffeenator_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeenatorBackground', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoffeenatorBackground(
            child: Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('uses scaffold background color from theme', (tester) async {
      const bgColor = Color(0xFF123456);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: bgColor),
          home: const CoffeenatorBackground(
            child: SizedBox.shrink(),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(CoffeenatorBackground),
          matching: find.byType(Material).first,
        ),
      );
      expect(material.color, bgColor);
    });
  });
}
