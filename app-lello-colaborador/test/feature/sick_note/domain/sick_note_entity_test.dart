import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isValid exige arquivo e data', () {
    expect(SickNoteEntity().isValid, isFalse);
    expect(
      SickNoteEntity(date: DateTime(2026, 1, 10)).isValid,
      isFalse,
    );
  });

  test('getFormattedDate vazio sem data', () {
    expect(SickNoteEntity().getFormattedDate, '');
    expect(
      SickNoteEntity(date: DateTime(2026, 1, 10)).getFormattedDate,
      '10/01/2026',
    );
  });

  test('isDaysChecked exige dias quando marcado', () {
    expect(SickNoteEntity(isChecked: true).isDaysChecked, isFalse);
    expect(
      SickNoteEntity(isChecked: true, sickNoteDays: 3).isDaysChecked,
      isTrue,
    );
    expect(
      SickNoteEntity(isChecked: false, sickNoteDays: 3).isDaysChecked,
      isFalse,
    );
  });
}
