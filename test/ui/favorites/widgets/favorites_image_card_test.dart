import 'dart:typed_data';

import 'package:cofeenator/ui/favorites/widgets/favorites_image_card.dart';
import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/mock_image.dart';

void main() {
  group('FavoritesImageCard', () {
    final fakeBytes = Uint8List.fromList(fakeImageBytes);

    testWidgets('renders image from bytes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoritesImageCard(
              bytes: fakeBytes,
              onActionButtonClick: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders heart broken icon button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoritesImageCard(
              bytes: fakeBytes,
              onActionButtonClick: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CoffeenatorIconButton), findsOneWidget);
    });

    testWidgets('fires onActionButtonClick callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoritesImageCard(
              bytes: fakeBytes,
              onActionButtonClick: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoffeenatorIconButton));
      expect(tapped, isTrue);
    });
  });
}
