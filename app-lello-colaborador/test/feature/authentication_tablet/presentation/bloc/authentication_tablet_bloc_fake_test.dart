import 'dart:async';

import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_state.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_no_auth.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

CondominiumCodeInfo _tabletInfo() => CondominiumCodeInfo(
      condoCode: 'ABC',
      condominium: CondoInfo(
        reference: 'R1',
        name: 'Torre',
        picturehash: 'p',
        status: 'ok',
        ref: 'r',
      ),
      employees: [
        EmployeeInfo(
          numCra: '1',
          numCad: '2',
          cpf: '12345678901',
          name: 'ana silva',
          jobPosition: 'porteiro',
          idLogin: 'l1',
          pictureHash: 'pic',
          registered: true,
          statusEnum: DigitalTimesheetStatusEnum.approved,
        ),
      ],
    );

class _FakeGetInfo extends Fake implements GetInfoByCondoCodeUseCase {
  bool remoteFail = false;
  bool cacheFail = false;
  final remoteDone = Completer<void>();

  @override
  Future<Try<CondominiumCodeInfo>> call(GetInfoByCondoCodeParams params) async {
    if (params.origin == DataOrigin.local) {
      if (cacheFail) return Rejection(UnknownFailure('cache'));
      return Success(_tabletInfo());
    }
    if (remoteFail) {
      if (!remoteDone.isCompleted) remoteDone.complete();
      return Rejection(UnknownFailure('remote'));
    }
    if (!remoteDone.isCompleted) remoteDone.complete();
    return Success(_tabletInfo());
  }
}

class _FakePending extends Fake implements GetPendingPointsUsecase {
  bool fail = false;

  @override
  Future<Try<List<DigitalPointEntity>>> call([void params]) async {
    if (fail) return Rejection(UnknownFailure('points'));
    return Success([testPoint(id: 1)]);
  }
}

class _FakeSyncWorker extends Fake implements SyncDigitalPointsWorker {
  bool success = true;

  @override
  Future<bool> syncPoints() async => success;
}

void main() {
  group('AuthenticationTabletBloc', () {
    test('carrega cache e depois remoto', () async {
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: _FakeGetInfo(),
        getPendingPointsUsecase: _FakePending(),
        syncPoints: _FakeSyncWorker(),
      );
      addTearDown(bloc.close);
      bloc.getInfoByCondoCode('ABC');
      final updating = await bloc.stream.firstWhere(
        (s) => s is AuthenticationTabletLoadedState,
      );
      expect((updating as AuthenticationTabletLoadedState).isUpdating, isTrue);
      final loaded = await bloc.stream.firstWhere(
        (s) => s is AuthenticationTabletLoadedState && !s.isUpdating,
      );
      expect(loaded, isA<AuthenticationTabletLoadedState>());
      expect(bloc.condeInfo?.condoCode, 'ABC');
    });

    test('falha remoto mantém cache', () async {
      final fake = _FakeGetInfo()..remoteFail = true;
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: fake,
        getPendingPointsUsecase: _FakePending(),
        syncPoints: _FakeSyncWorker(),
      );
      addTearDown(bloc.close);
      bloc.getInfoByCondoCode('ABC');
      final states = await bloc.stream.take(2).toList();
      await fake.remoteDone.future;
      expect(states[0], isA<AuthenticationTabletLoadingState>());
      expect(states[1], isA<AuthenticationTabletLoadedState>());
      expect((states[1] as AuthenticationTabletLoadedState).isUpdating, isTrue);
      expect(bloc.state, isA<AuthenticationTabletLoadedState>());
      expect(bloc.condeInfo?.condoCode, 'ABC');
    });

    test('falha remoto e cache emite failed', () async {
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: _FakeGetInfo()
          ..cacheFail = true
          ..remoteFail = true,
        getPendingPointsUsecase: _FakePending(),
        syncPoints: _FakeSyncWorker(),
      );
      addTearDown(bloc.close);
      bloc.getInfoByCondoCode('ABC');
      expect(
        await bloc.stream.firstWhere((s) => s is AuthenticationTabletFailedState),
        isA<AuthenticationTabletFailedState>(),
      );
    });

    test('lista pontos sem autenticação', () async {
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: _FakeGetInfo(),
        getPendingPointsUsecase: _FakePending(),
        syncPoints: _FakeSyncWorker(),
      );
      addTearDown(bloc.close);
      bloc.getNoAuthPoints('R1');
      final state = await bloc.stream.firstWhere(
        (s) => s is AuthenticationNoAuthPointsLoadedState,
      );
      expect((state as AuthenticationNoAuthPointsLoadedState).points, hasLength(1));
    });

    test('falha ao listar pontos sem auth', () async {
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: _FakeGetInfo(),
        getPendingPointsUsecase: _FakePending()..fail = true,
        syncPoints: _FakeSyncWorker(),
      );
      addTearDown(bloc.close);
      bloc.getNoAuthPoints('R1');
      expect(
        await bloc.stream.firstWhere((s) => s is AuthenticationTabletFailedState),
        isA<AuthenticationTabletFailedState>(),
      );
    });

    test('envia pontos e recarrega lista', () async {
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: _FakeGetInfo(),
        getPendingPointsUsecase: _FakePending(),
        syncPoints: _FakeSyncWorker(),
      );
      addTearDown(bloc.close);
      bloc.sendNoAuthPoints('R1');
      await bloc.stream.firstWhere((s) => s is AuthenticationTabletLoadingState);
      expect(
        await bloc.stream.firstWhere(
          (s) => s is AuthenticationNoAuthPointsLoadedState,
        ),
        isA<AuthenticationNoAuthPointsLoadedState>(),
      );
    });

    test('falha ao enviar pontos', () async {
      final bloc = AuthenticationTabletBloc(
        getInfoByCondoCodeUseCase: _FakeGetInfo(),
        getPendingPointsUsecase: _FakePending(),
        syncPoints: _FakeSyncWorker()..success = false,
      );
      addTearDown(bloc.close);
      bloc.sendNoAuthPoints('R1');
      expect(
        await bloc.stream.firstWhere((s) => s is AuthenticationTabletFailedState),
        isA<AuthenticationTabletFailedState>(),
      );
    });
  });
}
