import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/ui/favorites/widgets/favorites_image_card.dart';
import 'package:cofeenator/ui/favorites/widgets/favorites_image_list_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/mock_image.dart';

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

class _MockLocalImageListCubit extends MockCubit<LocalImageListState>
    implements LocalImageListCubit {}

void main() {
  group('FavoritesImageListWidget', () {
    final fakeBytes = Uint8List.fromList(fakeImageBytes);

    late LocalImageRepository repo;
    late LocalImageListCubit listCubit;

    setUp(() {
      repo = _MockLocalImageRepository();
      listCubit = _MockLocalImageListCubit();

      when(() => listCubit.state).thenReturn(
        LocalImageListStateLoaded(['hash1']),
      );
    });

    Widget buildSubject({List<String> hashes = const ['hash1']}) {
      return RepositoryProvider<LocalImageRepository>.value(
        value: repo,
        child: BlocProvider<LocalImageListCubit>.value(
          value: listCubit,
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 600,
                child: FavoritesImageListWidget(imageHashes: hashes),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders FavoritesImageListWidget for the given hash', (
      tester,
    ) async {
      when(() => repo.getImage('hash1')).thenAnswer((_) async => fakeBytes);

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(FavoritesImageListWidget), findsOneWidget);
    });

    testWidgets('shows spinner while image is loading', (tester) async {
      when(() => repo.getImage('hash1')).thenAnswer((_) async => null);

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CoffeenatorLoadingSpinner), findsAtLeast(1));
    });

    testWidgets(
      'shows error widget when LocalImageCubit state is Error',
      (tester) async {
        when(() => repo.getImage('hash1')).thenThrow(Exception('disk error'));

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(CoffeenatorErrorWidget), findsOneWidget);
      },
    );

    testWidgets(
      'shows FavoritesImageCard when image loads successfully',
      (tester) async {
        when(() => repo.getImage('hash1')).thenAnswer((_) async => fakeBytes);

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(FavoritesImageCard), findsOneWidget);
      },
    );

    testWidgets(
      'shows error snackbar when state transitions to Error',
      (tester) async {
        when(
          () => repo.getImage('hash1'),
        ).thenAnswer((_) async => throw Exception('disk error'));

        await tester.pumpWidget(buildSubject());
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('Something went wrong.'), findsOneWidget);
      },
    );

    testWidgets(
      'calls deleteCurrentImage and loadAll on button tap',
      (tester) async {
        when(() => repo.getImage('hash1')).thenAnswer((_) async => fakeBytes);
        when(
          () => repo.deleteImageByHash('hash1'),
        ).thenAnswer((_) async => true);
        when(() => listCubit.loadAll()).thenAnswer((_) async {});

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        final iconButton = find.byType(CoffeenatorIconButton);
        expect(iconButton, findsOneWidget);
        expect(find.byType(FavoritesImageCard), findsOneWidget);

        await tester.tap(iconButton);
        await tester.pump();

        verify(() => repo.deleteImageByHash('hash1')).called(1);
        verify(() => listCubit.loadAll()).called(1);
      },
    );
  });
}
