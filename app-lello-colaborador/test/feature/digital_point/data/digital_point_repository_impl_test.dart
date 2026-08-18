import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/failures/failures.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/digital_point/data/data_source/local/digital_point_local_data_source.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_remote_data_source.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/digital_point/data/repository/digital_point_repository_impl.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fixtures.dart';

DigitalPointModel _model({int? id}) =>
    DigitalPointModel.fromEntity(testPoint(id: id ?? 1));

class _FakeLocal extends Fake implements DigitalPointLocalDataSource {
  final List<DigitalPointModel> points = [];
  bool failSave = false;
  bool failSelect = false;

  @override
  Future<DigitalPointModel> save(
    DigitalPointModel model,
    String condoId,
    String meId,
  ) async {
    if (failSave) throw Exception('save');
    final saved = model.copyWith(id: model.id ?? points.length + 1);
    points.add(saved);
    return saved;
  }

  @override
  Future<List<DigitalPointModel>> select(
    String condoId,
    String meId,
    String status,
  ) async {
    if (failSelect) throw Exception('select');
    return points.where((p) => p.status == status).toList();
  }

  @override
  Future<List<DigitalPointModel>> selectAll(String condoId, String meId) async {
    if (failSelect) throw Exception('selectAll');
    return List.from(points);
  }

  @override
  Future<List<DigitalPointModel>> selectPendingFromDevice() async {
    if (failSelect) throw Exception('pending');
    return List.from(points);
  }

  @override
  Future<List<DigitalPointLogData>> selectLogById(int pointId) async =>
      const [];

  @override
  Future<bool> updatePointStatus({
    required int? id,
    required DigitalPointStatusEnum newStatusEnum,
  }) async {
    final idx = points.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      points[idx] = points[idx].copyWith(
        status: enumToString(newStatusEnum),
      );
    }
    return true;
  }

  @override
  void saveDigitalPointLog(
    DigitalPointModel model,
    String statusPrevious, {
    String description = '',
  }) {}

  @override
  Future<List<DigitalPointModel>> selectNoAuthList() async => [];
}

class _FakeRemote extends Fake implements DigitalPointRemoteDataSource {
  bool fail = false;
  int? registerStatus;
  int? syncStatus;
  bool throwOnSync = false;

  @override
  Future<DigitalPointModel> registerPoint(
    DigitalPointModel model,
    String condoId,
  ) async {
    if (registerStatus != null) {
      throw ApiFailure()..status = registerStatus;
    }
    if (fail) throw Exception('remote');
    return model.copyWith(status: 'sended');
  }

  @override
  Future<bool> requestDigitalPointService(
    String condoId,
    String imageHash,
  ) async {
    if (fail) throw Exception('request');
    return true;
  }

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId) async {
    if (fail) throw Exception('aws');
    return UrlUploadS3Model(fileName: 'f.jpg', url: 'http://s3');
  }

  @override
  Future<bool> checkDigitalPoint(String condoId, DateTime date) async {
    if (fail) throw Exception('check');
    return true;
  }

  @override
  Future<void> syncPointWithouLogin(DigitalPointModel model) async {
    if (syncStatus != null) {
      throw ApiFailure()..status = syncStatus;
    }
    if (throwOnSync) throw ApiFailure()..status = 406;
    if (fail) throw Exception('sync');
  }
}

class _FakeUploader extends Fake implements Uploader {
  bool fail = false;

  @override
  Future<String> uploadS3(
    String url,
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    if (fail) {
      onError(Exception('upload'));
    } else {
      onComplete('http://done');
    }
    return 'ok';
  }
}

