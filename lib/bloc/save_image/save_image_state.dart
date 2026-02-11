sealed class SaveImageState {}

class SaveImageStateInitial extends SaveImageState {}

class SaveImageStateLoading extends SaveImageState {}

class SaveImageStateSaved extends SaveImageState {}

class SaveImageStateError extends SaveImageState {
  SaveImageStateError(this.message);
  final String message;
}
