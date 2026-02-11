import 'dart:typed_data';

sealed class LocalImageState {}

class LocalImageStateInitial extends LocalImageState {}

class LocalImageStateLoading extends LocalImageState {}

class LocalImageStateLoaded extends LocalImageState {
  LocalImageStateLoaded(this.bytes);
  final Uint8List bytes;
}

class LocalImageStateError extends LocalImageState {
  LocalImageStateError(this.message);
  final String message;
}
