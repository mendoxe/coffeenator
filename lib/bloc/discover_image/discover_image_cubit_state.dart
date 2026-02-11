import 'dart:typed_data';

sealed class DiscoverImageCubitState {
  const DiscoverImageCubitState(this.images);

  final List<Uint8List> images;
}

class DiscoverImageCubitStateInitial extends DiscoverImageCubitState {
  DiscoverImageCubitStateInitial() : super([]);
}

class DiscoverImageCubitStateLoading extends DiscoverImageCubitState {
  DiscoverImageCubitStateLoading(super.images);
}

class DiscoverImageCubitStateLoaded extends DiscoverImageCubitState {
  DiscoverImageCubitStateLoaded(super.images);
}

class DiscoverImageCubitStateError extends DiscoverImageCubitState {
  DiscoverImageCubitStateError(this.message, super.images);
  final String message;
}
