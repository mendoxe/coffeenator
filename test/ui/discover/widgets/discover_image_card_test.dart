import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/save_image/save_image_cubit.dart';
import 'package:cofeenator/cubit/save_image/save_image_state.dart';
import 'package:cofeenator/ui/discover/widgets/discover_image_card.dart';
import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/mock_image.dart';

class _MockSaveImageCubit extends MockCubit<SaveImageState> implements SaveImageCubit {}

void main() {
  group('DiscoverImageCard', () {
    late SaveImageCubit saveImageCubit;
    final fakeBytes = Uint8List.fromList(fakeImageBytes);

    setUp(() {
      saveImageCubit = _MockSaveImageCubit();
    });

    Widget buildSubject({
      VoidCallback? onLiked,
      VoidCallback? onDisliked,
    }) {
      return BlocProvider<SaveImageCubit>.value(
        value: saveImageCubit,
        child: MaterialApp(
          home: Scaffold(
            body: DiscoverImageCard(
              bytes: fakeBytes,
              onLiked: onLiked ?? () {},
              onDisliked: onDisliked ?? () {},
            ),
          ),
        ),
      );
    }

    testWidgets(
      'shows heart button when state is Initial',
      (tester) async {
        when(() => saveImageCubit.state).thenReturn(SaveImageStateInitial());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorIconButton), findsOneWidget);
      },
    );

    testWidgets(
      'shows spinner when state is Loading',
      (tester) async {
        when(() => saveImageCubit.state).thenReturn(SaveImageStateLoading());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorLoadingSpinner), findsOneWidget);
      },
    );

    testWidgets(
      'shows broken heart button when state is Saved',
      (tester) async {
        when(() => saveImageCubit.state).thenReturn(SaveImageStateSaved());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorIconButton), findsOneWidget);
      },
    );

    testWidgets('renders image from bytes', (tester) async {
      when(() => saveImageCubit.state).thenReturn(SaveImageStateInitial());

      await tester.pumpWidget(buildSubject());

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
      'shows error snackbar when state transitions to Error',
      (tester) async {
        when(() => saveImageCubit.state).thenReturn(SaveImageStateInitial());
        whenListen(
          saveImageCubit,
          Stream.fromIterable([
            SaveImageStateLoading(),
            SaveImageStateError('fail'),
          ]),
          initialState: SaveImageStateInitial(),
        );

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.text('Something went wrong.'), findsOneWidget);
      },
    );
  });
}
