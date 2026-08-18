import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_point_without_login/sync_point_without_login_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/sync_points/sync_points_impl.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/upload_digital_point_to_aws/upload_digital_point_to_aws_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fixtures.dart';

class _FakePointRepo extends Fake implements DigitalPointRepository {
  DigitalPointEntity? lastSaved;
  List<DigitalPointEntity>? lastSynced;
  String? lastLog;
  bool syncWithoutLoginCalled = false;

  @override
  Future<Try<DigitalPointEntity>> savePoint(
    DigitalPointEntity entity,
    String condoId,
    String meId,
  ) async {
    lastSaved = entity;
    return Success(entity);
  }

  @override
  Future<Try<DigitalPointEntity>> registerPoint(
    DigitalPointEntity entity,
    String condoId,
    String meId,
  ) async {
    lastSaved = entity;
    return Success(entity);
  }

  @override
  Future<Try<DigitalPointEntity>> savePointLog(
    DigitalPointEntity entity,
    String statusPrevious,
    String description,
  ) async {
    lastLog = description;
    return Success(entity);
  }

  @override
  Future<Try<List<DigitalPointEntity>>> syncPoints(
    String condoId,
    String meId,
    List<DigitalPointEntity> points,
  ) async {
    lastSynced = points;
    return Success(points);
  }

  @override
  Future<Try<void>> syncPointWithoutLogin({
    required DigitalPointEntity point,
  }) async {
    syncWithoutLoginCalled = true;
    lastSaved = point;
    return Success(null);
  }
}

class _FakeUploadAws extends Fake implements UploadDigitalPointToAwsUsecase {
  bool fail = false;

  @override
  Future<Try<DigitalPointEntity>> call(
    UploadDigitalPointToAwsParam params,
  ) async {
    if (fail) return Rejection(UnknownFailure('aws'));
    params.digitalPointEntity.photoTempHash = 'hash.png';
    return Success(params.digitalPointEntity);
  }
}

class _FakeAws extends Fake implements AwsUploadFileUsecase {
  bool fail = false;

  @override
  Future<Try<UrlUploadS3>> call(AwsUploadFileParam params) async {
    if (fail) return Rejection(UnknownFailure('upload'));
    return Success(UrlUploadS3(fileName: 'hash.png', url: 'http://s3'));
  }
}

