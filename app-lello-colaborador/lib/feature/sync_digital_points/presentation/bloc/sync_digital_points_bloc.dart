import 'dart:async';

import 'package:colaborador/core/failures/failures.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_event.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncDigitalPointsBloc
    extends Bloc<SyncDigitalPointsEvent, SyncDigitalPointsState> {
  final SessionBloc sessionBloc;
  final SyncPointsUsecase syncPointsUsecase;

  StreamSubscription? _subscription;

  SyncDigitalPointsBloc({
    required this.sessionBloc,
    required this.syncPointsUsecase,
  }) : super(const SyncDigitalPointsLoadedState()) {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      _subscription = sessionBloc.stream.listen(_onSessionChanged);
    }
    on<SyncPointsEvent>(handleSyncPointsEvent);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> handleSyncPointsEvent(
      SyncPointsEvent event, Emitter emit) async {
    String condominiumId = sessionBloc.getSession?.condominium.id ?? "";
    String meId = sessionBloc.getSession?.me.id ?? "";

    emit(const SyncDigitalPointsLoadingState());

    if (((!sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyTablet)) {
      emit(
        const SyncDigitalPointsBlockedState(onlyTablet: true),
      );
      return;
    }
    if ((sessionBloc.getSession!.me.isTabletSession!) &&
        sessionBloc.getSession!.condominium.deviceTypeEnum.isOnlyPhone) {
      emit(
        const SyncDigitalPointsBlockedState(onlyPhone: true),
      );
      return;
    }

    List<DigitalPointEntity> digitalPoints = event.digitalPoints;

    List<DigitalPointEntity> digitalPointsOffline = [];
    for (var element in digitalPoints) {
      digitalPointsOffline
          .add(element.copyWith(typePoint: DigitalPointTypeEnum.offline));
    }

    final requests = await syncPointsUsecase.call(
      SyncPointsParam(
        condoId: condominiumId,
        meId: meId,
        digitalPoints: digitalPointsOffline,
      ),
    );

    SyncDigitalPointsState response = requests.fold(
      (error) {
        if (error is DigitalPointSendFailure) {
          return SyncDigitalPointsFailedState(
            failedDigitalPoints: digitalPoints,
            code: error.code,
            message: error.message,
          );
        }
        return SyncDigitalPointsFailedState(
          failedDigitalPoints: digitalPoints,
          code: error.code,
        );
      },
      (res) {
        if (res.isEmpty) {
          return const SyncDigitalPointsSuccessState();
        } else {
          return SyncDigitalPointsFailedState(
            failedDigitalPoints: res,
          );
        }
      },
    );

    emit(response);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {}
  }
}
