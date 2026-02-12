import 'package:cofeenator/utils/hive_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HivePaths', () {
    test('localImagesRepositoryBoxKey has expected value', () {
      expect(
        HivePaths.localImagesRepositoryBoxKey,
        'localImagesRepositoryBoxKey',
      );
    });
  });
}