void main() {
  group('SavePointUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        SavePointUsecaseImpl(repository: _FakePointRepo()).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condoId vazio', () async {
      final result = await SavePointUsecaseImpl(repository: _FakePointRepo())(
        SavePointParam(model: testPoint(), condoId: '', meId: 'm1'),
      );
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('rejeita ponto inválido', () async {
      final result = await SavePointUsecaseImpl(repository: _FakePointRepo())(
        SavePointParam(
          model: testPoint(photoPath: ''),
          condoId: 'c1',
          meId: 'm1',
        ),
      );
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('salva ponto válido', () async {
      final repo = _FakePointRepo();
      final point = testPoint();
      final result = await SavePointUsecaseImpl(repository: repo)(
        SavePointParam(model: point, condoId: 'c1', meId: 'm1'),
      );
      expect(result, isA<Success<DigitalPointEntity>>());
      expect(repo.lastSaved, point);
    });
  });

  group('SyncPointsUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        SyncPointsUsecaseImpl(
          repository: _FakePointRepo(),
          uploadDigitalPointToAwsUsecase: _FakeUploadAws(),
        ).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condoId vazio', () async {
      final result = await SyncPointsUsecaseImpl(
        repository: _FakePointRepo(),
        uploadDigitalPointToAwsUsecase: _FakeUploadAws(),
      )(SyncPointsParam(condoId: '', meId: 'm1', digitalPoints: [testPoint()]));
      expect(result, isA<Rejection<List<DigitalPointEntity>>>());
    });

    test('sincroniza pontos com upload ok', () async {
      final repo = _FakePointRepo();
      final result = await SyncPointsUsecaseImpl(
        repository: repo,
        uploadDigitalPointToAwsUsecase: _FakeUploadAws(),
      )(SyncPointsParam(
        condoId: 'c1',
        meId: 'm1',
        digitalPoints: [testPoint()],
      ));
      expect(result, isA<Success<List<DigitalPointEntity>>>());
      expect(repo.lastSynced, hasLength(1));
      expect(repo.lastSynced!.first.photoTempHash, 'hash.png');
    });

    test('ignora pontos cujo upload falhou', () async {
      final repo = _FakePointRepo();
      final result = await SyncPointsUsecaseImpl(
        repository: repo,
        uploadDigitalPointToAwsUsecase: _FakeUploadAws()..fail = true,
      )(SyncPointsParam(
        condoId: 'c1',
        meId: 'm1',
        digitalPoints: [testPoint()],
      ));
      expect(result, isA<Success<List<DigitalPointEntity>>>());
      expect(repo.lastSynced, isEmpty);
    });
  });

  group('SyncPointWithoutLoginUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        SyncPointWithoutLoginUsecaseImpl(
          repository: _FakePointRepo(),
          uploadDigitalPointToAwsUsecase: _FakeUploadAws(),
        ).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita ponto sem referência e grava log', () async {
      final repo = _FakePointRepo();
      final result = await SyncPointWithoutLoginUsecaseImpl(
        repository: repo,
        uploadDigitalPointToAwsUsecase: _FakeUploadAws(),
      )(SyncPointWithoutLoginParam(digitalPoint: testPoint(reference: '')));
      expect(result, isA<Rejection<void>>());
      expect(repo.lastLog, 'invalid_parameters_for_offline');
    });

    test('rejeita falha de upload e grava log', () async {
      final repo = _FakePointRepo();
      final result = await SyncPointWithoutLoginUsecaseImpl(
        repository: repo,
        uploadDigitalPointToAwsUsecase: _FakeUploadAws()..fail = true,
      )(SyncPointWithoutLoginParam(digitalPoint: testPoint()));
      expect(result, isA<Rejection<void>>());
      expect(repo.lastLog, 'photo_upload_fail');
    });

    test('sincroniza offline após upload', () async {
      final repo = _FakePointRepo();
      final result = await SyncPointWithoutLoginUsecaseImpl(
        repository: repo,
        uploadDigitalPointToAwsUsecase: _FakeUploadAws(),
      )(SyncPointWithoutLoginParam(digitalPoint: testPoint()));
      expect(result, isA<Success<void>>());
      expect(repo.syncWithoutLoginCalled, isTrue);
    });
  });

  group('RegisterPointUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        RegisterPointUsecaseImpl(
          repository: _FakePointRepo(),
          awsUploadFileUsecase: _FakeAws(),
        ).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita falha de upload', () async {
      final result = await RegisterPointUsecaseImpl(
        repository: _FakePointRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(RegisterPointParam(
        condoId: 'c1',
        meId: 'm1',
        digitalPoint: testPoint(),
        file: testTempFile(),
      ));
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('registra após upload', () async {
      final repo = _FakePointRepo();
      final point = testPoint();
      final result = await RegisterPointUsecaseImpl(
        repository: repo,
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterPointParam(
        condoId: 'c1',
        meId: 'm1',
        digitalPoint: point,
        file: testTempFile(),
      ));
      expect(result, isA<Success<DigitalPointEntity>>());
      expect(point.photoTempHash, 'hash.png');
      expect(repo.lastSaved, point);
    });
  });

  group('UploadDigitalPointToAwsUsecaseImpl', () {
    test('grava hash após upload', () async {
      final point = testPoint();
      final result = await UploadDigitalPointToAwsUsecaseImpl(
        repository: _FakePointRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(UploadDigitalPointToAwsParam(
        getUrlUploadS3: (_) async =>
            Success(UrlUploadS3(fileName: 'x', url: 'u')),
        uploadFileToS3: (_, __) async => Success('ok'),
        digitalPointEntity: point,
        condoId: 'c1',
      ));
      expect(result, isA<Success<DigitalPointEntity>>());
      expect(point.photoTempHash, 'hash.png');
    });

    test('rejeita falha de upload', () async {
      final result = await UploadDigitalPointToAwsUsecaseImpl(
        repository: _FakePointRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(UploadDigitalPointToAwsParam(
        getUrlUploadS3: (_) async =>
            Success(UrlUploadS3(fileName: 'x', url: 'u')),
        uploadFileToS3: (_, __) async => Success('ok'),
        digitalPointEntity: testPoint(),
        condoId: 'c1',
      ));
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });
  });
}
