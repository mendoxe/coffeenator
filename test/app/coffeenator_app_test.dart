import 'package:cofeenator/coffeenator_app.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:cofeenator/theme/coffeenator_theme.dart';
import 'package:cofeenator/ui/discover/discover_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

class _MockRemoteImageRepository extends Mock
    implements RemoteImageRepository {}

void main() {
  group('CoffeenatorApp', () {
    late LocalImageRepository localRepo;
    late RemoteImageRepository remoteRepo;

    setUp(() {
      localRepo = _MockLocalImageRepository();
      remoteRepo = _MockRemoteImageRepository();

      when(() => localRepo.getAllLocalImageHashes()).thenReturn([]);
      when(() => remoteRepo.getImage()).thenAnswer(
        (_) async => throw Exception('no network'),
      );
    });

    Widget buildSubject() {
      return CoffeenatorApp(
        localImageRepository: localRepo,
        remoteImageRepository: remoteRepo,
      );
    }

    testWidgets('renders MaterialApp', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('shows Discover page as home', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('uses CoffeenatorTheme.defaultTheme', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, CoffeenatorTheme.defaultTheme);
    });

    testWidgets('provides LocalImageRepository', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final context = tester.element(find.byType(DiscoverPage));
      expect(
        context.read<LocalImageRepository>(),
        equals(localRepo),
      );
    });

    testWidgets('provides RemoteImageRepository', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final context = tester.element(find.byType(DiscoverPage));
      expect(
        context.read<RemoteImageRepository>(),
        equals(remoteRepo),
      );
    });

    testWidgets('provides LocalImageListCubit', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final context = tester.element(find.byType(DiscoverPage));
      expect(
        context.read<LocalImageListCubit>(),
        isA<LocalImageListCubit>(),
      );
    });

    testWidgets(
      'provides LocalImageListCubit as ancestor',
      (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pump();

        expect(
          find.byWidgetPredicate(
            (w) => w is BlocProvider<LocalImageListCubit>,
          ),
          findsOneWidget,
        );
      },
    );
  });
}
