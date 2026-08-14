import 'dart:io';

import 'package:essentials/essentials.dart';

class AttachFilesBloc extends Bloc<AttachFilesEvent, AttachFilesState> {
  AttachFilesBloc() : super(AttachFilesEmptyState()) {
    on<AttachFilesSuccessEvent>(handleAttachFilesSuccessEvent);
    on<AttachFilesEmptyEvent>(handleAttachFilesEmptyEvent);
  }

  void handleAttachFilesSuccessEvent(
      AttachFilesSuccessEvent event, Emitter emit) {
    emit(AttachFilesSuccessState(files: event.files));
  }

  void handleAttachFilesEmptyEvent(AttachFilesEmptyEvent event, Emitter emit) {
    emit(AttachFilesEmptyState(
        errorType: event.errorType,
        fileExtension: event.fileExtension,
        fileName: event.fileName));
  }
}

abstract class AttachFilesEvent {}

class AttachFilesSuccessEvent extends AttachFilesEvent {
  final List<File> files;
  AttachFilesSuccessEvent({required this.files});
}

class AttachFilesEmptyEvent extends AttachFilesEvent {
  final FileError? errorType;
  final String? fileExtension;
  final String? fileName;

  AttachFilesEmptyEvent({this.errorType, this.fileExtension, this.fileName});
}

abstract class AttachFilesState {}

class AttachFilesEmptyState extends AttachFilesState {
  final FileError? errorType;
  final String? fileExtension;
  final String? fileName;

  AttachFilesEmptyState({this.errorType, this.fileExtension, this.fileName});
}

class AttachFilesSuccessState extends AttachFilesState {
  final List<File> files;
  AttachFilesSuccessState({required this.files});
}
