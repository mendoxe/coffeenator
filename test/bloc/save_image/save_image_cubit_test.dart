import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/save_image/save_image_cubit.dart';
import 'package:cofeenator/cubit/save_image/save_image_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

void main() {
  group('SaveImageCubit', () {
    late LocalImageRepository repository;
    final fakeImage = Uint8List.fromList([10, 20, 30]);

    setUp(() {
      repository = _MockLocalImageRepository();
    });

    test('initial state is SaveImageStateInitial', () {
      final cubit = SaveImageCubit(
        repository,
        imageBytes: fakeImage,
      );
      expect(cubit.state, isA<SaveImageStateInitial>());
      addTearDown(cubit.close);
    });

    group('checkIfImageSaved', () {
      blocTest<SaveImageCubit, SaveImageState>(
        'emits [Saved] when image is already saved',
        setUp: () {
          when(() => repository.isImageSaved(fakeImage)).thenAnswer(
            (_) async => true,
          );
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.checkIfImageSaved(),
        expect: () => [
          isA<SaveImageStateSaved>(),
        ],
      );

      blocTest<SaveImageCubit, SaveImageState>(
        'emits nothing and stays in initial state when image is not saved',
        setUp: () {
          when(() => repository.isImageSaved(fakeImage)).thenAnswer(
            (_) async => false,
          );
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.checkIfImageSaved(),
        expect: () => <SaveImageState>[],
        verify: (cubit) {
          expect(cubit.state, isA<SaveImageStateInitial>());
          verify(() => repository.isImageSaved(fakeImage)).called(1);
        },
      );

      blocTest<SaveImageCubit, SaveImageState>(
        'emits nothing and stays in initial state when check throws (silently caught)',
        setUp: () {
          when(
            () => repository.isImageSaved(fakeImage),
          ).thenThrow(Exception('error'));
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.checkIfImageSaved(),
        expect: () => <SaveImageState>[],
        verify: (cubit) {
          expect(cubit.state, isA<SaveImageStateInitial>());
          verify(() => repository.isImageSaved(fakeImage)).called(1);
        },
      );
    });

    group('saveCurrentImage', () {
      blocTest<SaveImageCubit, SaveImageState>(
        'emits [Loading, Saved] on success',
        setUp: () {
          when(() => repository.saveImage(fakeImage)).thenAnswer(
            (_) async {},
          );
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.saveCurrentImage(),
        expect: () => [
          isA<SaveImageStateLoading>(),
          isA<SaveImageStateSaved>(),
        ],
      );

      blocTest<SaveImageCubit, SaveImageState>(
        'emits [Loading, Error] when save throws',
        setUp: () {
          when(
            () => repository.saveImage(fakeImage),
          ).thenThrow(Exception('save failed'));
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.saveCurrentImage(),
        expect: () => [
          isA<SaveImageStateLoading>(),
          isA<SaveImageStateError>().having(
            (s) => s.message,
            'message',
            contains('save failed'),
          ),
        ],
      );
      test('returns true on successful save', () async {
        when(() => repository.saveImage(fakeImage)).thenAnswer(
          (_) async {},
        );

        final cubit = SaveImageCubit(repository, imageBytes: fakeImage);
        final result = await cubit.saveCurrentImage();

        expect(result, isTrue);
        addTearDown(cubit.close);
      });

      test('returns false when save throws', () async {
        when(
          () => repository.saveImage(fakeImage),
        ).thenThrow(Exception('fail'));

        final cubit = SaveImageCubit(repository, imageBytes: fakeImage);
        final result = await cubit.saveCurrentImage();

        expect(result, isFalse);
        addTearDown(cubit.close);
      });
    });

    group('deleteCurrentImage', () {
      blocTest<SaveImageCubit, SaveImageState>(
        'emits [Loading, Initial] on success',
        setUp: () {
          when(() => repository.deleteImage(fakeImage)).thenAnswer(
            (_) async => true,
          );
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.deleteCurrentImage(),
        expect: () => [
          isA<SaveImageStateLoading>(),
          isA<SaveImageStateInitial>(),
        ],
      );

      blocTest<SaveImageCubit, SaveImageState>(
        'emits [Loading, Error] when delete throws',
        setUp: () {
          when(
            () => repository.deleteImage(fakeImage),
          ).thenThrow(Exception('delete failed'));
        },
        build: () => SaveImageCubit(
          repository,
          imageBytes: fakeImage,
        ),
        act: (cubit) => cubit.deleteCurrentImage(),
        expect: () => [
          isA<SaveImageStateLoading>(),
          isA<SaveImageStateError>().having(
            (s) => s.message,
            'message',
            contains('delete failed'),
          ),
        ],
      );

      test('returns true on successful delete', () async {
        when(() => repository.deleteImage(fakeImage)).thenAnswer(
          (_) async => true,
        );

        final cubit = SaveImageCubit(repository, imageBytes: fakeImage);
        final result = await cubit.deleteCurrentImage();

        expect(result, isTrue);
        addTearDown(cubit.close);
      });

      test('returns false when delete throws', () async {
        when(
          () => repository.deleteImage(fakeImage),
        ).thenThrow(Exception('fail'));

        final cubit = SaveImageCubit(repository, imageBytes: fakeImage);
        final result = await cubit.deleteCurrentImage();

        expect(result, isFalse);
        addTearDown(cubit.close);
      });
    });
  });
}
