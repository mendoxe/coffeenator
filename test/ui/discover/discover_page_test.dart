import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:cofeenator/ui/discover/discover_page.dart';
import 'package:cofeenator/ui/favorites/view/favorites_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/mock_image.dart';

class _MockRemoteImageRepository extends Mock
    implements RemoteImageRepository {}

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

class _MockLocalImageListCubit extends MockCubit<LocalImageListState>
    implements LocalImageListCubit {}

void main() {
  group('DiscoverPage', () {
    final fakeBytes = Uint8List.fromList(fakeImageBytes);

    late RemoteImageRepository remoteRepo;
    late LocalImageRepository localRepo;
    late LocalImageListCubit localImageListCubit;

    setUp(() {
      remoteRepo = _MockRemoteImageRepository();
      localRepo = _MockLocalImageRepository();
      localImageListCubit = _MockLocalImageListCubit();

      when(() => remoteRepo.getImage()).thenAnswer((_) async => fakeBytes);
      when(
        () => localImageListCubit.state,
      ).thenReturn(LocalImageListStateInitial());
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<RemoteImageRepository>.value(value: remoteRepo),
          RepositoryProvider<LocalImageRepository>.value(value: localRepo),
        ],
        child: BlocProvider<LocalImageListCubit>.value(
          value: localImageListCubit,
          child: const MaterialApp(
            home: DiscoverPage(),
          ),
        ),
      );
    }

    testWidgets('renders AppBar with Discover title', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('renders Favorites button in AppBar', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('tapping Favorites navigates to FavoritesPage', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FavoritesView), findsOneWidget);
    });
  });
}
