import 'package:colaborador/core/failures/failures.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_bloc.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_event.dart';
import 'package:colaborador/feature/sync_digital_points/presentation/bloc/sync_digital_points_state.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull, equals;
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeSync extends Fake implements SyncPointsUsecase {
  bool fail = false;
  bool sendFailure = false;
  bool leftover = false;

  @override
  Future<Try<List<DigitalPointEntity>>> call(SyncPointsParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    if (sendFailure) {
      return Rejection(DigitalPointSendFailure(
        points: params.digitalPoints,
        code: '409',
        message: 'ocupado',
      ));
    }
    if (leftover) return Success(params.digitalPoints);
    return Success(const []);
  }
}

void main() {
  group('SyncDigitalPointsBloc', () {
    test('bloqueia tablet-only no celular', () async {
      final bloc = SyncDigitalPointsBloc(
        sessionBloc: FakeSessionBloc(
          Session(
            me: testMe(isTabletSession: false),
            condominium: testCondominium(
              deviceTypeEnum: DeviceTypeAllowedEnum.tablet,
            ),
          ),
        ),
        syncPointsUsecase: _FakeSync(),
      );
      addTearDown(bloc.close);
      bloc.add(SyncPointsEvent(digitalPoints: [testPoint()]));
      final state = await bloc.stream.firstWhere(
        (s) => s is SyncDigitalPointsBlockedState,
      );
      expect((state as SyncDigitalPointsBlockedState).onlyTablet, isTrue);
    });

    test('bloqueia phone-only no tablet', () async {
      final bloc = SyncDigitalPointsBloc(
        sessionBloc: FakeSessionBloc(
          Session(
            me: testMe(isTabletSession: true),
            condominium: testCondominium(
              deviceTypeEnum: DeviceTypeAllowedEnum.phone,
            ),
          ),
        ),
        syncPointsUsecase: _FakeSync(),
      );
      addTearDown(bloc.close);
      bloc.add(SyncPointsEvent(digitalPoints: [testPoint()]));
      final state = await bloc.stream.firstWhere(
        (s) => s is SyncDigitalPointsBlockedState,
      );
      expect((state as SyncDigitalPointsBlockedState).onlyPhone, isTrue);
    });

    test('sucesso quando a lista volta vazia', () async {
      final bloc = SyncDigitalPointsBloc(
        sessionBloc: FakeSessionBloc(),
        syncPointsUsecase: _FakeSync(),
      );
      addTearDown(bloc.close);
      bloc.add(SyncPointsEvent(digitalPoints: [testPoint()]));
      expect(
        await bloc.stream.firstWhere((s) => s is SyncDigitalPointsSuccessState),
        isA<SyncDigitalPointsSuccessState>(),
      );
    });

    test('falha com DigitalPointSendFailure', () async {
      final bloc = SyncDigitalPointsBloc(
        sessionBloc: FakeSessionBloc(),
        syncPointsUsecase: _FakeSync()..sendFailure = true,
      );
      addTearDown(bloc.close);
      bloc.add(SyncPointsEvent(digitalPoints: [testPoint()]));
      final state = await bloc.stream.firstWhere(
        (s) => s is SyncDigitalPointsFailedState,
      );
      expect((state as SyncDigitalPointsFailedState).code, '409');
      expect(state.message, 'ocupado');
    });

    test('falha genérica e pontos restantes', () async {
      final failBloc = SyncDigitalPointsBloc(
        sessionBloc: FakeSessionBloc(),
        syncPointsUsecase: _FakeSync()..fail = true,
      );
      addTearDown(failBloc.close);
      failBloc.add(SyncPointsEvent(digitalPoints: [testPoint()]));
      expect(
        await failBloc.stream.firstWhere((s) => s is SyncDigitalPointsFailedState),
        isA<SyncDigitalPointsFailedState>(),
      );

      final leftover = SyncDigitalPointsBloc(
        sessionBloc: FakeSessionBloc(),
        syncPointsUsecase: _FakeSync()..leftover = true,
      );
      addTearDown(leftover.close);
      leftover.add(SyncPointsEvent(digitalPoints: [testPoint()]));
      final state = await leftover.stream.firstWhere(
        (s) => s is SyncDigitalPointsFailedState,
      );
      expect((state as SyncDigitalPointsFailedState).failedDigitalPoints, isNotEmpty);
    });
  });
}
