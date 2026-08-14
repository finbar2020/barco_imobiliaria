import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DebugBloc extends Bloc {
  DebugBloc(super.initialState) {
    on<SendDebugEvent>(
      (event, emit) => emit(
        SendDebugState(
            face: event.face,
            rotation: event.rotation,
            performace: event.performace),
      ),
    );
  }
}

abstract class IDebugEvent {}

class SendDebugEvent extends IDebugEvent {
  final int rotation;
  final Face face;
  final int performace;

  SendDebugEvent({
    required this.face,
    required this.rotation,
    required this.performace,
  });
}

abstract class IDebugState {}

class SendDebugState extends IDebugState {
  final int rotation;
  final Face face;
  final int performace;

  SendDebugState({
    required this.face,
    required this.rotation,
    required this.performace,
  });
}

class LoadingDebugState extends IDebugState {}
