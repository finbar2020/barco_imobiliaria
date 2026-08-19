import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login.dart';
import 'package:essentials/essentials.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workmanager_platform_interface/workmanager_platform_interface.dart';

import '../../helpers/firebase_mocks.dart';

class _FakeGetPending extends Fake implements GetPendingPointsUsecase {
  @override
  Future<Try<List<DigitalPointEntity>>> call([void params]) async =>
      Success(const []);
}

class _FakeSync extends Fake implements SyncPointWithoutLoginUsecase {
  @override
  Future<Try<void>> call(SyncPointWithoutLoginParam? params) async =>
      Success(null);
}

class _FakeWorkmanagerPlatform extends WorkmanagerPlatform {
  _FakeWorkmanagerPlatform() : super();

  final registered = <Map<String, Object?>>[];

  @override
  Future<void> registerPeriodicTask(
    String uniqueName,
    String taskName, {
    Duration? frequency,
    Duration? flexInterval,
    Map<String, dynamic>? inputData,
    Duration? initialDelay,
    Constraints? constraints,
    ExistingPeriodicWorkPolicy? existingWorkPolicy,
    BackoffPolicy? backoffPolicy,
    Duration? backoffPolicyDelay,
    String? tag,
    ForegroundServiceConfig? foregroundServiceConfig,
  }) async {
    registered.add({
      'uniqueName': uniqueName,
      'taskName': taskName,
      'frequency': frequency,
      'networkType': constraints?.networkType,
      'existingWorkPolicy': existingWorkPolicy,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeWorkmanagerPlatform workmanager;
  late FakeRemoteConfigPlatform remoteConfig;

  setUp(() async {
    remoteConfig = await setUpFakeFirebase();
    // O construtor de `Workmanager` sobrescreve a instância da plataforma na
    // primeira chamada; forçamos essa inicialização antes de instalar o fake.
    Workmanager();
    workmanager = _FakeWorkmanagerPlatform();
    WorkmanagerPlatform.instance = workmanager;
  });

  test('schedule inicializa o remote config e agenda a tarefa periódica',
      () async {
    final worker = SyncDigitalPointsWorker(
      getPendingPointsUsecase: _FakeGetPending(),
      syncPointWithoutLoginUsecase: _FakeSync(),
    );

    await worker.schedule();

    expect(remoteConfig.fetches, greaterThanOrEqualTo(1));
    expect(remoteConfig.activations, greaterThanOrEqualTo(1));
    expect(workmanager.registered, hasLength(1));
    expect(
      workmanager.registered.single['uniqueName'],
      SyncDigitalPointsWorker.uniqueName,
    );
    expect(
      workmanager.registered.single['taskName'],
      SyncDigitalPointsWorker.taskName,
    );
    expect(
      workmanager.registered.single['frequency'],
      const Duration(hours: 4),
    );
    expect(
      workmanager.registered.single['networkType'],
      NetworkType.connected,
    );
    expect(
      workmanager.registered.single['existingWorkPolicy'],
      ExistingPeriodicWorkPolicy.replace,
    );
  });
}
