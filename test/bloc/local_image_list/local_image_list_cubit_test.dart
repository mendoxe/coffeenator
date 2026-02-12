import 'package:bloc_test/bloc_test.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_cubit.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalImageRepository extends Mock implements LocalImageRepository {}

void main() {
  group('LocalImageListCubit', () {
    late LocalImageRepository repository;

    setUp(() {
      repository = _MockLocalImageRepository();
    });

    test('initial state is LocalImageListStateInitial', () {
      final cubit = LocalImageListCubit(repository);
      expect(cubit.state, isA<LocalImageListStateInitial>());
      addTearDown(cubit.close);
    });

    group('loadAll', () {
      blocTest<LocalImageListCubit, LocalImageListState>(
        'emits [Loading, Loaded] with hashes on success',
        setUp: () {
          when(
            () => repository.getAllLocalImageHashes(),
          ).thenReturn(['hash1', 'hash2']);
        },
        build: () => LocalImageListCubit(repository),
        act: (cubit) => cubit.loadAll(),
        expect: () => [
          isA<LocalImageListStateLoading>(),
          isA<LocalImageListStateLoaded>().having(
            (s) => s.imageHashes,
            'imageHashes',
            equals(['hash1', 'hash2']),
          ),
        ],
      );

      blocTest<LocalImageListCubit, LocalImageListState>(
        'emits [Loading, Loaded] with empty list when no images exist',
        setUp: () {
          when(() => repository.getAllLocalImageHashes()).thenReturn([]);
        },
        build: () => LocalImageListCubit(repository),
        act: (cubit) => cubit.loadAll(),
        expect: () => [
          isA<LocalImageListStateLoading>(),
          isA<LocalImageListStateLoaded>().having(
            (s) => s.imageHashes,
            'imageHashes',
            isEmpty,
          ),
        ],
      );

      blocTest<LocalImageListCubit, LocalImageListState>(
        'emits [Loading, Error] when repository throws',
        setUp: () {
          when(
            () => repository.getAllLocalImageHashes(),
          ).thenThrow(Exception('hive error'));
        },
        build: () => LocalImageListCubit(repository),
        act: (cubit) => cubit.loadAll(),
        expect: () => [
          isA<LocalImageListStateLoading>(),
          isA<LocalImageListStateError>(),
        ],
      );
    });
  });
}
