import 'package:cofeenator/theme/coffeenator_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeenatorTheme', () {
    group('defaultTheme', () {
      late ThemeData theme;

      setUp(() {
        theme = CoffeenatorTheme.defaultTheme;
      });

      test('CoffeenatorTheme.defaultTheme returns a ThemeData instance', () {
        expect(theme, isA<ThemeData>());
      });

      group('appBarTheme', () {
        test('has zero elevation', () {
          expect(theme.appBarTheme.elevation, 0);
        });

        test('has zero scrolledUnderElevation', () {
          expect(theme.appBarTheme.scrolledUnderElevation, 0);
        });

        test('has transparent background', () {
          expect(
            theme.appBarTheme.backgroundColor,
            Colors.transparent,
          );
        });

        test('has white icon color', () {
          expect(
            theme.appBarTheme.iconTheme?.color,
            Colors.white,
          );
        });

        test('has white bold title text style size 32', () {
          final style = theme.appBarTheme.titleTextStyle;
          expect(style?.color, Colors.white);
          expect(style?.fontSize, 32);
          expect(style?.fontWeight, FontWeight.bold);
        });
      });

      test('has correct scaffold background color', () {
        expect(
          theme.scaffoldBackgroundColor,
          const Color(0xff2C1D11),
        );
      });

      group('colorScheme', () {
        test('has correct primary color', () {
          expect(
            theme.colorScheme.primary,
            const Color(0xffee7c2b),
          );
        });

        test('has white onPrimary', () {
          expect(theme.colorScheme.onPrimary, Colors.white);
        });
      });

      group('textTheme', () {
        test('titleLarge is white, bold, size 32', () {
          final style = theme.textTheme.titleLarge;
          expect(style?.color, Colors.white);
          expect(style?.fontSize, 32);
          expect(style?.fontWeight, FontWeight.bold);
        });

        test('bodyLarge is white, size 16', () {
          final style = theme.textTheme.bodyLarge;
          expect(style?.color, Colors.white);
          expect(style?.fontSize, 16);
        });

        test('bodyMedium is white, size 14', () {
          final style = theme.textTheme.bodyMedium;
          expect(style?.color, Colors.white);
          expect(style?.fontSize, 14);
        });

        test('bodySmall is white, size 12', () {
          final style = theme.textTheme.bodySmall;
          expect(style?.color, Colors.white);
          expect(style?.fontSize, 12);
        });

        test('labelMedium is white, size 11', () {
          final style = theme.textTheme.labelMedium;
          expect(style?.color, Colors.white);
          expect(style?.fontSize, 11);
        });
      });
    });
  });
}
