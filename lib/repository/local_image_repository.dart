import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LocalImageRepository {
  LocalImageRepository(this._box, [Logger? logger])
    : _logger = logger ?? Logger();

  final Box<String> _box;
  final Logger _logger;

  /// Checks if the hash is currently saved in the Hive box
  /// if it is, it should be saved as an image on disk as well
  bool isImageHashSaved(String imageHash) {
    final isSaved = _box.containsKey(imageHash);
    _logger.i('Image $imageHash is saved: $isSaved');
    return isSaved;
  }

  /// Checks if this image is currently saved on device
  /// This is just a wrapper around [isImageHashSaved]
  Future<bool> isImageSaved(Uint8List image) async {
    final imageHash = await _getImageHash(image);
    final isSaved = isImageHashSaved(imageHash);
    return isSaved;
  }

  /// Returns a list of all locally saved image hashes
  List<String> getAllLocalImageHashes() {
    final hashes = _box.values;

    _logger.i('Found ${hashes.length} local image hashes in Hive');
    return hashes.toList();
  }

  /// Returns a Uint8List representation of an image identified by the [imageHash]
  /// Returns null if no image was found
  Future<Uint8List?> getImage(String imageHash) async {
    if (!_box.containsKey(imageHash)) {
      _logger.w('Local image $imageHash not found in Hive');
      return null;
    }
    final image = await _getImageFromDisk(imageHash);

    return image;
  }

  /// Saves the Uint8List representation of an image to the local storage
  Future<void> saveImage(Uint8List image) async {
    _logger.t('Saving image locally');
    final imageHash = await _getImageHash(image);
    if (_box.containsKey(imageHash)) {
      _logger.w(
        'Local image $imageHash already exists in Hive, skipping saving',
      );
      return;
    }
    await _saveImageToDisk(image, imageHash);
    await _box.put(imageHash, imageHash);
  }

  /// Delete the image from device
  /// This is just a wrapper around [deleteImageByHash]
  Future<bool> deleteImage(Uint8List image) async {
    _logger.t('Deleting image locally');
    final imageHash = await _getImageHash(image);
    return deleteImageByHash(imageHash);
  }

  /// Deletes the image hash from device
  /// removes the hash from Hive
  /// delete the image file from disk
  Future<bool> deleteImageByHash(String imageHash) async {
    if (!_box.containsKey(imageHash)) {
      _logger.w('Local image $imageHash not found in Hive cannot delete');
      // Image already deleted locally
      return true;
    }
    await _deleteImageFromDisk(imageHash);
    await _box.delete(imageHash);
    return true;
  }

  Future<bool> _deleteImageFromDisk(String imageHash) async {
    final filePath = await _getImagePathFromHash(imageHash);
    final file = File(filePath);

    await file.delete();
    _logger.t('Image $imageHash deleted from disk');
    return true;
  }

  Future<String> _getImageHash(Uint8List image) async {
    final result = await Isolate.run(
      () => sha256.convert(image).toString(),
      debugName: 'Image hash calculation',
    );
    return result;
  }

  Future<Uint8List?> _getImageFromDisk(String imageHash) async {
    final filePath = await _getImagePathFromHash(imageHash);
    final file = File(filePath);
    if (!file.existsSync()) {
      _logger.w('Image $imageHash not found on disk');
      return null;
    }
    final bytes = await file.readAsBytes();
    return bytes;
  }

  Future<void> _saveImageToDisk(Uint8List imageBytes, String imageHash) async {
    final filePath = await _getImagePathFromHash(imageHash);
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
  }

  Future<String> _getImagePathFromHash(String imageHash) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, imageHash);
    return filePath;
  }
}
