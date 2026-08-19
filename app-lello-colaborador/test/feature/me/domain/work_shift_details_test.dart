import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:flutter_test/flutter_test.dart';

WorkShiftDetails _shift({bool isDayOff = false}) => WorkShiftDetails(
      badageNumber: '10',
      entry1: '08:00',
      out1: '12:00',
      entry2: '13:00',
      out2: '17:00',
      isDayOff: isDayOff,
      date: DateTime(2026, 1, 10),
      reference: 'R1',
    );

void main() {
  group('WorkShiftDetails', () {
    test('monta os horários do dia a partir da data e das batidas', () {
      final shift = _shift();

      expect(shift.entry1Date, DateTime(2026, 1, 10, 8));
      expect(shift.out1Date, DateTime(2026, 1, 10, 12));
      expect(shift.entry2Date, DateTime(2026, 1, 10, 13));
      expect(shift.out2Date, DateTime(2026, 1, 10, 17));
    });

    test('dia de folga não tem horários', () {
      final shift = _shift(isDayOff: true);

      expect(shift.entry1Date, isNull);
      expect(shift.out1Date, isNull);
      expect(shift.entry2Date, isNull);
      expect(shift.out2Date, isNull);
    });

    test('tolerância de atraso é de 5 minutos após cada horário', () {
      final shift = _shift();

      expect(WorkShiftDetails.lateWarning, 5);
      expect(shift.entry1DateLate, DateTime(2026, 1, 10, 8, 5));
      expect(shift.out1DateLate, DateTime(2026, 1, 10, 12, 5));
      expect(shift.entry2DateLate, DateTime(2026, 1, 10, 13, 5));
      expect(shift.out2DateLate, DateTime(2026, 1, 10, 17, 5));
    });

    test('folga não tem tolerância de atraso', () {
      final shift = _shift(isDayOff: true);

      expect(shift.entry1DateLate, isNull);
      expect(shift.out2DateLate, isNull);
    });

    test('clone copia todos os campos', () {
      final original = _shift();

      final copy = WorkShiftDetails.clone(original);

      expect(copy.badageNumber, original.badageNumber);
      expect(copy.entry1, original.entry1);
      expect(copy.out2, original.out2);
      expect(copy.isDayOff, original.isDayOff);
      expect(copy.date, original.date);
      expect(copy.reference, original.reference);
      expect(identical(copy, original), isFalse);
    });
  });
}
