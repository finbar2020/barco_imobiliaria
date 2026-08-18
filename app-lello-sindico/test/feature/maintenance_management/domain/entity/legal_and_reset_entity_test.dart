import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_status.dart';
import 'package:lello/feature/maintenance_management/domain/entity/reset_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/enum/legal_obligation_type.dart';

void main() {
  test('LegalObligationType.apiValue', () {
    expect(LegalObligationType.condominium.apiValue, 'CONDOMINIUM');
    expect(LegalObligationType.employee.apiValue, 'EMPLOYEE');
    expect(
      LegalObligationType.technicalInspection.apiValue,
      'TECHNICAL_INSPECTION',
    );
  });

  test('LegalObligationEntity.empty isEmpty', () {
    expect(const LegalObligationEntity.empty().isEmpty, isTrue);
    expect(
      const LegalObligationEntity(items: [
        LegalObligationItemEntity(id: '1'),
      ]).isEmpty,
      isFalse,
    );
  });

  test('ResetScheduleEventEntity fromJson/toJson e igualdade', () {
    const entity = ResetScheduleEventEntity(success: true, message: 'ok');
    final parsed = ResetScheduleEventEntity.fromJson(entity.toJson());
    expect(parsed, entity);
    expect(parsed.hashCode, entity.hashCode);
    expect(entity.toString(), contains('success: true'));
    expect(
      ResetScheduleEventEntity.fromJson({}).success,
      isFalse,
    );
  });

  test('LegalObligationStatus.fromApiValue cobre aliases e nulos', () {
    expect(
      LegalObligationStatusExtension.fromApiValue(null),
      isNull,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('desconhecido'),
      isNull,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('pendente'),
      LegalObligationStatus.pendente,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('à-vencer'),
      LegalObligationStatus.aVencer,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('em-renovação'),
      LegalObligationStatus.emRenovacao,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('em-análise'),
      LegalObligationStatus.emAnalise,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('válido'),
      LegalObligationStatus.valido,
    );
    expect(
      LegalObligationStatusExtension.fromApiValue('EM ANALISE'),
      LegalObligationStatus.emAnalise,
    );
  });

  test('LegalObligationStatus expõe chave, cor e outline', () {
    final theme = LelloTheme.light;
    for (final status in LegalObligationStatus.values) {
      expect(status.statusLabelKey, isNotEmpty);
      expect(status.helpDescriptionKey, isNotEmpty);
      expect(status.color(theme), isA<Color>());
    }
    expect(LegalObligationStatus.emAnalise.isOutlined, isTrue);
    expect(LegalObligationStatus.recusado.isOutlined, isTrue);
    expect(LegalObligationStatus.pendente.isOutlined, isFalse);
  });
}
