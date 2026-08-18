import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

void main() {
  test('getTypeReport traduz o código da ocorrência', () {
    expect(Report(typeReport: 'SUGGESTION').getTypeReport,
        'reports_type_suggestion');
    expect(Report(typeReport: 'COMPLAINT').getTypeReport,
        'reports_type_complaint');
    expect(Report(typeReport: 'COMPLIMENT').getTypeReport,
        'reports_type_compliment');
    expect(Report(typeReport: 'VIOLENCE_NO').getTypeReport,
        'reports_type_violence_no');
    expect(Report(typeReport: 'OTHERS').getTypeReport, 'reports_type_others');
    expect(Report(typeReport: 'X').getTypeReport, '');
  });

  test('setTypeReport aceita rótulos em português e inglês', () {
    final report = Report();
    report.setTypeReport('Reclamações');
    expect(report.typeReport, 'COMPLAINT');
    report.setTypeReport('Suggestion');
    expect(report.typeReport, 'SUGGESTION');
    report.setTypeReport('Elogios');
    expect(report.typeReport, 'COMPLIMENT');
  });

  test('getDate formata dia e hora', () {
    final report = Report(dateReport: DateTime(2026, 3, 9, 14, 5));
    expect(report.getDate(), '09/03/2026 - 14:05h');
  });
}
