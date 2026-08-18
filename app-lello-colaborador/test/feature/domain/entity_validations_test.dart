import 'dart:io';

import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SickNoteEntity', () {
    test('isValid exige arquivo e data', () {
      expect(SickNoteEntity().isValid, isFalse);
      expect(
        SickNoteEntity(date: DateTime(2026, 1, 1)).isValid,
        isFalse,
      );
      expect(
        SickNoteEntity(file: File('x.pdf')).isValid,
        isFalse,
      );
      expect(
        SickNoteEntity(
          date: DateTime(2026, 1, 1),
          file: File('x.pdf'),
        ).isValid,
        isTrue,
      );
    });

    test('isDaysChecked valida combinação checkbox e dias', () {
      expect(
        SickNoteEntity(isChecked: true).isDaysChecked,
        isFalse,
      );
      expect(
        SickNoteEntity(sickNoteDays: 3).isDaysChecked,
        isFalse,
      );
      expect(
        SickNoteEntity(isChecked: true, sickNoteDays: 3).isDaysChecked,
        isTrue,
      );
      expect(
        SickNoteEntity(isChecked: false, sickNoteDays: null).isDaysChecked,
        isTrue,
      );
    });

    test('getFormattedDate', () {
      expect(SickNoteEntity().getFormattedDate, '');
      expect(
        SickNoteEntity(date: DateTime(2026, 1, 10)).getFormattedDate,
        '10/01/2026',
      );
    });
  });

  group('EmployeeReferralEntity', () {
    test('isValid exige descrição, cidade e arquivo', () {
      expect(EmployeeReferralEntity().isValid, isFalse);
      expect(
        EmployeeReferralEntity(description: 'dev').isValid,
        isFalse,
      );
      expect(
        EmployeeReferralEntity(description: 'dev', city: 'SP').isValid,
        isFalse,
      );
      expect(
        EmployeeReferralEntity(
          description: 'dev',
          city: 'SP',
          file: File('cv.pdf'),
        ).isValid,
        isTrue,
      );
    });

    test('isRegionValid valida região opcional', () {
      expect(
        EmployeeReferralEntity(hasRegion: true).isRegionValid,
        isFalse,
      );
      expect(
        EmployeeReferralEntity(region: 'zona sul').isRegionValid,
        isFalse,
      );
      expect(
        EmployeeReferralEntity(
          hasRegion: true,
          region: 'zona sul',
        ).isRegionValid,
        isTrue,
      );
      expect(
        EmployeeReferralEntity(hasRegion: false, region: null).isRegionValid,
        isTrue,
      );
    });
  });

  group('ManualTimeSheetEntity', () {
    test('isValid exige arquivo e data', () {
      expect(ManualTimeSheetEntity().isValid, isFalse);
      expect(
        ManualTimeSheetEntity(date: DateTime(2026, 1, 1)).isValid,
        isFalse,
      );
      expect(
        ManualTimeSheetEntity(
          date: DateTime(2026, 1, 1),
          file: File('ponto.pdf'),
        ).isValid,
        isTrue,
      );
    });
  });
}
