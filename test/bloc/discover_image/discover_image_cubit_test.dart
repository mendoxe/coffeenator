import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit.dart';
import 'package:cofeenator/cubit/discover_image/discover_image_cubit_state.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteImageRepository extends Mock
    implements RemoteImageRepository {}

void main() {
  group('DiscoverImageCubit', () {
    late RemoteImageRepository repository;

    setUp(() {
      repository = _MockRemoteImageRepository();
    });

    test('initial state is DiscoverImageCubitStateInitial', () {
      final cubit = DiscoverImageCubit(repository);
      expect(cubit.state, isA<DiscoverImageCubitStateInitial>());
      expect(cubit.state.images, isEmpty);
      addTearDown(cubit.close);
    });

    group('fetchImage', () {
      final fakeImage = Uint8List.fromList([1, 2, 3]);

      blocTest<DiscoverImageCubit, DiscoverImageCubitState>(
        'emits [Loading, Loaded] when getImage succeeds',
        setUp: () {
          when(() => repository.getImage()).thenAnswer(
            (_) async => fakeImage,
          );
        },
        build: () => DiscoverImageCubit(repository),
        act: (cubit) => cubit.fetchImage(),
        expect: () => [
          isA<DiscoverImageCubitStateLoading>(),
          isA<DiscoverImageCubitStateLoaded>().having(
            (s) => s.images,
            'images',
            hasLength(1),
          ),
        ],
        verify: (_) {
          verify(() => repository.getImage()).called(1);
        },
      );

      blocTest<DiscoverImageCubit, DiscoverImageCubitState>(
        'emits [Loading, Error] when getImage throws',
        setUp: () {
          when(
            () => repository.getImage(),
          ).thenThrow(Exception('network error'));
        },
        build: () => DiscoverImageCubit(repository),
        act: (cubit) => cubit.fetchImage(),
        expect: () => [
          isA<DiscoverImageCubitStateLoading>(),
          isA<DiscoverImageCubitStateError>().having(
            (s) => s.message,
            'message',
            contains('network error'),
          ),
        ],
      );

      blocTest<DiscoverImageCubit, DiscoverImageCubitState>(
        'accumulates images across multiple successful fetches',
        setUp: () {
          when(() => repository.getImage()).thenAnswer(
            (_) async => fakeImage,
          );
        },
        build: () => DiscoverImageCubit(repository),
        act: (cubit) async {
          await cubit.fetchImage();
          await cubit.fetchImage();
        },
        expect: () => [
          isA<DiscoverImageCubitStateLoading>(),
          isA<DiscoverImageCubitStateLoaded>().having(
            (s) => s.images,
            'images',
            hasLength(1),
          ),
          isA<DiscoverImageCubitStateLoading>().having(
            (s) => s.images,
            'images',
            hasLength(1),
          ),
          isA<DiscoverImageCubitStateLoaded>().having(
            (s) => s.images,
            'images',
            hasLength(2),
          ),
        ],
      );

      blocTest<DiscoverImageCubit, DiscoverImageCubitState>(
        'accumulates images and keeps them even after an error',
        setUp: () {
          var callCount = 0;
          when(() => repository.getImage()).thenAnswer((_) async {
            if (callCount == 0) {
              callCount++;
              return fakeImage;
            }
            throw Exception('Network Error');
          });
        },
        build: () => DiscoverImageCubit(repository),
        act: (cubit) async {
          await cubit.fetchImage();
          await cubit.fetchImage();
        },
        expect: () => [
          isA<DiscoverImageCubitStateLoading>(),
          isA<DiscoverImageCubitStateLoaded>().having(
            (s) => s.images,
            'images',
            hasLength(1),
          ),
          isA<DiscoverImageCubitStateLoading>().having(
            (s) => s.images,
            'images',
            hasLength(1),
          ),
          isA<DiscoverImageCubitStateError>().having(
            (s) => s.images,
            'images',
            hasLength(1),
          ),
        ],
      );
    });
  });
}
