import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

class _FakeGetPendingPoints extends Fake implements GetPendingPointsUsecase {
  _FakeGetPendingPoints({this.fail = false, this.points = const []});

  final bool fail;
  final List<DigitalPointEntity> points;

  @override
  Future<Try<List<DigitalPointEntity>>> call([void params]) async {
    if (fail) return Rejection(UnknownFailure('pending'));
    return Success(points);
  }
}

class _FakeSyncPoint extends Fake implements SyncPointWithoutLoginUsecase {
  _FakeSyncPoint({this.failFor = const <String>{}});

  final Set<String> failFor;
  final List<DigitalPointEntity> synced = [];

  @override
  Future<Try<void>> call(SyncPointWithoutLoginParam? params) async {
    final point = params!.digitalPoint;
    synced.add(point);
    if (failFor.contains(point.uniqueHash)) {
      return Rejection(UnknownFailure('sync'));
    }
    return Success(null);
  }
}

SyncDigitalPointsWorker _worker({
  required GetPendingPointsUsecase getPending,
  required SyncPointWithoutLoginUsecase sync,
}) =>
    SyncDigitalPointsWorker(
      getPendingPointsUsecase: getPending,
      syncPointWithoutLoginUsecase: sync,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final toasts = <String?>[];

  setUp(() {
    toasts.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (call) async {
        toasts.add((call.arguments as Map?)?['msg'] as String?);
        return true;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      null,
    );
  });

  group('SyncDigitalPointsWorker', () {
    test('sem pontos pendentes conclui sem sincronizar', () async {
      final sync = _FakeSyncPoint();
      final worker = _worker(
        getPending: _FakeGetPendingPoints(),
        sync: sync,
      );

      expect(await worker.syncPoints(), isTrue);
      expect(sync.synced, isEmpty);
      expect(toasts, contains('Sem pontos a serem enviados'));
    });

    test('pontos sem referência não são enviados', () async {
      final sync = _FakeSyncPoint();
      final worker = _worker(
        getPending: _FakeGetPendingPoints(
          points: [testPoint(reference: null), testPoint(reference: '')],
        ),
        sync: sync,
      );

      expect(await worker.syncPoints(), isTrue);
      expect(sync.synced, isEmpty);
    });

    test('envia cada ponto pendente marcado como offline', () async {
      final sync = _FakeSyncPoint();
      final worker = _worker(
        getPending: _FakeGetPendingPoints(
          points: [testPoint(), testPoint()],
        ),
        sync: sync,
      );

      expect(await worker.syncPoints(), isTrue);
      expect(sync.synced.length, 2);
      expect(
        sync.synced.every((p) => p.typePoint == DigitalPointTypeEnum.offline),
        isTrue,
      );
      expect(toasts.last, 'Enviados 2 de 2 pontos');
    });

    test('contabiliza falhas de envio no resumo', () async {
      final sync = _FakeSyncPoint(failFor: {'h1'});
      final worker = _worker(
        getPending: _FakeGetPendingPoints(points: [testPoint()]),
        sync: sync,
      );

      expect(await worker.syncPoints(), isTrue);
      expect(toasts.last, 'Enviados 0 de 1 pontos');
    });

    test('propaga falha ao buscar os pontos pendentes', () async {
      final worker = _worker(
        getPending: _FakeGetPendingPoints(fail: true),
        sync: _FakeSyncPoint(),
      );

      expect(worker.syncPoints(), throwsA(isA<UnknownFailure>()));
    });
  });
}
