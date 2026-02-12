import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/local_image/local_image_cubit.dart';
import 'package:cofeenator/cubit/local_image/local_image_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

void main() {
  group('LocalImageCubit', () {
    late LocalImageRepository repository;
    const testHash = 'test-hash-123';
    final fakeImage = Uint8List.fromList([10, 20, 30]);

    setUp(() {
      repository = _MockLocalImageRepository();
    });

    test('initial state is LocalImageStateInitial', () {
      final cubit = LocalImageCubit(
        repository,
        imageHash: testHash,
      );
      expect(cubit.state, isA<LocalImageStateInitial>());
      addTearDown(cubit.close);
    });

    group('loadImage', () {
      blocTest<LocalImageCubit, LocalImageState>(
        'emits [Loading, Loaded] when image is found',
        setUp: () {
          when(() => repository.getImage(testHash)).thenAnswer(
            (_) async => fakeImage,
          );
        },
        build: () => LocalImageCubit(
          repository,
          imageHash: testHash,
        ),
        act: (cubit) => cubit.loadImage(),
        expect: () => [
          isA<LocalImageStateLoading>(),
          isA<LocalImageStateLoaded>().having((s) => s.bytes, 'bytes', equals(fakeImage)),
        ],
      );

      blocTest<LocalImageCubit, LocalImageState>(
        'emits [Loading, Error] when image is null',
        setUp: () {
          when(() => repository.getImage(testHash)).thenAnswer(
            (_) async => null,
          );
        },
        build: () => LocalImageCubit(
          repository,
          imageHash: testHash,
        ),
        act: (cubit) => cubit.loadImage(),
        expect: () => [
          isA<LocalImageStateLoading>(),
          isA<LocalImageStateError>().having((s) => s.message, 'message', 'Failed to load image'),
        ],
      );

      blocTest<LocalImageCubit, LocalImageState>(
        'emits [Loading, Error] when repository throws',
        setUp: () {
          when(() => repository.getImage(testHash)).thenThrow(Exception('disk error'));
        },
        build: () => LocalImageCubit(
          repository,
          imageHash: testHash,
        ),
        act: (cubit) => cubit.loadImage(),
        expect: () => [
          isA<LocalImageStateLoading>(),
          isA<LocalImageStateError>().having(
            (s) => s.message,
            'message',
            'An error occured while loading image',
          ),
        ],
      );
    });

    group('deleteCurrentImage', () {
      blocTest<LocalImageCubit, LocalImageState>(
        'emits [Loading, Initial] on success',
        setUp: () {
          when(() => repository.deleteImageByHash(testHash)).thenAnswer(
            (_) async => true,
          );
        },
        build: () => LocalImageCubit(
          repository,
          imageHash: testHash,
        ),
        act: (cubit) => cubit.deleteCurrentImage(),
        expect: () => [
          isA<LocalImageStateLoading>(),
          isA<LocalImageStateInitial>(),
        ],
      );

      blocTest<LocalImageCubit, LocalImageState>(
        'emits [Loading, Error] on failure',
        setUp: () {
          when(() => repository.deleteImageByHash(testHash)).thenThrow(Exception('delete failed'));
        },
        build: () => LocalImageCubit(
          repository,
          imageHash: testHash,
        ),
        act: (cubit) => cubit.deleteCurrentImage(),
        expect: () => [
          isA<LocalImageStateLoading>(),
          isA<LocalImageStateError>().having((s) => s.message, 'message', 'Failed to delete image'),
        ],
      );

      test('returns true on successful delete', () async {
        when(() => repository.deleteImageByHash(testHash)).thenAnswer(
          (_) async => true,
        );

        final cubit = LocalImageCubit(repository, imageHash: testHash);
        final result = await cubit.deleteCurrentImage();

        expect(result, isTrue);
        addTearDown(cubit.close);
      });

      test('returns false when delete throws', () async {
        when(() => repository.deleteImageByHash(testHash)).thenThrow(Exception('fail'));

        final cubit = LocalImageCubit(repository, imageHash: testHash);
        final result = await cubit.deleteCurrentImage();

        expect(result, isFalse);
        addTearDown(cubit.close);
      });
    });
  });
}
