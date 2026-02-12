import 'package:bloc/bloc.dart';
import 'package:cofeenator/cubit/local_image_list/local_image_list_state.dart';
import 'package:cofeenator/repository/local_image_repository.dart';
import 'package:logger/logger.dart';

class LocalImageListCubit extends Cubit<LocalImageListState> {
  LocalImageListCubit(this._repo, [Logger? logger]) : _logger = logger ?? Logger(), super(LocalImageListStateInitial());

  final LocalImageRepository _repo;
  final Logger _logger;

  void loadAll() {
    _logger.t('Loading all local images');
    emit(LocalImageListStateLoading());
    try {
      final hashes = _repo.getAllLocalImageHashes();
      _logger.t('Found ${hashes.length} local images');
      emit(LocalImageListStateLoaded(hashes));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      _logger.t('All local images search failed');
      emit(LocalImageListStateError());
    }
  }
}