DigitalPointRepositoryImpl _repo({
  _FakeLocal? local,
  _FakeRemote? remote,
  _FakeUploader? uploader,
}) =>
    DigitalPointRepositoryImpl(
      localDataSource: local ?? _FakeLocal(),
      remoteDataSource: remote ?? _FakeRemote(),
      uploader: uploader ?? _FakeUploader(),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('DigitalPointRepositoryImpl', () {
    test('requestDigitalPoint com sucesso', () async {
      final result = await _repo().requestDigitalPoint('c1', 'hash');
      expect(result, isA<Success<bool>>());
    });

    test('requestDigitalPoint rejeita erro', () async {
      final result = await _repo(remote: _FakeRemote()..fail = true)
          .requestDigitalPoint('c1', 'hash');
      expect(result, isA<Rejection<bool>>());
    });

    test('registerPoint com sucesso', () async {
      final result = await _repo().registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Success<DigitalPointEntity>>());
    });

    test('registerPoint rejeita 406 foto', () async {
      final result = await _repo(
        remote: _FakeRemote()..registerStatus = 406,
      ).registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
      result.fold(
        (failure) => expect(failure, isA<KnownFailure>()),
        (_) => fail('deveria falhar'),
      );
    });

    test('registerPoint rejeita 409 afastamento', () async {
      final result = await _repo(
        remote: _FakeRemote()..registerStatus = 409,
      ).registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('registerPoint rejeita 500 e salva local', () async {
      final local = _FakeLocal();
      final result = await _repo(
        local: local,
        remote: _FakeRemote()..registerStatus = 500,
      ).registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
      expect(local.points, isNotEmpty);
    });

    test('registerPoint rejeita 400', () async {
      final result = await _repo(
        remote: _FakeRemote()..registerStatus = 400,
      ).registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('savePoint persiste localmente', () async {
      final result =
          await _repo().savePoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Success<DigitalPointEntity>>());
    });

    test('savePointLog retorna entidade', () async {
      final point = testPoint();
      final result = await _repo().savePointLog(point, 'pending', 'desc');
      expect(result, isA<Success<DigitalPointEntity>>());
    });

    test('getPoints e getPointsByStatus', () async {
      final local = _FakeLocal()..points.add(_model());
      final repo = _repo(local: local);
      expect(await repo.getPoints('c1', 'm1'), isA<Success<List<DigitalPointEntity>>>());
      expect(
        await repo.getPointsByStatus('c1', 'm1', 'pending'),
        isA<Success<List<DigitalPointEntity>>>(),
      );
    });

    test('getPendingPoints lista pendentes', () async {
      final local = _FakeLocal()..points.add(_model());
      final result = await _repo(local: local).getPendingPoints();
      expect(result, isA<Success<List<DigitalPointEntity>>>());
    });

    test('getPointLogs', () async {
      final result = await _repo().getPointLogs(1);
      expect(result, isA<Success<List<DigitalPointLogData>>>());
    });

    test('getUrlAws', () async {
      final result = await _repo().getUrlAws('c1');
      expect(result, isA<Success<UrlUploadS3>>());
    });

    test('checkDigitalPoint', () async {
      final result =
          await _repo().checkDigitalPoint('c1', DateTime(2026, 1, 10));
      expect(result, isA<Success<bool>>());
    });

    test('uploadImageToAws', () async {
      final result = await _repo().uploadImageToAws(testTempFile(), 'url');
      expect(result, isA<Success<String>>());
    });

    test('uploadImageToAws rejeita erro', () async {
      final result = await _repo(uploader: _FakeUploader()..fail = true)
          .uploadImageToAws(testTempFile(), 'url');
      expect(result, isA<Rejection<String>>());
    });

    test('syncPoints sincroniza lista', () async {
      final local = _FakeLocal()..points.add(_model());
      final result = await _repo(local: local).syncPoints(
        'c1',
        'm1',
        [testPoint(id: 1)],
      );
      expect(result, isA<Success<List<DigitalPointEntity>>>());
    });

    test('syncPoints rejeita foto recusada', () async {
      final local = _FakeLocal()..points.add(_model());
      final result = await _repo(
        local: local,
        remote: _FakeRemote()..registerStatus = 406,
      ).syncPoints('c1', 'm1', [testPoint(id: 1)]);
      expect(result, isA<Rejection<List<DigitalPointEntity>>>());
      result.fold(
        (failure) => expect(failure, isA<DigitalPointSendFailure>()),
        (_) => fail('deveria falhar'),
      );
    });

    test('syncPoints rejeita afastamento', () async {
      final result = await _repo(
        remote: _FakeRemote()..registerStatus = 409,
      ).syncPoints('c1', 'm1', [testPoint(id: 1)]);
      expect(result, isA<Rejection<List<DigitalPointEntity>>>());
    });

    test('syncPoints rejeita erro de servidor', () async {
      final result = await _repo(
        remote: _FakeRemote()..registerStatus = 500,
      ).syncPoints('c1', 'm1', [testPoint(id: 1)]);
      expect(result, isA<Rejection<List<DigitalPointEntity>>>());
    });

    test('getUrlAws rejeita erro remoto', () async {
      final result =
          await _repo(remote: _FakeRemote()..fail = true).getUrlAws('c1');
      expect(result, isA<Rejection<UrlUploadS3>>());
    });

    test('checkDigitalPoint rejeita erro remoto', () async {
      final result = await _repo(remote: _FakeRemote()..fail = true)
          .checkDigitalPoint('c1', DateTime(2026, 1, 10));
      expect(result, isA<Rejection<bool>>());
    });

    test('syncPointWithoutLogin atualiza status', () async {
      final result = await _repo().syncPointWithoutLogin(point: testPoint(id: 1));
      expect(result, isA<Success<void>>());
    });

    test('syncPointWithoutLogin rejeita 406', () async {
      expect(
        () => _repo(remote: _FakeRemote()..throwOnSync = true)
            .syncPointWithoutLogin(point: testPoint(id: 1)),
        throwsA(isA<KnownFailure>()),
      );
    });

    test('registerPoint rejeita status desconhecido', () async {
      final result = await _repo(
        remote: _FakeRemote()..registerStatus = 418,
      ).registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('registerPoint rejeita exceção genérica', () async {
      final result = await _repo(remote: _FakeRemote()..fail = true)
          .registerPoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('savePoint rejeita erro local', () async {
      final result = await _repo(local: _FakeLocal()..failSave = true)
          .savePoint(testPoint(), 'c1', 'm1');
      expect(result, isA<Rejection<DigitalPointEntity>>());
    });

    test('syncPointWithoutLogin rejeita 409', () async {
      expect(
        () => _repo(remote: _FakeRemote()..syncStatus = 409)
            .syncPointWithoutLogin(point: testPoint(id: 1)),
        throwsA(isA<KnownFailure>()),
      );
    });

    test('syncPointWithoutLogin rejeita 500', () async {
      expect(
        () => _repo(remote: _FakeRemote()..syncStatus = 500)
            .syncPointWithoutLogin(point: testPoint(id: 1)),
        throwsA(isA<KnownFailure>()),
      );
    });

    test('syncPoints rejeita status desconhecido', () async {
      expect(
        () => _repo(
          remote: _FakeRemote()..registerStatus = 418,
        ).syncPoints('c1', 'm1', [testPoint(id: 1)]),
        throwsA(isA<Rejection>()),
      );
    });

    test('erros de leitura local retornam Rejection', () async {
      final repo = _repo(local: _FakeLocal()..failSelect = true);
      expect(await repo.getPoints('c1', 'm1'), isA<Rejection>());
      expect(
        await repo.getPointsByStatus('c1', 'm1', 'pending'),
        isA<Rejection>(),
      );
      expect(await repo.getPendingPoints(), isA<Rejection>());
    });
  });
}
