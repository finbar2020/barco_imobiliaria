import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/repository/manual_timesheet_repository.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/upload_sick_note_to_aws/upload_manual_timesheet_to_aws.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/upload_sick_note_to_aws/upload_manual_timesheet_to_aws_impl.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/repository/sick_note_repository.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/upload_sick_note_to_aws/upload_sick_note_to_aws.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/upload_sick_note_to_aws/upload_sick_note_to_aws_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fixtures.dart';

class _FakeSickRepo extends Fake implements SickNoteRepository {
  bool failAws = false;

  @override
  Future<Try<UrlUploadS3>> getUrlAws(String condoId) async {
    if (failAws) return Rejection(UnknownFailure('aws'));
    return Success(UrlUploadS3(fileName: 'sick.png', url: 'http://s3'));
  }
}

class _FakeManualRepo extends Fake implements ManualTimeSheetRepository {
  bool failAws = false;

  @override
  Future<Try<UrlUploadS3>> getUrlAws(String condoId) async {
    if (failAws) return Rejection(UnknownFailure('aws'));
    return Success(UrlUploadS3(fileName: 'folha.pdf', url: 'http://s3'));
  }
}

class _FakeAws extends Fake implements AwsUploadFileUsecase {
  bool fail = false;

  @override
  Future<Try<UrlUploadS3>> call(AwsUploadFileParam params) async {
    if (fail) return Rejection(UnknownFailure('upload'));
    return Success(UrlUploadS3(fileName: 'uploaded.bin', url: 'http://s3'));
  }
}

void main() {
  group('UploadSickNoteToAwsUsecaseImpl', () {
    test('rejeita param nulo', () async {
      final usecase = UploadSickNoteToAwsUsecaseImpl(
        repository: _FakeSickRepo(),
        awsUploadFileUsecase: _FakeAws(),
      );
      expect(usecase.validate(null), isA<InvalidParamFailure>());
    });

    test('grava hash após upload', () async {
      final file = testTempFile();
      final entity = SickNoteEntity(
        date: DateTime(2026, 1, 10),
        filePath: file.path,
      );
      final result = await UploadSickNoteToAwsUsecaseImpl(
        repository: _FakeSickRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(UploadSickNoteToAwsParam(
        sickNoteEntity: entity,
        condoId: 'c1',
        getUrlUploadS3: (_) async =>
            Success(UrlUploadS3(fileName: 'x', url: 'u')),
        uploadFileToS3: (_, __) async => Success('ok'),
      ));
      expect(result, isA<Success<SickNoteEntity>>());
      expect(entity.fileTempHash, 'uploaded.bin');
    });

    test('rejeita falha de upload', () async {
      final file = testTempFile();
      final result = await UploadSickNoteToAwsUsecaseImpl(
        repository: _FakeSickRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(UploadSickNoteToAwsParam(
        sickNoteEntity: SickNoteEntity(
          date: DateTime(2026, 1, 10),
          filePath: file.path,
        ),
        condoId: 'c1',
        getUrlUploadS3: (_) async =>
            Success(UrlUploadS3(fileName: 'x', url: 'u')),
        uploadFileToS3: (_, __) async => Success('ok'),
      ));
      expect(result, isA<Rejection<SickNoteEntity>>());
    });
  });

  group('UploadManualTimeSheetToAwsUsecaseImpl', () {
    test('rejeita param nulo', () async {
      final usecase = UploadManualTimeSheetToAwsUsecaseImpl(
        repository: _FakeManualRepo(),
        awsUploadFileUsecase: _FakeAws(),
      );
      expect(usecase.validate(null), isA<InvalidParamFailure>());
    });

    test('grava hash após upload', () async {
      final file = testTempFile();
      final entity = ManualTimeSheetEntity(
        date: DateTime(2026, 1, 1),
        filePath: file.path,
      );
      final result = await UploadManualTimeSheetToAwsUsecaseImpl(
        repository: _FakeManualRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(UploadManualTimeSheetToAwsParam(
        manualTimeSheetEntity: entity,
        condoId: 'c1',
        getUrlUploadS3: (_) async =>
            Success(UrlUploadS3(fileName: 'x', url: 'u')),
        uploadFileToS3: (_, __) async => Success('ok'),
      ));
      expect(result, isA<Success<ManualTimeSheetEntity>>());
      expect(entity.fileTempHash, 'uploaded.bin');
    });

    test('rejeita falha de upload', () async {
      final file = testTempFile();
      final result = await UploadManualTimeSheetToAwsUsecaseImpl(
        repository: _FakeManualRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(UploadManualTimeSheetToAwsParam(
        manualTimeSheetEntity: ManualTimeSheetEntity(
          date: DateTime(2026, 1, 1),
          filePath: file.path,
        ),
        condoId: 'c1',
        getUrlUploadS3: (_) async =>
            Success(UrlUploadS3(fileName: 'x', url: 'u')),
        uploadFileToS3: (_, __) async => Success('ok'),
      ));
      expect(result, isA<Rejection<ManualTimeSheetEntity>>());
    });
  });
}
