import 'package:colaborador/core/navigation/application_rbac.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

class _DenySessionBloc extends Fake implements SessionBloc {
  @override
  SessionState get state => const SessionInitialState();

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  bool checkRback(String rbac) => false;
}

class _RecordingSessionBloc extends Fake implements SessionBloc {
  String? lastRbac;

  @override
  SessionState get state => const SessionInitialState();

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  bool checkRback(String rbac) {
    lastRbac = rbac;
    return true;
  }
}

ApplicationRbacEnum _rbacFor(HomeItemEnum item) {
  switch (item) {
    case HomeItemEnum.digitalPoint:
      return ApplicationRbacEnum.colaboradorPontodigital;
    case HomeItemEnum.myDocuments:
      return ApplicationRbacEnum.colaboradorDocumentos;
    case HomeItemEnum.teamManagement:
      return ApplicationRbacEnum.colaboradorGestaoEquipe;
    case HomeItemEnum.registerDigitalPoint:
      return ApplicationRbacEnum.colaboradorPontodigitalMarcarPonto;
    case HomeItemEnum.timeSheet:
      return ApplicationRbacEnum.colaboradorPontodigitalEspelhoPontoRead;
    case HomeItemEnum.proof:
      return ApplicationRbacEnum.colaboradorPontodigitalComprovante;
    case HomeItemEnum.sickNote:
      return ApplicationRbacEnum.colaboradorPontodigitalAtestado;
    case HomeItemEnum.sendTimeSheet:
      return ApplicationRbacEnum.colaboradorPontoManual;
    case HomeItemEnum.incomeReport:
      return ApplicationRbacEnum.colaboradorDocumentosInformeRendimentos;
    case HomeItemEnum.payStub:
      return ApplicationRbacEnum.colaboradorDocumentosHolerite;
    case HomeItemEnum.vacation:
    case HomeItemEnum.exams:
      return ApplicationRbacEnum.colaboradorDocumentosFerias;
    case HomeItemEnum.benefits:
      return ApplicationRbacEnum.colaboradorDocumentosBeneficios;
    case HomeItemEnum.discounts:
      return ApplicationRbacEnum.colaboradorVantagensDescontos;
    case HomeItemEnum.indicateReceiveBenefits:
      return ApplicationRbacEnum.colaboradorVantagensIndiqueGanhe;
    case HomeItemEnum.condolivre:
    case HomeItemEnum.employeeReferral:
      return ApplicationRbacEnum.colaboradorVantagensCondoLivre;
    case HomeItemEnum.courses:
      return ApplicationRbacEnum.colaboradorVantagensCursos;
  }
}

void main() {
  group('HomeItemEnum getters', () {
    test('todo item tem titleKey, icon e rbac', () {
      for (final item in HomeItemEnum.values) {
        expect(item.titleKey, isNotEmpty);
        expect(item.icon, startsWith('assets/'));
        expect(item.getCircuitBreakRbacString, isNotEmpty);
        expect(item.checkRbac(FakeSessionBloc()), isTrue);
      }
    });

    test('checkRbac retorna false quando sessão nega', () {
      final bloc = _DenySessionBloc();
      expect(HomeItemEnum.proof.checkRbac(bloc), isFalse);
      expect(HomeItemEnum.benefits.checkRbac(bloc), isFalse);
    });

    test('priority agrupa itens corretamente', () {
      expect(HomeItemEnum.discounts.priority(), 0);
      expect(HomeItemEnum.registerDigitalPoint.priority(), 1);
      expect(HomeItemEnum.proof.priority(), 2);
      for (final item in HomeItemEnum.values) {
        if (item != HomeItemEnum.discounts &&
            item != HomeItemEnum.registerDigitalPoint &&
            item != HomeItemEnum.proof) {
          expect(item.priority(), 3);
        }
      }
    });

    test('checkRbac consulta rbac correto por item', () {
      final bloc = _RecordingSessionBloc();
      for (final item in HomeItemEnum.values) {
        item.checkRbac(bloc);
        expect(
          bloc.lastRbac,
          _rbacFor(item).toFormattedString(),
          reason: 'rbac de $item',
        );
      }
    });

    test('checkVisible retorna false sem sessão carregada', () {
      final bloc = _DenySessionBloc();
      expect(HomeItemEnum.proof.checkVisible(bloc), isFalse);
      expect(HomeItemEnum.benefits.checkVisible(bloc), isFalse);
    });

    test('getCircuitBreakRbacString mapeia rbac de leitura', () {
      expect(
        HomeItemEnum.timeSheet.getCircuitBreakRbacString,
        ApplicationRbacEnum.colaboradorPontodigitalEspelhoPonto.toFormattedString(),
      );
      expect(
        HomeItemEnum.employeeReferral.getCircuitBreakRbacString,
        ApplicationRbacEnum.colaboradorVantagensIndiqueVagasRead
            .toFormattedString(),
      );
      expect(
        HomeItemEnum.exams.getCircuitBreakRbacString,
        HomeItemEnum.vacation.getCircuitBreakRbacString,
      );
      for (final item in HomeItemEnum.values) {
        expect(item.getCircuitBreakRbacString, isNotEmpty);
      }
    });
  });

  group('ApplicationRbacEnum', () {
    test('toFormattedString e fromString são inversos', () {
      for (final rbac in ApplicationRbacEnum.values) {
        final formatted = rbac.toFormattedString();
        expect(formatted, isNotEmpty);
        expect(UtilsAplicationRbac.fromString(formatted), isNotNull);
        rbac.homeItem;
      }
    });

    test('fromString desconhecido retorna null', () {
      expect(UtilsAplicationRbac.fromString('xyz'), isNull);
    });

    test('homeItem mapeia itens conhecidos', () {
      expect(
        ApplicationRbacEnum.colaboradorDocumentosHolerite.homeItem,
        HomeItemEnum.payStub,
      );
      expect(ApplicationRbacEnum.colaborador.homeItem, isNull);
      expect(
        ApplicationRbacEnum.colaboradorPontodigitalMarcarPonto.homeItem,
        HomeItemEnum.registerDigitalPoint,
      );
    });
  });

  group('HomeNavigationItem', () {
    test('titleKey e icon de cada item', () {
      for (final item in HomeNavigationItemEnum.values) {
        final nav = HomeNavigationItem(
          item: item,
          child: const SizedBox.shrink(),
        );
        expect(nav.titleKey, isNotEmpty);
        expect(nav.icon, startsWith('assets/'));
        expect(nav.activated, isTrue);
      }
    });
  });
}
