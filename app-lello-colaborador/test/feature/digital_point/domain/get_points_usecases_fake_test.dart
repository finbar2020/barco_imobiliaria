import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_no_auth.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fixtures.dart';

class _FakePointRepo extends Fake implements DigitalPointRepository {
  bool failPoints = false;
  bool failLogs = false;
  bool failPending = false;
  bool failRequest = false;
  bool failAws = false;

  @override
  Future<Try<List<DigitalPointEntity>>> getPoints(
      String condoId, String meId) async {
    if (failPoints) return Rejection(UnknownFailure('points'));
    return Success([testPoint(id: 1)]);
  }

  @override
  Future<Try<List<DigitalPointLogData>>> getPointLogs(int pointId) async {
    if (failLogs) return Rejection(UnknownFailure('logs'));
    return Success(const []);
  }

  @override
  Future<Try<List<DigitalPointEntity>>> getPendingPoints() async {
    if (failPending) return Rejection(UnknownFailure('pending'));
    return Success([testPoint(id: 2)]);
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws(String condoId) async {
    if (failAws) return Rejection(UnknownFailure('aws'));
    return Success(UrlUploadS3(fileName: 'hash.png', url: 'http://s3'));
  }

  @override
  Future<Try<String>> uploadImageToAws(file, String url) async {
    if (failAws) return Rejection(UnknownFailure('upload'));
    return Success('ok');
  }

  @override
  Future<Try<bool>> requestDigitalPoint(String condoId, String imageHash) async {
    if (failRequest) return Rejection(UnknownFailure('request'));
    return Success(true);
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

Position _position() => Position(
      longitude: -46.6,
      latitude: -23.5,
      timestamp: DateTime(2026, 1, 10),
      accuracy: 1,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

void main() {
  group('GetPointsUsecase', () {
    test('rejeita param nulo', () async {
      final usecase = GetPointsUsecase(repository: _FakePointRepo());
      expect(usecase.validate(null), isA<InvalidParamFailure>());
    });

    test('busca pontos com logs', () async {
      final result = await GetPointsUsecase(repository: _FakePointRepo())(
        GetPointsParam(condoId: 'c1', meId: 'm1'),
      );
      expect(result, isA<Success<List<DigitalPointEntity>>>());
      expect((result as Success<List<DigitalPointEntity>>).get(), hasLength(1));
    });

    test('lança quando getPoints falha', () async {
      expect(
        () => GetPointsUsecase(repository: _FakePointRepo()..failPoints = true)(
          GetPointsParam(condoId: 'c1', meId: 'm1'),
        ),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('GetPointsNoAuthUsecase', () {
    test('rejeita param nulo', () async {
      final usecase = GetPointsNoAuthUsecase(repository: _FakePointRepo());
      expect(usecase.validate(null), isA<InvalidParamFailure>());
    });

    test('lista pendentes', () async {
      final result = await GetPointsNoAuthUsecase(repository: _FakePointRepo())(
        GetPointsNoAuthParam(),
      );
      expect(result, isA<Success<List<DigitalPointEntity>>>());
    });

    test('rejeita erro do repositório', () async {
      final result = await GetPointsNoAuthUsecase(
        repository: _FakePointRepo()..failPending = true,
      )(GetPointsNoAuthParam());
      expect(result, isA<Rejection<List<DigitalPointEntity>>>());
    });
  });

  group('GetPendingPointsUsecase', () {
    test('preenche logs dos pendentes', () async {
      final result = await GetPendingPointsUsecase(
        repository: _FakePointRepo(),
      )();
      expect(result, isA<Success<List<DigitalPointEntity>>>());
      expect((result as Success<List<DigitalPointEntity>>).get().first.id, 2);
    });

    test('lança quando pendentes falham', () async {
      expect(
        () => GetPendingPointsUsecase(
          repository: _FakePointRepo()..failPending = true,
        )(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('RequestDigitalUsecaseImpl', () {
    test('rejeita param nulo', () async {
      final usecase = RequestDigitalUsecaseImpl(
        repository: _FakePointRepo(),
        awsUploadFileUsecase: _FakeAws(),
      );
      expect(usecase.validate(null), isA<InvalidParamFailure>());
    });

    test('solicita liberação após upload', () async {
      final result = await RequestDigitalUsecaseImpl(
        repository: _FakePointRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(RequestDigitalParam(
        condoId: 'c1',
        file: testTempFile(),
        position: _position(),
      ));
      expect(result, isA<Success<bool>>());
    });

    test('rejeita falha de upload', () async {
      final result = await RequestDigitalUsecaseImpl(
        repository: _FakePointRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(RequestDigitalParam(
        condoId: 'c1',
        file: testTempFile(),
        position: _position(),
      ));
      expect(result, isA<Rejection<bool>>());
    });

    test('rejeita falha ao solicitar', () async {
      final result = await RequestDigitalUsecaseImpl(
        repository: _FakePointRepo()..failRequest = true,
        awsUploadFileUsecase: _FakeAws(),
      )(RequestDigitalParam(
        condoId: 'c1',
        file: testTempFile(),
        position: _position(),
      ));
      expect(result, isA<Rejection<bool>>());
    });
  });
}
