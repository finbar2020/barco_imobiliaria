import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_by_status_usecase.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_remote_data_source.dart';
import 'package:colaborador/feature/employee_referral/data/model/city_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';
import 'package:colaborador/feature/employee_referral/data/repository/employee_referral_repository_impl.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_remote_data_source.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';
import 'package:colaborador/feature/manual_timesheet/data/repository/manual_timesheet_repository_impl.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/data/model/me_password_model.dart';
import 'package:colaborador/feature/me/data/repository/me_repository_impl.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:colaborador/feature/preferences/data/repository/preferences_repository_impl.dart';
import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source.dart';
import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/data/model/proof_model.dart';
import 'package:colaborador/feature/proof/data/repository/proof_repository_impl.dart';
import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/session/data/data_source/session_local_data_source.dart';
import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:colaborador/feature/session/data/repository/session_repository_impl.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_remote_data_source.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';
import 'package:colaborador/feature/sick_note/data/repository/sick_note_repository_impl.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_remote_data_source.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_element_detail_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_periods_model.dart';
import 'package:colaborador/feature/timesheet/data/repository/timesheet_repository_impl.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull, equals;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';

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
      onError(Exception('boom'));
    } else {
      onComplete('http://done');
    }
    return 'ok';
  }
}

class _FakeProofRemote extends Fake implements ProofRemoteDataSource {
  bool fail = false;

  @override
  Future<List<ProofModel>> getProof(condominiumId, DateTime date) async {
    if (fail) throw Exception('boom');
    return [
      ProofModel(nsr: 2, dateTimeClockIn: '09:00', proofName: 'b'),
      ProofModel(nsr: 1, dateTimeClockIn: '08:00', proofName: 'a'),
    ];
  }

  @override
  Future<ProofFileModel> getFileProof(String condominiumId, String fileName) async {
    if (fail) throw Exception('boom');
    return ProofFileModel(contentBytes: 'abc');
  }
}

class _FakeTimesheetRemote extends Fake implements TimesheetRemoteDataSource {
  bool fail = false;

  @override
  Future<TimesheetModel> getTimesheet(String condominiumId, DateTime period) async {
    if (fail) throw Exception('boom');
    return TimesheetModel(
      dateFrom: DateTime(2026, 1, 1),
      dateTo: DateTime(2026, 1, 31),
      dateLiberation: null,
      timesheetStatus: 'notAssigned',
      timesheetElements: const [],
    );
  }

  @override
  Future<List<TimesheetElementDetailModel>> getTimesheetDetail(
      String condominiumId, DateTime period) async {
    if (fail) throw Exception('boom');
    return [
      TimesheetElementDetailModel(
        time: '08:00',
        timesheetFlag: 'inserted',
        date: DateTime(2026, 1, 10),
      ),
    ];
  }

  @override
  Future<List<TimesheetPeriodsModel>> getTimesheetPeriods(String condominiumId) async {
    if (fail) throw Exception('boom');
    return [
      TimesheetPeriodsModel(
        periodMonth: DateTime(2026, 1),
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    ];
  }

  @override
  Future<bool> sendEmail(String condominiumId, String email, DateTime period) async {
    if (fail) throw Exception('boom');
    return true;
  }

  @override
  Future<bool> signTimesheet(
      String condominiumId, String timesheetSignType, DateTime period) async {
    if (fail) throw Exception('boom');
    return true;
  }
}

class _FakePrefsRemote extends Fake implements PreferencesDataSource {
  bool fail = false;

  @override
  Future<List<PreferencesNotificationModel>> getPreferencesNotification() async {
    if (fail) throw Exception('boom');
    return [PreferencesNotificationModel(active: true, module: 'gdp')];
  }

  @override
  Future<String> putPreferencesNotification(
      List<PreferencesNotificationModel> model) async {
    if (fail) throw Exception('boom');
    return 'ok';
  }
}

class _FakeSickRemote extends Fake implements SickNoteRemoteDataSource {
  bool fail = false;

  @override
  Future<SickNoteModel> registerSickNote(SickNoteModel model, String condoId) async {
    if (fail) throw Exception('boom');
    return model;
  }

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId) async {
    if (fail) throw Exception('boom');
    return UrlUploadS3Model(fileName: 'f', url: 'http://s3');
  }
}

