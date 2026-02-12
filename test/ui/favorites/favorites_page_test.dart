import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/ui/favorites/favorites_page.dart';
import 'package:cofeenator/ui/favorites/view/favorites_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalImageListCubit extends MockCubit<LocalImageListState> implements LocalImageListCubit {}

void main() {
  group('FavoritesPage', () {
    late LocalImageListCubit cubit;

    setUp(() {
      cubit = _MockLocalImageListCubit();
      when(() => cubit.state).thenReturn(LocalImageListStateInitial());
    });

    Widget buildSubject() {
      return BlocProvider<LocalImageListCubit>.value(
        value: cubit,
        child: const MaterialApp(
          home: FavoritesPage(),
        ),
      );
    }

    testWidgets('renders AppBar with Favorites title', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('renders FavoritesView', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(FavoritesView), findsOneWidget);
    });
  });
}
