import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/ui/favorites/view/favorites_view.dart';
import 'package:cofeenator/ui/favorites/widgets/favorites_image_list_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_error_widget.dart';
import 'package:cofeenator/ui/widgets/coffeenator_loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalImageListCubit extends MockCubit<LocalImageListState>
    implements LocalImageListCubit {}

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

void main() {
  group('FavoritesView', () {
    late LocalImageListCubit cubit;

    setUp(() {
      cubit = _MockLocalImageListCubit();
    });

    Widget buildSubject() {
      return BlocProvider<LocalImageListCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: Scaffold(body: FavoritesView()),
        ),
      );
    }

    testWidgets(
      'shows spinner when state is Initial',
      (tester) async {
        when(() => cubit.state).thenReturn(LocalImageListStateInitial());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorLoadingSpinner), findsOneWidget);
      },
    );

    testWidgets(
      'shows spinner when state is Loading',
      (tester) async {
        when(() => cubit.state).thenReturn(LocalImageListStateLoading());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorLoadingSpinner), findsOneWidget);
      },
    );

    testWidgets(
      'shows error widget when state is Error',
      (tester) async {
        when(() => cubit.state).thenReturn(LocalImageListStateError());

        await tester.pumpWidget(buildSubject());

        expect(find.byType(CoffeenatorErrorWidget), findsOneWidget);
      },
    );

    testWidgets(
      'shows empty message when state is Loaded with no images',
      (tester) async {
        when(() => cubit.state).thenReturn(LocalImageListStateLoaded([]));

        await tester.pumpWidget(buildSubject());

        expect(
          find.text('Nothing saved yet, go ahead and save some images!'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders image list when state is Loaded with hashes',
      (tester) async {
        final repo = _MockLocalImageRepository();
        when(() => repo.getImage(any())).thenAnswer((_) async => null);
        when(() => cubit.state).thenReturn(
          LocalImageListStateLoaded(['hash1', 'hash2']),
        );

        await tester.pumpWidget(
          RepositoryProvider<LocalImageRepository>.value(
            value: repo,
            child: BlocProvider<LocalImageListCubit>.value(
              value: cubit,
              child: const MaterialApp(
                home: Scaffold(body: FavoritesView()),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(FavoritesImageListWidget), findsOneWidget);
      },
    );
  });
}