class _FakeManualRemote extends Fake implements ManualTimeSheetRemoteDataSource {
  bool fail = false;

  @override
  Future<ManualTimeSheetModel> registerManualTimeSheet(
      ManualTimeSheetModel model, String condoId) async {
    if (fail) throw Exception('boom');
    return model;
  }

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId) async {
    if (fail) throw Exception('boom');
    return UrlUploadS3Model(fileName: 'f', url: 'http://s3');
  }
}

class _FakeReferralRemote extends Fake implements EmployeeReferralRemoteDataSource {
  bool fail = false;

  @override
  Future<EmployeeReferralModel> registerEmployeeReferral(
      EmployeeReferralModel model, String condoId, String employeeId) async {
    if (fail) throw Exception('boom');
    return model;
  }

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId, String employeeId) async {
    if (fail) throw Exception('boom');
    return UrlUploadS3Model(fileName: 'f', url: 'http://s3');
  }

  @override
  Future<List<CityModel>> getCities(String condoId, String employeeId) async {
    if (fail) throw Exception('boom');
    return [CityModel(name: 'SP', regions: const ['sul'])];
  }
}

class _FakeMeLocal extends Fake implements MeLocalDataSource {
  MeModel? stored;
  bool fail = false;

  @override
  Future<MeModel?> select() async {
    if (fail) throw Exception('boom');
    return stored;
  }

  @override
  Future<MeModel?> save(MeModel? model) async {
    if (fail) throw Exception('boom');
    stored = model;
    return model;
  }
}

class _FakeMeRemote extends Fake implements MeRemoteDataSource {
  bool fail = false;

  @override
  Future<MeModel> patch(MeModel me, String code) async {
    if (fail) throw Exception('boom');
    return me;
  }

  @override
  Future updatePassword(MePasswordModel model) async {
    if (fail) throw Exception('boom');
  }
}

class _FakeSessionLocal extends Fake implements SessionLocalDataSource {
  SessionModel? stored;
  bool fail = false;

  @override
  Future<SessionModel?> select() async {
    if (fail) throw Exception('boom');
    return stored;
  }

  @override
  Future<SessionModel?> save(SessionModel? model) async {
    if (fail) throw Exception('boom');
    stored = model;
    return model;
  }
}

class _FakePointRepo extends Fake implements DigitalPointRepository {
  @override
  Future<Try<List<DigitalPointEntity>>> getPointsByStatus(
      String condoId, String meId, String status) async {
    return Success([testPoint()]);
  }
}

