import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_event.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_state.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_no_auth.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationTabletBloc
    extends Bloc<AuthenticationTabletEvent, AuthenticationTabletState> {
  final GetInfoByCondoCodeUseCase getInfoByCondoCodeUseCase;
  final GetPendingPointsUsecase getPendingPointsUsecase;
  final SyncDigitalPointsWorker syncPoints;

  AuthenticationTabletBloc({
    required this.getInfoByCondoCodeUseCase,
    required this.getPendingPointsUsecase,
    required this.syncPoints,
  }) : super(const AuthenticationTabletInitialState()) {
    on<GetInfoByCondoCodeEvent>(_mapGetInfoByCondoCode);
    on<GetNoAuthPointsEvent>(_mapGetNoAuthPointsCode);
    on<SendNoAuthPointsEvent>(_mapSendNoAuthPointsCode);
  }

  CondominiumCodeInfo? condeInfo;

  void getInfoByCondoCode(String condoCode) {
    add(GetInfoByCondoCodeEvent(condoCode));
  }

  void getNoAuthPoints(String reference) async {
    add(GetNoAuthPointsEvent(reference));
  }

  void sendNoAuthPoints(String reference) async {
    add(SendNoAuthPointsEvent(reference));
  }

  Future<void> _mapGetInfoByCondoCode(
    GetInfoByCondoCodeEvent event,
    Emitter<AuthenticationTabletState> emit,
  ) async {
    emit(const AuthenticationTabletLoadingState());
    final cacheResponse =
        await getInfoByCondoCodeUseCase.call(GetInfoByCondoCodeParams(
      condoCode: event.condoCode,
      origin: DataOrigin.local,
    ));

    AuthenticationTabletState cacheResult = cacheResponse
        .fold((error) => const AuthenticationTabletLoadingState(), (res) {
      condeInfo = res;
      return AuthenticationTabletLoadedState(res, isUpdating: true);
    });

    emit(cacheResult);

    final response =
        await getInfoByCondoCodeUseCase.call(GetInfoByCondoCodeParams(
      condoCode: event.condoCode,
      origin: DataOrigin.remote,
    ));

    AuthenticationTabletState result = response.fold(
      (error) => cacheResult is AuthenticationTabletLoadedState
          ? cacheResult
          : const AuthenticationTabletFailedState(),
      (res) {
        condeInfo = res;
        return AuthenticationTabletLoadedState(res);
      },
    );
    emit(result);
  }

  Future<void> _mapGetNoAuthPointsCode(
    GetNoAuthPointsEvent event,
    Emitter<AuthenticationTabletState> emit,
  ) async {
    emit(const AuthenticationTabletLoadingState());

    final result = await getPendingPointsUsecase(
      GetPointsNoAuthParam(),
    );

    AuthenticationTabletState response = result.fold(
      (error) => const AuthenticationTabletFailedState(),
      (points) => AuthenticationNoAuthPointsLoadedState(points: points),
    );
    emit(response);
  }

  Future<void> _mapSendNoAuthPointsCode(
    SendNoAuthPointsEvent event,
    Emitter<AuthenticationTabletState> emit,
  ) async {
    emit(const AuthenticationTabletLoadingState());

    var result = await syncPoints.syncPoints();

    if (result) {
      getNoAuthPoints(event.reference);
      return;
    } else {
      emit(const AuthenticationTabletFailedState());
    }
  }
}
