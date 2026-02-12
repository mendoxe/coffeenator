import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeenatorLoadingSpinner', () {
    testWidgets(
      'renders CircularProgressIndicator with background color as primary color from ColorScheme',
      (tester) async {
        const expectedSpinnerColor = Colors.orange;
        final theme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
          ).copyWith(primary: expectedSpinnerColor),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(
              body: CoffeenatorLoadingSpinner(),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        final progressIndicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );

        expect(
          progressIndicator.backgroundColor,
          expectedSpinnerColor,
        );
      },
    );
  });
}
