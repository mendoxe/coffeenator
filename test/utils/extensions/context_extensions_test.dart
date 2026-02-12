import 'package:cofeenator/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SnackBarType', () {
    group('color', () {
      test('info returns null', () {
        expect(SnackBarType.info.color, isNull);
      });

      test('error returns red', () {
        expect(SnackBarType.error.color, Colors.red);
      });

      test('success returns green', () {
        expect(SnackBarType.success.color, Colors.green);
      });
    });
  });

  group('SnackBarX', () {
    group('showSnackBar', () {
      testWidgets('displays snack bar with given message', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.showSnackBar('Test message'),
                    child: const Text('Show'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text('Test message'), findsOneWidget);
      });

      testWidgets('uses floating behavior', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.showSnackBar('Floating test'),
                    child: const Text('Show'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.behavior, SnackBarBehavior.floating);
      });

      testWidgets('applies error color for error type', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.showSnackBar(
                      'Error!',
                      type: SnackBarType.error,
                    ),
                    child: const Text('Show'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, Colors.red);
      });

      testWidgets('applies success color for success type', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.showSnackBar(
                      'Done!',
                      type: SnackBarType.success,
                    ),
                    child: const Text('Show'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, Colors.green);
      });

      testWidgets(
        'hides current snack bar before showing new one',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              context.showSnackBar('First message'),
                          child: const Text('First'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              context.showSnackBar('Second message'),
                          child: const Text('Second'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );

          await tester.tap(find.text('First'));
          await tester.pumpAndSettle();
          expect(find.text('First message'), findsOneWidget);

          await tester.tap(find.text('Second'));
          await tester.pumpAndSettle();
          expect(find.text('Second message'), findsOneWidget);
          expect(find.text('First message'), findsNothing);
        },
      );
    });

    group('navigateToPage', () {
      testWidgets('pushes a new page onto the navigator', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => context.navigateToPage<Widget>(
                      const Scaffold(body: Text('New Page')),
                    ),
                    child: const Text('Navigate'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('New Page'), findsOneWidget);
        expect(find.text('Navigate'), findsNothing);
      });
    });
  });
}
