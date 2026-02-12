import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit_state.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/cubit/save_image/save_image_cubit.dart';
import 'package:cofeenator/cubit/save_image/save_image_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/ui/discover/widgets/discover_image_list_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_icon_button.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/mock_image.dart';

class _MockDiscoverImageCubit extends MockCubit<DiscoverImageCubitState> implements DiscoverImageCubit {}

class _MockLocalImageListCubit extends MockCubit<LocalImageListState> implements LocalImageListCubit {}

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

class _MockSaveImageCubit extends MockCubit<SaveImageState> implements SaveImageCubit {}

void main() {
  group('DiscoverImageListWidget', () {
    final fakeBytes = Uint8List.fromList(fakeImageBytes);

    late DiscoverImageCubit discoverCubit;
    late LocalImageListCubit listCubit;
    late LocalImageRepository localRepo;
    late SaveImageCubit saveCubit;

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      discoverCubit = _MockDiscoverImageCubit();
      listCubit = _MockLocalImageListCubit();
      localRepo = _MockLocalImageRepository();
      saveCubit = _MockSaveImageCubit();

      when(() => discoverCubit.state).thenReturn(DiscoverImageCubitStateInitial());
      when(() => discoverCubit.fetchImage()).thenAnswer((_) async => true);
      when(() => listCubit.state).thenReturn(LocalImageListStateInitial());
      when(() => localRepo.isImageSaved(any())).thenAnswer((_) async => false);
    });

    Widget buildSubject({
      List<Uint8List> images = const [],
      String? errorMessage,
      bool isLoading = false,
    }) {
      return BlocProvider<DiscoverImageCubit>.value(
        value: discoverCubit,
        child: BlocProvider<LocalImageListCubit>.value(
          value: listCubit,
          child: RepositoryProvider<LocalImageRepository>.value(
            value: localRepo,
            child: BlocProvider<SaveImageCubit>.value(
              value: saveCubit,
              child: MaterialApp(
                home: Scaffold(
                  body: SizedBox(
                    height: 600,
                    child: DiscoverImageListWidget(
                      images: images,
                      errorMessage: errorMessage,
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets(
      'shows error widget when images empty and has error',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(errorMessage: 'fail'),
        );

        expect(find.byType(CoffeenatorErrorWidget), findsOneWidget);
      },
    );

    testWidgets(
      'shows loading spinner when images empty and isLoading',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(isLoading: true),
        );

        expect(find.byType(CoffeenatorLoadingSpinner), findsOneWidget);
      },
    );

    testWidgets(
      'renders FadingPageView with images',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(images: [fakeBytes]),
        );
        await tester.pump();

        expect(find.byType(PageView), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets(
      'shows spinner at last index when not loading and no error',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(images: [fakeBytes]),
        );
        await tester.pump();

        await tester.drag(find.byType(PageView), const Offset(0, -400));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CoffeenatorLoadingSpinner), findsAtLeast(1));
      },
    );

    testWidgets(
      'shows error at last index when hasError and images present',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(images: [fakeBytes], errorMessage: 'Network error'),
        );
        await tester.pump();

        await tester.drag(find.byType(PageView), const Offset(0, -400));
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(CoffeenatorErrorWidget), findsOneWidget);
      },
    );

    testWidgets(
      'calls fetchImage when reaching last page',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(images: [fakeBytes]),
        );
        await tester.pump();

        await tester.drag(find.byType(PageView), const Offset(0, -400));
        await tester.pump(const Duration(milliseconds: 500));

        verify(() => discoverCubit.fetchImage()).called(1);
      },
    );

    group('DiscoverImageCardWrapper', () {
      testWidgets(
        'image is liked when the like button is pressed',
        (tester) async {
          when(() => saveCubit.saveCurrentImage()).thenAnswer((_) async => true);
          when(() => listCubit.loadAll()).thenAnswer((_) async => {});
          when(() => saveCubit.state).thenReturn(SaveImageStateInitial());

          await tester.pumpWidget(
            BlocProvider<LocalImageListCubit>.value(
              value: listCubit,
              child: BlocProvider<SaveImageCubit>.value(
                value: saveCubit,
                child: MaterialApp(
                  home: Scaffold(body: DiscoverImageCardWrapper(bytes: fakeBytes)),
                ),
              ),
            ),
          );
          await tester.pump();

          final likeButton = find.byType(CoffeenatorIconButton).first;
          await tester.tap(likeButton);
          await tester.pump();

          verify(() => saveCubit.saveCurrentImage()).called(1);
          verify(() => listCubit.loadAll()).called(1);
        },
      );
      testWidgets(
        'image is removed from liked when the dislike button is pressed',
        (tester) async {
          when(() => saveCubit.deleteCurrentImage()).thenAnswer((_) async => true);
          when(() => listCubit.loadAll()).thenAnswer((_) async => {});
          when(() => saveCubit.state).thenReturn(SaveImageStateSaved());

          await tester.pumpWidget(
            BlocProvider<LocalImageListCubit>.value(
              value: listCubit,
              child: BlocProvider<SaveImageCubit>.value(
                value: saveCubit,
                child: MaterialApp(
                  home: Scaffold(body: DiscoverImageCardWrapper(bytes: fakeBytes)),
                ),
              ),
            ),
          );
          await tester.pump();

          final dislikeButton = find.byType(CoffeenatorIconButton).last;
          await tester.tap(dislikeButton);
          await tester.pump();

          verify(() => saveCubit.deleteCurrentImage()).called(1);
          verify(() => listCubit.loadAll()).called(1);
        },
      );
    });
  });
}
