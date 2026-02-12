import 'dart:typed_data';

import 'package:cofeenator/cubit/save_image/save_image_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SaveImageCubit extends Cubit<SaveImageState> {
  SaveImageCubit(this._repo, {required Uint8List imageBytes, Logger? logger})
    : _logger = logger ?? Logger(),
      _imageBytes = imageBytes,
      super(SaveImageStateInitial());

  final LocalImageRepository _repo;
  final Uint8List _imageBytes;
  final Logger _logger;

  Future<void> checkIfImageSaved() async {
    _logger.t('Checking if image is initially saved');
    try {
      final isSaved = await _repo.isImageSaved(_imageBytes);
      if (isSaved) {
        _logger.i('Image was already saved');
        emit(SaveImageStateSaved());
      }
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      _logger.i('Image checking failed, staying in initial state');
    }
  }

  Future<bool> saveCurrentImage() async {
    _logger.t('Saving current image');
    emit(SaveImageStateLoading());
    try {
      await _repo.saveImage(_imageBytes);
      _logger.i('Image saved');
      emit(SaveImageStateSaved());
      return true;
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      _logger.e('Image saving failed');
      emit(SaveImageStateError('Failed to save image: $e'));
      return false;
    }
  }

  Future<bool> deleteCurrentImage() async {
    _logger.t('Deleting image');
    emit(SaveImageStateLoading());
    try {
      await _repo.deleteImage(_imageBytes);
      _logger.i('Image deleted');
      emit(SaveImageStateInitial());
      return true;
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      _logger.e('Image deletion failed');
      emit(SaveImageStateError('Failed to delete image: $e'));
      return false;
    }
  }
}
