import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/repository/sick_note_repository.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fixtures.dart';

class _FakeSickRepo extends Fake implements SickNoteRepository {
  SickNoteEntity? last;

  @override
  Future<Try<SickNoteEntity>> registerSickNote(
    SickNoteEntity entity,
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
  group('RegisterSickNoteUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        RegisterSickNoteUsecaseImpl(
          repository: _FakeSickRepo(),
          awsUploadFileUsecase: _FakeAws(),
        ).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita sem arquivo', () async {
      final result = await RegisterSickNoteUsecaseImpl(
        repository: _FakeSickRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterSickNoteParam(
        condoId: 'c1',
        meId: 'm1',
        sickNoteEntity: SickNoteEntity(date: DateTime(2026, 1, 10)),
      ));
      expect(result, isA<Rejection<SickNoteEntity>>());
    });

    test('rejeita sem data', () async {
      final result = await RegisterSickNoteUsecaseImpl(
        repository: _FakeSickRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterSickNoteParam(
        condoId: 'c1',
        meId: 'm1',
        sickNoteEntity: SickNoteEntity(file: testTempFile()),
      ));
      expect(result, isA<Rejection<SickNoteEntity>>());
    });

    test('rejeita falha de upload', () async {
      final result = await RegisterSickNoteUsecaseImpl(
        repository: _FakeSickRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(RegisterSickNoteParam(
        condoId: 'c1',
        meId: 'm1',
        sickNoteEntity: SickNoteEntity(
          date: DateTime(2026, 1, 10),
          file: testTempFile(),
        ),
      ));
      expect(result, isA<Rejection<SickNoteEntity>>());
    });

    test('registra após upload', () async {
      final repo = _FakeSickRepo();
      final entity = SickNoteEntity(
        date: DateTime(2026, 1, 10),
        file: testTempFile(),
      );
      final result = await RegisterSickNoteUsecaseImpl(
        repository: repo,
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterSickNoteParam(
        condoId: 'c1',
        meId: 'm1',
        sickNoteEntity: entity,
      ));
      expect(result, isA<Success<SickNoteEntity>>());
      expect(entity.fileTempHash, 'hash.png');
      expect(repo.last, entity);
    });
  });
}
