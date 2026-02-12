import 'dart:io';
import 'dart:typed_data';

import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockBox extends Mock implements Box<String> {}

class _FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  _FakePathProviderPlatform(this.tempDir);
  final String tempDir;

  @override
  Future<String?> getApplicationDocumentsPath() async => tempDir;
}

void main() {
  group('LocalImageRepository', () {
    final originalPlatform = PathProviderPlatform.instance;

    late Box<String> box;
    late LocalImageRepository repository;
    late Directory tempDir;
    late Uint8List fakeImage;
    late String expectedHash;

    setUpAll(() {
      fakeImage = Uint8List.fromList([10, 20, 30, 40, 50]);
      expectedHash = sha256.convert(fakeImage).toString();
    });

    setUp(() async {
      box = _MockBox();
      tempDir = await Directory.systemTemp.createTemp('local_image_repo_test');
      PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);
      repository = LocalImageRepository(box);
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      PathProviderPlatform.instance = originalPlatform;
    });

    group('isImageHashSaved', () {
      test('returns true when hash exists in box', () {
        when(() => box.containsKey('abc123')).thenReturn(true);

        expect(repository.isImageHashSaved('abc123'), isTrue);
        verify(() => box.containsKey('abc123')).called(1);
      });

      test('returns false when hash does not exist in box', () {
        when(() => box.containsKey('abc123')).thenReturn(false);

        expect(repository.isImageHashSaved('abc123'), isFalse);
        verify(() => box.containsKey('abc123')).called(1);
      });
    });

    group('isImageSaved', () {
      test('returns true when hash of the image is in box', () async {
        when(() => box.containsKey(expectedHash)).thenReturn(true);

        final result = await repository.isImageSaved(fakeImage);

        expect(result, isTrue);
        verify(() => box.containsKey(expectedHash)).called(1);
      });

      test('returns false when hash of the image is not in box', () async {
        when(() => box.containsKey(expectedHash)).thenReturn(false);

        final result = await repository.isImageSaved(fakeImage);

        expect(result, isFalse);
      });
    });

    group('getAllLocalImageHashes', () {
      test('returns all values from box', () {
        when(() => box.values).thenReturn(['hash1', 'hash2', 'hash3']);

        final result = repository.getAllLocalImageHashes();

        expect(result, equals(['hash1', 'hash2', 'hash3']));
      });

      test('returns empty list when box is empty', () {
        when(() => box.values).thenReturn([]);

        final result = repository.getAllLocalImageHashes();

        expect(result, isEmpty);
      });
    });

    group('getImage', () {
      test('returns null when hash is not in box', () async {
        when(() => box.containsKey('missing')).thenReturn(false);

        final result = await repository.getImage('missing');

        expect(result, isNull);
      });

      test('returns null when hash is in box but file missing on disk', () async {
        when(() => box.containsKey('noLocalFile')).thenReturn(true);

        final result = await repository.getImage('noLocalFile');

        expect(result, isNull);
      });

      test('returns bytes when hash is in box and file exists on disk', () async {
        final filePath = '${tempDir.path}/ondisk';
        await File(filePath).writeAsBytes(fakeImage);

        when(() => box.containsKey('ondisk')).thenReturn(true);

        final result = await repository.getImage('ondisk');

        expect(result, equals(fakeImage));
      });
    });

    group('saveImage', () {
      test('saves image to disk and hash to box', () async {
        when(() => box.containsKey(expectedHash)).thenReturn(false);
        when(() => box.put(expectedHash, expectedHash)).thenAnswer((_) async {});

        await repository.saveImage(fakeImage);

        final file = File('${tempDir.path}/$expectedHash');
        expect(file.existsSync(), isTrue);
        expect(await file.readAsBytes(), equals(fakeImage));

        verify(() => box.put(expectedHash, expectedHash)).called(1);
      });

      test('skips saving when image already exists in box', () async {
        when(() => box.containsKey(expectedHash)).thenReturn(true);

        await repository.saveImage(fakeImage);

        verifyNever(() => box.put(any<String>(), any<String>()));
      });
    });

    group('deleteImage', () {
      test('deletes image from disk and removes hash from box', () async {
        final filePath = '${tempDir.path}/$expectedHash';
        await File(filePath).writeAsBytes(fakeImage);

        when(() => box.containsKey(expectedHash)).thenReturn(true);
        when(() => box.delete(expectedHash)).thenAnswer((_) async {});

        final result = await repository.deleteImage(fakeImage);

        expect(result, isTrue);
        expect(File(filePath).existsSync(), isFalse);
        verify(() => box.delete(expectedHash)).called(1);
      });
    });

    group('deleteImageByHash', () {
      test('returns true when hash is not in box (already deleted)', () async {
        when(() => box.containsKey('abc123')).thenReturn(false);

        final result = await repository.deleteImageByHash('abc123');

        expect(result, isTrue);
        verifyNever(() => box.delete(any<dynamic>()));
      });

      test('deletes from disk and box when hash exists', () async {
        final filePath = '${tempDir.path}/todelete';
        await File(filePath).writeAsBytes(fakeImage);

        addTearDown(() {
          // If the test fails (does not remove the image) clean up in tear down
          if (File(filePath).existsSync()) {
            File(filePath).deleteSync();
          }
        });

        when(() => box.containsKey('todelete')).thenReturn(true);
        when(() => box.delete('todelete')).thenAnswer((_) async {});

        final result = await repository.deleteImageByHash('todelete');

        expect(result, isTrue);
        expect(File(filePath).existsSync(), isFalse);
        verify(() => box.delete('todelete')).called(1);
      });
    });
  });
}
