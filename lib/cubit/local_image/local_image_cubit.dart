import 'package:cofeenator/cubit/local_image/local_image_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class LocalImageCubit extends Cubit<LocalImageState> {
  LocalImageCubit(this._repo, {required String imageHash, Logger? logger})
    : _logger = logger ?? Logger(),

      _hash = imageHash,
      super(LocalImageStateInitial());

  final LocalImageRepository _repo;
  final String _hash;
  final Logger _logger;

  Future<void> loadImage() async {
    _logger.t('Loading local image $_hash');
    emit(LocalImageStateLoading());
    try {
      final bytes = await _repo.getImage(_hash);
      if (bytes != null) {
        _logger.t('Found local image $_hash');
        emit(LocalImageStateLoaded(bytes));
      } else {
        _logger.t('Image $_hash not found');
        emit(LocalImageStateError('Failed to load image'));
      }
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      _logger.t('Local search for image $_hash failed');
      emit(LocalImageStateError('An error occured while loading image'));
    }
  }

  Future<bool> deleteCurrentImage() async {
    emit(LocalImageStateLoading());
    try {
      await _repo.deleteImageByHash(_hash);
      _logger.t('Deleted local image $_hash');
      emit(LocalImageStateInitial());
      return true;
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      _logger.t('Local deletion of image $_hash failed');
      emit(LocalImageStateError('Failed to delete image'));
      return false;
    }
  }
}
