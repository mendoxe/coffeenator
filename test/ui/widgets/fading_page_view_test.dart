import 'package:cofeenator/ui/widgets/fading_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FadingPageView', () {
    testWidgets('renders items from itemBuilder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: FadingPageView(
                itemCount: 3,
                itemBuilder: (context, index) => Text('Item $index'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
    });

    testWidgets('calls onPageChanged when swiping', (tester) async {
      var changedToPage = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: FadingPageView(
                itemCount: 3,
                onPageChanged: (page) {
                  changedToPage = page;
                },
                itemBuilder: (context, index) => Center(
                  child: Text('Page $index'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(PageView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(changedToPage, 1);
    });

    testWidgets('calls onPageChanged only when actual page changes, not just random touches', (tester) async {
      var changedToPage = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: FadingPageView(
                itemCount: 3,
                onPageChanged: (page) {
                  changedToPage = page;
                },
                itemBuilder: (context, index) => Center(
                  child: Text('Page $index'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(PageView), const Offset(0, -20));
      await tester.pumpAndSettle();

      expect(changedToPage, -1);
    });

    testWidgets('onPageChanged is called with correct value when swiping up and down', (tester) async {
      var changedToPage = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: FadingPageView(
                itemCount: 3,
                onPageChanged: (page) {
                  changedToPage = page;
                },
                itemBuilder: (context, index) => Center(
                  child: Text('Page $index'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(PageView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(changedToPage, 1);

      await tester.drag(find.byType(PageView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(changedToPage, 2);

      await tester.drag(find.byType(PageView), const Offset(0, 400));
      await tester.pumpAndSettle();

      expect(changedToPage, 1);
    });
  });
}
