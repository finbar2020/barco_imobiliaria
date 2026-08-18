import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/entity/geographic_coordinates.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('GeographicCoordinates', () {
    test('parseia latitude e longitude', () {
      final coords = GeographicCoordinates(longitude: '-46.6', latitude: '-23.5');
      expect(coords.longitudeDouble, -46.6);
      expect(coords.latitudeDouble, -23.5);
    });

    test('vazio vira null', () {
      final coords = GeographicCoordinates(longitude: '', latitude: '');
      expect(coords.longitudeDouble, isNull);
      expect(coords.latitudeDouble, isNull);
    });

    test('clone copia valores', () {
      final clone = GeographicCoordinates.clone(
        GeographicCoordinates(longitude: '1', latitude: '2'),
      );
      expect(clone.longitude, '1');
      expect(clone.latitude, '2');
    });
  });

  group('WorkShiftDetails', () {
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

    test('monta horários do dia', () {
      expect(shift.entry1Date, DateTime(2026, 1, 10, 8));
      expect(shift.out1Date, DateTime(2026, 1, 10, 12));
      expect(shift.entry1DateLate, DateTime(2026, 1, 10, 8, 5));
    });

    test('folga não gera horário', () {
      final off = WorkShiftDetails.clone(shift)..isDayOff = true;
      expect(off.entry1Date, isNull);
    });
  });

  group('Condominium', () {
    test('jobPositionFormatted capitaliza', () {
      expect(testCondominium(jobPosition: 'pORTEIRO').jobPositionFormatted, 'Porteiro');
      expect(testCondominium(jobPosition: 'a').jobPositionFormatted, 'a');
    });

    test('clone copia id e cargo', () {
      final clone = Condominium.clone(testCondominium());
      expect(clone.id, 'c1');
      expect(clone.name, 'Torre Lello');
    });

    test('canRegisterDigitalPointStatus só se aprovado', () {
      final condo = testCondominium();
      expect(condo.canRegisterDigitalPointStatus, isFalse);
      final approved = Condominium(
        id: 'c1',
        name: 'T',
        reference: 'R',
        jobPosition: 'p',
        workLeaveDescription: '',
        shouldIgnoreDigitalPoint: true,
        workShift: 'd',
        workShiftDetails: const [],
        geographicCoordinates: GeographicCoordinates(longitude: '0', latitude: '0'),
        digitalTimesheetStatus: DigitalTimesheetStatusEnum.approved,
      );
      expect(approved.canRegisterDigitalPointStatus, isTrue);
      expect(approved.isDigitalPointBlockedByLeave, isTrue);
    });

    test('nextWorkSchedule filtra os dias pedidos', () {
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final condo = testCondominium(
        workShiftDetails: [
          WorkShiftDetails(
            badageNumber: '1',
            entry1: '08:00:00',
            out1: '12:00:00',
            entry2: '13:00:00',
            out2: '17:00:00',
            isDayOff: false,
            date: today,
            reference: 'R1',
          ),
          WorkShiftDetails(
            badageNumber: '1',
            entry1: '08:00:00',
            out1: '12:00:00',
            entry2: '13:00:00',
            out2: '17:00:00',
            isDayOff: false,
            date: today.add(const Duration(days: 10)),
            reference: 'R1',
          ),
        ],
      );
      expect(condo.nextWorkSchedule(1), hasLength(1));
    });
  });

  group('Me extras', () {
    test('nameFormatted capitaliza cada palavra', () {
      expect(Me(name: 'ana silva').nameFormatted, 'Ana Silva');
    });

    test('isValid exige condomínio', () {
      expect(Me().isValid, isFalse);
      expect(testMe().isValid, isTrue);
    });

    test('hasToUpdate após 1 minuto', () {
      expect(Me(lastUpdatedAt: DateTime.now()).hasToUpdate, isFalse);
      expect(
        Me(lastUpdatedAt: DateTime.now().subtract(const Duration(minutes: 2)))
            .hasToUpdate,
        isTrue,
      );
    });
  });
}
