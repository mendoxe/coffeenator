import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit_state.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/ui/discover/view/discover_view.dart';
import 'package:cofeenator/ui/discover/widgets/discover_image_list_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/mock_image.dart';

class _MockDiscoverImageCubit extends MockCubit<DiscoverImageCubitState>
    implements DiscoverImageCubit {}

class _MockLocalImageListCubit extends MockCubit<LocalImageListState>
    implements LocalImageListCubit {}

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

void main() {
  group('DiscoverView', () {
    final fakeBytes = Uint8List.fromList(fakeImageBytes);

    late DiscoverImageCubit cubit;
    late LocalImageListCubit listCubit;
    late LocalImageRepository localRepo;

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      cubit = _MockDiscoverImageCubit();
      listCubit = _MockLocalImageListCubit();
      localRepo = _MockLocalImageRepository();

      when(() => listCubit.state).thenReturn(LocalImageListStateInitial());
      when(() => localRepo.isImageSaved(any())).thenAnswer((_) async => false);
    });

    Widget buildSubject() {
      return BlocProvider<DiscoverImageCubit>.value(
        value: cubit,
        child: BlocProvider<LocalImageListCubit>.value(
          value: listCubit,
          child: RepositoryProvider<LocalImageRepository>.value(
            value: localRepo,
            child: const MaterialApp(
              home: Scaffold(body: DiscoverView()),
            ),
          ),
        ),
      );
    }

    testWidgets(
      'shows loading spinner when state is Initial',
      (tester) async {
        when(() => cubit.state).thenReturn(DiscoverImageCubitStateInitial());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorLoadingSpinner), findsOneWidget);
      },
    );

    testWidgets('shows swipe label text', (tester) async {
      when(() => cubit.state).thenReturn(DiscoverImageCubitStateInitial());

      await tester.pumpWidget(buildSubject());

      expect(
        find.text('SWIPE TO BROWSE NEXT BLEND'),
        findsOneWidget,
      );
    });

    testWidgets(
      'shows error widget when state is Error with no images',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DiscoverImageCubitStateError('fail', []),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.text('Ups, something went wrong.'), findsOneWidget);
      },
    );

    testWidgets(
      'shows loading spinner when state is Loading with no images',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DiscoverImageCubitStateLoading([]),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorLoadingSpinner), findsAtLeast(1));
      },
    );

    testWidgets(
      'shows DiscoverImageListWidget when state is Loaded with images',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DiscoverImageCubitStateLoaded([fakeBytes]),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(DiscoverImageListWidget), findsOneWidget);
      },
    );

    testWidgets(
      'shows DiscoverImageListWidget with loading when state is Loading '
      'with images',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DiscoverImageCubitStateLoading([fakeBytes]),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(DiscoverImageListWidget), findsOneWidget);
      },
    );

    testWidgets(
      'shows DiscoverImageListWidget with error when state is Error '
      'with images',
      (tester) async {
        when(() => cubit.state).thenReturn(
          DiscoverImageCubitStateError('fail', [fakeBytes]),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(DiscoverImageListWidget), findsOneWidget);
      },
    );
  });
}
