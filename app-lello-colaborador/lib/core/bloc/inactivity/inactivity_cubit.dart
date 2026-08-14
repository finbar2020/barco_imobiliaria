// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'inactivity_state.dart';

class InactivityCubit extends Cubit<InactivityState> {
  SessionBloc sessionBloc;
  final int duration = 60;
  Timer? periodicTimer;
  late int countDown;

  Offset offsetBubble = Offset(
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width * 0.82,
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.height * 0.85,
  );

  InactivityCubit({
    required this.sessionBloc,
  }) : super(
          TimeoutInitialState(),
        );

  void setOffset(Offset offset) => offsetBubble = offset;

  void start() {
    if (periodicTimer?.isActive ?? false) {
      periodicTimer?.cancel();
    }

    countDown = duration - 1;
    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (sessionBloc.getSession?.me.isTabletSession ?? false) {
          emit(
            ChangeTimeState(
              timer: countDown,
            ),
          );

          if (countDown > 0) {
            countDown--;
          } else if (sessionBloc.state is SessionLoadedState) {
            periodicTimer?.cancel();
            emit(TimeoutExpiredState());
          } else {
            periodicTimer?.cancel();
            periodicTimer = null;
            reset();
          }
        }
      },
    );
  }

  void cancel() {
    periodicTimer?.cancel();
    emit(TimeoutEmptyState());
  }

  void reset() {
    countDown = duration - 1;
  }

  bool isActive() => periodicTimer?.isActive ?? false;
}
