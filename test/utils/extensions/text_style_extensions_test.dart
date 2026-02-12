import 'package:cofeenator/utils/extensions/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextStyleExtensions', () {
    group('on non-null TextStyle', () {
      const baseStyle = TextStyle(fontSize: 4, color: Colors.black);
      test('bold returns style with FontWeight.bold', () {
        expect(baseStyle.bold?.fontWeight, FontWeight.bold);
      });

      test('w700 returns style with FontWeight.w700', () {
        expect(baseStyle.w700?.fontWeight, FontWeight.w700);
      });

      test('w600 returns style with FontWeight.w600', () {
        expect(baseStyle.w600?.fontWeight, FontWeight.w600);
      });

      test('w500 returns style with FontWeight.w500', () {
        expect(baseStyle.w500?.fontWeight, FontWeight.w500);
      });

      test('w400 returns style with FontWeight.w400', () {
        expect(baseStyle.w400?.fontWeight, FontWeight.w400);
      });

      test('w300 returns style with FontWeight.w300', () {
        expect(baseStyle.w300?.fontWeight, FontWeight.w300);
      });

      test('preserves other properties', () {
        final result = baseStyle.bold;
        expect(result?.fontSize, 4);
        expect(result?.color, Colors.black);
      });
    });

    group('on null TextStyle', () {
      const TextStyle? nullStyle = null;

      test('bold returns null', () {
        expect(nullStyle.bold, isNull);
      });

      test('w700 returns null', () {
        expect(nullStyle.w700, isNull);
      });

      test('w600 returns null', () {
        expect(nullStyle.w600, isNull);
      });

      test('w500 returns null', () {
        expect(nullStyle.w500, isNull);
      });

      test('w400 returns null', () {
        expect(nullStyle.w400, isNull);
      });

      test('w300 returns null', () {
        expect(nullStyle.w300, isNull);
      });
    });
  });
}
