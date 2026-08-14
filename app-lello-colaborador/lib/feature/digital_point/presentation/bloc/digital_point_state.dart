import 'package:essentials/essentials.dart';

abstract class DigitalPointState extends Equatable {
  const DigitalPointState();

  @override
  List<Object?> get props => [];
}

class FaceInitialPictureState extends DigitalPointState {
  const FaceInitialPictureState();
}

class FaceLoadingPictureState extends DigitalPointState {
  const FaceLoadingPictureState();
}

class FaceRequestErrorPictureState extends DigitalPointState {
  const FaceRequestErrorPictureState();
}

class FaceRequestCanceledPictureState extends DigitalPointState {
  const FaceRequestCanceledPictureState();
}

class FaceRegisterLoadedPictureState extends DigitalPointState {
  final bool isOnlineRegister;

  const FaceRegisterLoadedPictureState({required this.isOnlineRegister});

  @override
  List<Object?> get props => [isOnlineRegister];
}

class FaceRegisterAwayPictureState extends DigitalPointState {
  final String message;

  const FaceRegisterAwayPictureState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class FaceRegisterFailedPictureState extends DigitalPointState {
  final Exception? ex;

  const FaceRegisterFailedPictureState([this.ex]);

  @override
  List<Object?> get props => [ex];
}

class FaceRequestLoadedPictureState extends DigitalPointState {
  const FaceRequestLoadedPictureState();
}

class FaceRequestFailedPictureState extends DigitalPointState {
  final Exception? ex;

  const FaceRequestFailedPictureState([this.ex]);

  @override
  List<Object?> get props => [ex];
}

class LocationTimeoutFailedPictureState extends DigitalPointState {
  final Exception? exception;

  const LocationTimeoutFailedPictureState([this.exception]);

  @override
  List<Object?> get props => [exception];
}

class FaceRequestNoFacePictureState extends DigitalPointState {
  const FaceRequestNoFacePictureState();
}
