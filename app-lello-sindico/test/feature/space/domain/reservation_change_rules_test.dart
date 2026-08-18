import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

void main() {
  test('diasAntecedencia mapeia faixas de antecedência', () {
    expect(ReservationChangeRules().diasAntecedencia, 9);
    expect(ReservationChangeRules(daysInAdvance: 0).diasAntecedencia, 9);
    expect(ReservationChangeRules(daysInAdvance: 1).diasAntecedencia, 0);
    expect(ReservationChangeRules(daysInAdvance: 2).diasAntecedencia, 1);
    expect(ReservationChangeRules(daysInAdvance: 5).diasAntecedencia, 2);
    expect(ReservationChangeRules(daysInAdvance: 10).diasAntecedencia, 3);
    expect(ReservationChangeRules(daysInAdvance: 18).diasAntecedencia, 4);
    expect(ReservationChangeRules(daysInAdvance: 25).diasAntecedencia, 5);
    expect(ReservationChangeRules(daysInAdvance: 45).diasAntecedencia, 6);
    expect(ReservationChangeRules(daysInAdvance: 70).diasAntecedencia, 7);
    expect(ReservationChangeRules(daysInAdvance: 90).diasAntecedencia, 8);
  });

  test('setDiasAntecedencia devolve o valor persistido', () {
    final rules = ReservationChangeRules();
    expect(rules.setDiasAntecedencia(0), 1);
    expect(rules.setDiasAntecedencia(1), 2);
    expect(rules.setDiasAntecedencia(2), 3);
    expect(rules.setDiasAntecedencia(3), 7);
    expect(rules.setDiasAntecedencia(4), 14);
    expect(rules.setDiasAntecedencia(5), 21);
    expect(rules.setDiasAntecedencia(6), 30);
    expect(rules.setDiasAntecedencia(7), 60);
    expect(rules.setDiasAntecedencia(8), 90);
    expect(rules.setDiasAntecedencia(9), 0);
    expect(rules.setDiasAntecedencia(99), 9);
  });
}
