import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/documents/data/model/document_file_model.dart';
import 'package:colaborador/feature/documents/data/model/document_info_model.dart';
import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/employee_referral/data/model/city_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/me/data/model/condominium_model.dart';
import 'package:colaborador/feature/me/data/model/geographic_coordinates_model.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/data/model/me_password_model.dart';
import 'package:colaborador/feature/me/data/model/work_shift_details_model.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/entity/geographic_coordinates.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:colaborador/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/data/model/proof_model.dart';
import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_element_detail_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_element_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_periods_model.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('MeModel', () {
    test('fromEntity nulo e roundtrip', () {
      expect(MeModel.fromEntity(null), isNull);
      final model = MeModel.fromEntity(testMe())!;
      expect(model.toEntity().id, 'm1');
      expect(model.toEntity().name, 'ana silva');
      final json = MeModel.fromJson({
        'id': 'm1',
        'name': 'ana',
        'email': 'a@b.com',
        'cpf': '1',
        'phone': '2',
        'picture_hash': 'h',
        'is_tablet_session': true,
        'condominiums': const [],
      });
      expect(json.id, 'm1');
      expect(json.toJson()['name'], 'ana');
    });
  });

  group('CondominiumModel', () {
    test('fromEntity nulo e toEntity', () {
      expect(CondominiumModel.fromEntity(null), isNull);
      final model = CondominiumModel.fromEntity(testCondominium())!;
      expect(model.toEntity().id, 'c1');
      final json = CondominiumModel.fromJson({
        'id': 'c2',
        'name': 'X',
        'reference': 'R2',
        'job_position': 'zelador',
        'work_shift': 'noite',
        'work_leave_description': '',
        'should_ignore_digital_point': false,
        'digital_timesheet_status': 'approved',
        'digital_timesheet_device_allowed': 'tablet',
        'geographic_coordinates': {'longitude': '1', 'latitude': '2'},
        'work_shift_details': [
          {
            'badage_number': '1',
            'entry1': '08:00:00',
            'out1': '12:00:00',
            'entry2': '13:00:00',
            'out2': '17:00:00',
            'is_day_off': false,
            'date': '2026-01-10T00:00:00.000',
            'reference': 'R2',
          }
        ],
      });
      expect(json.toEntity().digitalTimesheetStatus, DigitalTimesheetStatusEnum.approved);
      expect(json.toJson()['id'], 'c2');
    });
  });

  group('GeographicCoordinatesModel e WorkShiftDetailsModel', () {
    test('converte entidade e json', () {
      expect(GeographicCoordinatesModel.fromEntity(null), isNull);
      final coords = GeographicCoordinatesModel.fromEntity(
        GeographicCoordinates(longitude: '1', latitude: '2'),
      )!;
      expect(coords.toEntity().longitude, '1');
      expect(GeographicCoordinatesModel.fromJson({'longitude': '3', 'latitude': '4'}).latitude, '4');

      expect(WorkShiftDetailsModel.fromEntity(null), isNull);
      final shift = WorkShiftDetails(
        badageNumber: '1',
        entry1: '08:00:00',
        out1: '12:00:00',
        entry2: '13:00:00',
        out2: '17:00:00',
        isDayOff: false,
        date: DateTime(2026, 1, 10),
        reference: 'R1',
      );
      expect(WorkShiftDetailsModel.fromEntity(shift)!.toEntity().entry1, '08:00:00');
    });
  });

  group('SessionModel', () {
    test('isValid e fromEntity', () {
      expect(SessionModel.fromEntity(null), isNull);
      expect(SessionModel().isValid, isFalse);
      expect(SessionModel(meModel: MeModel()).isValid, isFalse);
      final model = SessionModel.fromEntity(testSession())!;
      expect(model.isValid, isTrue);
      expect(model.toEntity()?.me.id, 'm1');
      expect(SessionModel.fromJson({}).toEntity(), isNull);
    });
  });

  group('MePasswordModel', () {
    test('init e json', () {
      final model = MePasswordModel.init('123', 'old', 'new');
      expect(model.cpf, '123');
      expect(model.originPassword, 'old');
      expect(MePasswordModel.fromJson({'cpf': '9'}).cpf, '9');
      expect(model.toJson()['password'], 'new');
    });
  });

  group('Timesheet models', () {
    test('fromEntity nulo e roundtrip', () {
      expect(TimesheetModel.fromEntity(null), isNull);
      expect(TimesheetElementModel.fromEntity(null), isNull);
      expect(TimesheetElementDetailModel.fromEntity(null), isNull);
      expect(TimesheetPeriodsModel.fromEntity(null), isNull);

      final timesheet = Timesheet(
        dateFrom: DateTime(2026, 1, 1),
        dateTo: DateTime(2026, 1, 31),
        dateLiberation: DateTime(2026, 2, 1),
        timesheetStatus: TimesheetStatusEnum.assigned,
        timesheetElements: [
          TimesheetElement(
            date: DateTime(2026, 1, 10),
            times: const ['08:00'],
            journey: '8h',
            hasTreatment: true,
            dayOff: false,
          ),
        ],
      );
      final model = TimesheetModel.fromEntity(timesheet)!;
      expect(model.toEntity().timesheetStatus, TimesheetStatusEnum.assigned);
      expect(model.toEntity().timesheetElements.first.journey, '8h');

      final json = TimesheetModel.fromJson({
        'date_from': '2026-01-01T00:00:00.000',
        'date_to': '2026-01-31T00:00:00.000',
        'timesheet_status': 'notAssigned',
        'timesheet_elements': [
          {
            'date': '2026-01-10T00:00:00.000',
            'times': ['08:00'],
            'journey': '8h',
            'has_treatment': false,
            'day_off': true,
          }
        ],
      });
      expect(json.toEntity().timesheetElements.first.dayOff, isTrue);
      json.toJson();

      final detail = TimesheetElementDetailModel.fromEntity(
        TimesheetElementDetail(
          time: '08:00',
          timesheetFlag: TimesheetPointFlagEnum.inserted,
          date: DateTime(2026, 1, 10),
        ),
      )!;
      expect(detail.toEntity()!.time, '08:00');

      final period = TimesheetPeriodsModel.fromEntity(
        TimesheetPeriods(
          periodMonth: DateTime(2026, 1),
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
        ),
      )!;
      expect(period.toEntity()!.periodMonth.month, 1);
    });
  });

  group('Proof, sick note, manual, referral, prefs, documents', () {
    test('converte entidades', () {
      final proof = ProofModel.fromEntity(
        ProofEntity(nsr: 2, dateTimeClockIn: '08:00', proofName: 'p'),
      );
      expect(proof.toEntity().nsr, 2);
      expect(ProofModel.fromJson({'date_time_clock_in': '09:00', 'proof_name': 'x'}).proofName, 'x');

      final file = ProofFileModel.fromEntity(ProofFileEntity(contentBytes: 'abc'));
      expect(file.toEntity().contentBytes, 'abc');
      expect(ProofFileModel.fromJson({'content_bytes': 'z'}).contentBytes, 'z');

      final sick = SickNoteModel.fromEntity(
        SickNoteEntity(date: DateTime(2026, 1, 10), fileTempHash: 'h', typeFile: '.pdf', sickNoteDays: 2),
      );
      expect(sick.toEntity().fileTempHash, 'h');
      expect(SickNoteModel.fromJson({'file_hash': 'x', 'file_extension': '.png'}).fileExtension, '.png');

      final manual = ManualTimeSheetModel.fromEntity(
        ManualTimeSheetEntity(date: DateTime(2026, 1, 1), fileTempHash: 'h'),
      );
      expect(manual.toEntity().fileTempHash, 'h');

      final referral = EmployeeReferralModel.fromEntity(
        EmployeeReferralEntity(description: 'vaga', city: 'SP', region: 'sul', fileTempHash: 'h'),
      );
      expect(referral.toEntity().city, 'SP');

      final city = CityModel.fromEntity(CityEntity(name: 'SP', regions: const ['sul']));
      expect(city.toEntity().name, 'SP');
      expect(CityModel.fromJson({'name': 'RJ', 'regions': <String>[]}).name, 'RJ');

      final pref = PreferencesNotificationModel.fromEntity(
        PreferencesNotificationEntity(active: true, module: 'gdp'),
      );
      expect(pref.toEntity().module, 'gdp');
      expect(PreferencesNotificationModel.fromJson({'active': false, 'module': 'mkt'}).active, isFalse);

      final doc = DocumentInfoModel.fromEntity(
        DocumentInfo(
          name: 'h.pdf',
          type: DocumentTypeEnum.payStub,
          documentProcessingDate: DateTime(2026, 1, 1),
        ),
      );
      expect(doc.toEntity()?.type, DocumentTypeEnum.payStub);
      expect(
        DocumentInfoModel(
          name: 'x',
          type: 'unknown',
          documentProcessingDate: DateTime(2026, 1, 1),
        ).toEntity(),
        isNull,
      );

      expect(DocumentFileModel.fromEntity(null), isNull);
      final docFile = DocumentFileModel.fromEntity(
        DocumentFile(id: '1', name: 'a.pdf', type: 'pdf', data: 'x'),
      )!;
      expect(docFile.toEntity().name, 'a.pdf');
    });
  });

  group('Authentication tablet models', () {
    test('fromEntity nulo, isValid e formatadores', () {
      expect(CondoInfoModel.fromEntity(null), isNull);
      expect(EmployeeInfoModel.fromEntity(null), isNull);
      expect(CondominiumCodeInfoModel.fromEntity(null), isNull);
      expect(CondominiumCodeInfoModel().isValid, isFalse);

      final condo = CondoInfo(
        reference: 'R1',
        name: 'Torre',
        picturehash: 'h',
        status: 'ok',
        ref: 'r',
      );
      expect(CondoInfoModel.fromEntity(condo)!.toEntity().name, 'Torre');

      final employee = EmployeeInfo(
        numCra: '1',
        numCad: '2',
        cpf: '123',
        name: 'ana silva',
        jobPosition: 'porteiro noturno',
        idLogin: 'l',
        pictureHash: 'pic',
        registered: true,
        statusEnum: DigitalTimesheetStatusEnum.approved,
      );
      expect(employee.nameFormatted, 'Ana Silva');
      expect(employee.jobPositionFormatted, 'Porteiro Noturno');
      expect(employee.pictureLink, contains('pic'));
      expect(
        EmployeeInfo(
          numCra: '',
          numCad: '',
          cpf: 'a',
          name: 'a',
          jobPosition: 'a',
          idLogin: '',
          pictureHash: '',
          registered: false,
          statusEnum: DigitalTimesheetStatusEnum.pending,
        ).pictureLink,
        isNull,
      );
      final empModel = EmployeeInfoModel.fromEntity(employee)!;
      expect(empModel.toEntity().registered, isTrue);

      final info = CondominiumCodeInfo(
        condoCode: '999',
        condominium: condo,
        employees: [employee],
      );
      final infoModel = CondominiumCodeInfoModel.fromEntity(info)!;
      expect(infoModel.isValid, isTrue);
      expect(infoModel.toEntity()?.condoCode, '999');
    });
  });

  group('Me extras', () {
    test('clone, compareStr, firstName e picture', () {
      final me = testMe();
      me.setPictureLink();
      expect(me.pictureLink, isNull);
      final withPic = Me.clone(me)..picture = 'nova.png';
      withPic.pictureHash = 'abc';
      withPic.setPictureLink();
      expect(withPic.pictureLink, '/me/pictures/file/abc');
      expect(withPic.firstNameFormatted, 'Ana');
      expect(withPic.compareStr(me), contains('imagem'));
      expect(Me(name: 'a').firstNameFormatted, 'a');
    });
  });

  group('PreferencesNotificationEntity.title', () {
    test('mapeia cada módulo', () {
      const modules = {
        'acordos': 'notification_module_agreements',
        'ocorrencia': 'notification_module_reports_report',
        'prestacao_contas': 'notification_module_accountability_title',
        'reserva_area': 'notification_module_condominium_hub_manage_space',
        'mkt': 'notification_module_mkt',
        'correspondencia': 'notification_module_mailing_title',
        'boletos': 'notification_module_income_control_billets',
        'comunicados': 'notification_module_announcements',
        'gdp': 'notification_module_gdp',
        'sistema': 'notification_module_others',
        'xyz': 'notification_module_others',
      };
      for (final entry in modules.entries) {
        expect(
          PreferencesNotificationEntity(module: entry.key).title,
          entry.value,
        );
      }
    });
  });

  group('UrlUploadS3Model', () {
    test('fromEntity, fromJson e toEntity', () {
      final entity = UrlUploadS3(fileName: 'f.jpg', url: 'http://s3/x');
      final model = UrlUploadS3Model.fromEntity(entity);
      expect(model.fileName, 'f.jpg');
      expect(model.toEntity().url, 'http://s3/x');
      final json = UrlUploadS3Model.fromJson({
        'file_name': 'a.png',
        'url': 'http://s3/a',
      });
      expect(json.fileName, 'a.png');
      expect(json.toJson()['url'], 'http://s3/a');
    });
  });

  group('Session', () {
    test('ids e posição recente', () {
      final session = testSession();
      expect(session.condominiumId, 'c1');
      expect(session.condominiumReference, 'R1');
      expect(session.userId, 'm1');
      expect(session.unitId, '');
      expect(session.lastPosition, isNull);
    });
  });
}
