import 'package:bloc/bloc.dart';
import 'package:cofeenator/bloc/discover_image/discover_image_cubit_state.dart';
import 'package:cofeenator/repository/remote_image_repository.dart';
import 'package:logger/logger.dart';

class DiscoverImageCubit extends Cubit<DiscoverImageCubitState> {
  DiscoverImageCubit(this._repository, [Logger? logger]) : _logger = logger ?? Logger(), super(DiscoverImageCubitStateInitial());

  final RemoteImageRepository _repository;
  final Logger _logger;

  Future<bool> fetchImage() async {
    _logger.t('Loading new random image');
    emit(DiscoverImageCubitStateLoading(state.images));

    try {
      final image = await _repository.getImage();
      _logger.i('New random image loaded');
      emit(DiscoverImageCubitStateLoaded([...state.images, image]));
      return true;
    } catch (e) {
      _logger.e('Random image loading errored out');
      emit(DiscoverImageCubitStateError(e.toString(), state.images));
      return false;
    }
  }
}
