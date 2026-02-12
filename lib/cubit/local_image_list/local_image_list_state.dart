sealed class LocalImageListState {}

class LocalImageListStateInitial extends LocalImageListState {}

class LocalImageListStateLoading extends LocalImageListState {}

class LocalImageListStateLoaded extends LocalImageListState {
  LocalImageListStateLoaded(this.imageHashes);
  final List<String> imageHashes;
}

class LocalImageListStateError extends LocalImageListState {}