void main() {
  group('ProofRepositoryImpl', () {
    test('ordena comprovantes por nsr', () async {
      final result = await ProofRepositoryImpl(remoteDataSource: _FakeProofRemote())
          .getProof('c1', DateTime(2026, 1, 10));
      final list = (result as Success<List<ProofEntity>>).get();
      expect(list.map((e) => e.nsr), [1, 2]);
    });

    test('rejeita erros e carrega arquivo', () async {
      final fail = ProofRepositoryImpl(remoteDataSource: _FakeProofRemote()..fail = true);
      expect(await fail.getProof('c1', DateTime(2026, 1, 1)), isA<Rejection<List<ProofEntity>>>());
      expect(await fail.getProofFile('c1', 'a.pdf'), isA<Rejection<ProofFileEntity>>());

      final ok = await ProofRepositoryImpl(remoteDataSource: _FakeProofRemote())
          .getProofFile('c1', 'a.pdf');
      expect((ok as Success<ProofFileEntity>).get().contentBytes, 'abc');
    });
  });

  group('TimesheetRepositoryImpl', () {
    final period = DateTime(2026, 1, 10);

    test('devolve sucesso em todos os métodos', () async {
      final repo = TimesheetRepositoryImpl(remoteDataSource: _FakeTimesheetRemote());
      expect(await repo.getTimesheet('c1', period), isA<Success<Timesheet>>());
      expect(
        await repo.getTimesheetDetail('c1', period),
        isA<Success<List<TimesheetElementDetail>>>(),
      );
      expect(
        await repo.getTimesheetPeriods('c1'),
        isA<Success<List<TimesheetPeriods>>>(),
      );
      expect(await repo.sendEmail('c1', 'a@b.com', period), isA<Success<bool>>());
      expect(
        await repo.signTimesheet('c1', TimesheetSignTypeEnum.espelho, period),
        isA<Success<bool>>(),
      );
    });

    test('rejeita erros', () async {
      final repo = TimesheetRepositoryImpl(
        remoteDataSource: _FakeTimesheetRemote()..fail = true,
      );
      expect(await repo.getTimesheet('c1', period), isA<Rejection<Timesheet>>());
      expect(
        await repo.getTimesheetDetail('c1', period),
        isA<Rejection<List<TimesheetElementDetail>>>(),
      );
      expect(
        await repo.getTimesheetPeriods('c1'),
        isA<Rejection<List<TimesheetPeriods>>>(),
      );
      expect(await repo.sendEmail('c1', 'a@b.com', period), isA<Rejection<bool>>());
      expect(
        await repo.signTimesheet('c1', TimesheetSignTypeEnum.holerite, period),
        isA<Rejection<bool>>(),
      );
    });
  });

  group('PreferencesRepositoryImpl', () {
    test('get e put', () async {
      final repo = PreferencesRepositoryImpl(dataSource: _FakePrefsRemote());
      final got = await repo.getPreferencesNotification();
      expect((got as Success<List<PreferencesNotificationEntity>>).get().first.module, 'gdp');
      expect(
        await repo.putPreferencesNotification([
          PreferencesNotificationEntity(active: true, module: 'gdp'),
        ]),
        isA<Success<String>>(),
      );
    });

    test('rejeita erros', () async {
      final repo = PreferencesRepositoryImpl(dataSource: _FakePrefsRemote()..fail = true);
      expect(
        await repo.getPreferencesNotification(),
        isA<Rejection<List<PreferencesNotificationEntity>>>(),
      );
      expect(
        await repo.putPreferencesNotification(const []),
        isA<Rejection<String>>(),
      );
    });
  });

  group('SickNoteRepositoryImpl', () {
    test('registra, busca url e envia ao S3', () async {
      final repo = SickNoteRepositoryImpl(
        remoteDataSource: _FakeSickRemote(),
        uploader: _FakeUploader(),
      );
      expect(
        await repo.registerSickNote(SickNoteEntity(date: DateTime(2026, 1, 1)), 'c1', 'm1'),
        isA<Success<SickNoteEntity>>(),
      );
      expect(await repo.getUrlAws('c1'), isA<Success<UrlUploadS3>>());
      expect(await repo.uploadImageToAws(testTempFile(), 'http://s3'), isA<Success<String>>());
    });

    test('rejeita erros', () async {
      final repo = SickNoteRepositoryImpl(
        remoteDataSource: _FakeSickRemote()..fail = true,
        uploader: _FakeUploader()..fail = true,
      );
      expect(
        await repo.registerSickNote(SickNoteEntity(), 'c1', 'm1'),
        isA<Rejection<SickNoteEntity>>(),
      );
      expect(await repo.getUrlAws('c1'), isA<Rejection<UrlUploadS3>>());
      expect(await repo.uploadImageToAws(testTempFile(), 'http://s3'), isA<Rejection<String>>());
    });
  });

  group('ManualTimeSheetRepositoryImpl', () {
    test('registra e busca url', () async {
      final repo = ManualTimeSheetRepositoryImpl(
        remoteDataSource: _FakeManualRemote(),
        uploader: _FakeUploader(),
      );
      expect(
        await repo.registerManualTimeSheet(ManualTimeSheetEntity(), 'c1', 'm1'),
        isA<Success<ManualTimeSheetEntity>>(),
      );
      expect(await repo.getUrlAws('c1'), isA<Success<UrlUploadS3>>());
      expect(await repo.uploadImageToAws(testTempFile(), 'http://s3'), isA<Success<String>>());
    });

    test('rejeita erros', () async {
      final repo = ManualTimeSheetRepositoryImpl(
        remoteDataSource: _FakeManualRemote()..fail = true,
        uploader: _FakeUploader()..fail = true,
      );
      expect(
        await repo.registerManualTimeSheet(ManualTimeSheetEntity(), 'c1', 'm1'),
        isA<Rejection<ManualTimeSheetEntity>>(),
      );
      expect(await repo.getUrlAws('c1'), isA<Rejection<UrlUploadS3>>());
      expect(await repo.uploadImageToAws(testTempFile(), 'http://s3'), isA<Rejection<String>>());
    });
  });

  group('EmployeeReferralRepositoryImpl', () {
    test('registra, lista cidades e busca url', () async {
      final repo = EmployeeReferralRepositoryImpl(
        remoteDataSource: _FakeReferralRemote(),
        uploader: _FakeUploader(),
      );
      expect(
        await repo.registerEmployeeReferral(EmployeeReferralEntity(), 'c1', 'm1'),
        isA<Success<EmployeeReferralEntity>>(),
      );
      expect(await repo.getCities('c1', 'm1'), isA<Success<List<CityEntity>>>());
      expect(await repo.getUrlAws('c1', 'm1'), isA<Success<UrlUploadS3>>());
      expect(await repo.uploadImageToAws(testTempFile(), 'http://s3'), isA<Success<String>>());
    });

    test('rejeita erros', () async {
      final repo = EmployeeReferralRepositoryImpl(
        remoteDataSource: _FakeReferralRemote()..fail = true,
        uploader: _FakeUploader()..fail = true,
      );
      expect(
        await repo.registerEmployeeReferral(EmployeeReferralEntity(), 'c1', 'm1'),
        isA<Rejection<EmployeeReferralEntity>>(),
      );
      expect(await repo.getCities('c1', 'm1'), isA<Rejection<List<CityEntity>>>());
      expect(await repo.getUrlAws('c1', 'm1'), isA<Rejection<UrlUploadS3>>());
      expect(await repo.uploadImageToAws(testTempFile(), 'http://s3'), isA<Rejection<String>>());
    });
  });

  group('MeRepositoryImpl', () {
    test('save, cache, senha e clear', () async {
      final local = _FakeMeLocal();
      final repo = MeRepositoryImpl(
        localDataSource: local,
        remoteDataSource: _FakeMeRemote(),
      );
      expect(await repo.save(testMe(), 'code'), isA<Success<Me?>>());
      expect(await repo.selectFromCache(), isA<Success<Me?>>());
      expect(await repo.updatePassword('1', 'old', 'new'), isA<Success<Me?>>());
      expect(await repo.clear(), isA<Success<Nothing>>());
    });

    test('rejeita erros', () async {
      final repo = MeRepositoryImpl(
        localDataSource: _FakeMeLocal()..fail = true,
        remoteDataSource: _FakeMeRemote()..fail = true,
      );
      expect(await repo.save(testMe(), 'code'), isA<Rejection<Me?>>());
      expect(await repo.selectFromCache(), isA<Rejection<Me?>>());
      expect(await repo.updatePassword('1', 'old', 'new'), isA<Rejection<Me?>>());
      expect(await repo.clear(), isA<Rejection<Nothing>>());
    });
  });

  group('SessionRepositoryImpl', () {
    test('save, select e clear', () async {
      final repo = SessionRepositoryImpl(sessionDataSource: _FakeSessionLocal());
      expect(await repo.save(testSession()), isA<Success<SessionModel?>>());
      expect(await repo.select(), isA<Success<SessionModel?>>());
      expect(await repo.clear(), isA<Success<Nothing>>());
    });

    test('rejeita erros', () async {
      final repo = SessionRepositoryImpl(
        sessionDataSource: _FakeSessionLocal()..fail = true,
      );
      expect(await repo.save(testSession()), isA<Rejection<SessionModel?>>());
      expect(await repo.select(), isA<Rejection<SessionModel?>>());
      expect(await repo.clear(), isA<Rejection<Nothing>>());
    });
  });

  group('GetPointsByStatusUsecase', () {
    test('rejeita param nulo e busca pontos', () async {
      final usecase = GetPointsByStatusUsecase(repository: _FakePointRepo());
      expect(
        await usecase.call(GetPointsByStatusParam(condoId: 'c1', meId: 'm1', pointStatus: 'pending')),
        isA<Success<List<DigitalPointEntity>>>(),
      );
      expect(usecase.validate(null), isA<InvalidParamFailure>());
    });
  });
}
