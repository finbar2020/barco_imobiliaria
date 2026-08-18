import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/repository/manual_timesheet_repository.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fixtures.dart';

class _FakeRepo extends Fake implements ManualTimeSheetRepository {
  ManualTimeSheetEntity? last;

  @override
  Future<Try<ManualTimeSheetEntity>> registerManualTimeSheet(
    ManualTimeSheetEntity entity,
    String condoId,
    String meId,
  ) async {
    last = entity;
    return Success(entity);
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
  group('ManualTimeSheetEntity', () {
    test('isValid exige arquivo e data', () {
      expect(ManualTimeSheetEntity().isValid, isFalse);
      expect(
        ManualTimeSheetEntity(date: DateTime(2026, 1, 10)).isValid,
        isFalse,
      );
      expect(
        ManualTimeSheetEntity(
          date: DateTime(2026, 1, 10),
          file: testTempFile(),
        ).isValid,
        isTrue,
      );
    });
  });

  group('RegisterManualTimeSheetUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        RegisterManualTimeSheetUsecaseImpl(
          repository: _FakeRepo(),
          awsUploadFileUsecase: _FakeAws(),
        ).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita sem arquivo', () async {
      final result = await RegisterManualTimeSheetUsecaseImpl(
        repository: _FakeRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterManualTimeSheetParam(
        condoId: 'c1',
        meId: 'm1',
        manualTimeSheetEntity: ManualTimeSheetEntity(
          date: DateTime(2026, 1, 10),
        ),
      ));
      expect(result, isA<Rejection<ManualTimeSheetEntity>>());
    });

    test('rejeita falha de upload', () async {
      final result = await RegisterManualTimeSheetUsecaseImpl(
        repository: _FakeRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(RegisterManualTimeSheetParam(
        condoId: 'c1',
        meId: 'm1',
        manualTimeSheetEntity: ManualTimeSheetEntity(
          date: DateTime(2026, 1, 10),
          file: testTempFile(),
        ),
      ));
      expect(result, isA<Rejection<ManualTimeSheetEntity>>());
    });

    test('registra após upload', () async {
      final repo = _FakeRepo();
      final entity = ManualTimeSheetEntity(
        date: DateTime(2026, 1, 10),
        file: testTempFile(),
      );
      final result = await RegisterManualTimeSheetUsecaseImpl(
        repository: repo,
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterManualTimeSheetParam(
        condoId: 'c1',
        meId: 'm1',
        manualTimeSheetEntity: entity,
      ));
      expect(result, isA<Success<ManualTimeSheetEntity>>());
      expect(entity.fileTempHash, 'hash.png');
      expect(repo.last, entity);
    });
  });
}
