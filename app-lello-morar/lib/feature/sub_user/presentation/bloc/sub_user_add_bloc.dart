import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/sub_user.dart';

class SubUserAddBloc extends Bloc {
  SubUserAddBloc() : super(SubUserAddLoadingState()) {
    on<SubUserAddLoadingEvent>(handleSubUserAddLoadingEvent);
    on<SubUserAddSuccessEvent>(handleSubUserAddSuccessEvent);
    on<SubUserAddErrorEvent>(handleSubUserAddErrorEvent);
  }

  void handleSubUserAddLoadingEvent(
      SubUserAddLoadingEvent event, Emitter emit) {
    emit(SubUserAddLoadingState());
  }
}

void handleSubUserAddSuccessEvent(SubUserAddSuccessEvent event, Emitter emit) {
  emit(SubUserAddSuccessState(subUsers: event.subUsers));
}

void handleSubUserAddErrorEvent(SubUserAddErrorEvent event, Emitter emit) {
  emit(SubUserAddErrorState());
}

// [EVENTS]

abstract class SubUserAddEvent {}

class SubUserAddLoadingEvent extends SubUserAddEvent {}

class SubUserAddSuccessEvent extends SubUserAddEvent {
  final List<SubUser> subUsers;
  SubUserAddSuccessEvent({
    required this.subUsers,
  });
}

class SubUserAddErrorEvent extends SubUserAddEvent {}

// [STATES]

abstract class SubUserAddState {}

class SubUserAddLoadingState extends SubUserAddState {}

class SubUserAddSuccessState extends SubUserAddState {
  final List<SubUser> subUsers;
  SubUserAddSuccessState({
    required this.subUsers,
  });
}

class SubUserAddErrorState extends SubUserAddState {}
