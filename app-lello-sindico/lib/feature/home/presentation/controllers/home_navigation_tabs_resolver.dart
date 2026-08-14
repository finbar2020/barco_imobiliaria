import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';

class HomeNavigationTabsResolver {
  final SessionBloc sessionBloc;
  final CircuitBreakerController circuitBreakController;

  HomeNavigationTabsResolver({
    required this.sessionBloc,
    required this.circuitBreakController,
  });

  List<HomeNavigationItemEnum> resolveVisibleTabs({
    required List<HomeNavigationItemEnum> availableTabs,
  }) {
    return availableTabs.where((tab) => countRbacByTab(tab) > 0).toList();
  }

  int countRbacByTab(HomeNavigationItemEnum tab) {
    switch (tab) {
      case HomeNavigationItemEnum.home:
        return _countHomeTabItems();
      case HomeNavigationItemEnum.condominium:
        return _countCondominiumTabItems();
      case HomeNavigationItemEnum.lello:
        return _countLelloTabItems();
      case HomeNavigationItemEnum.comfort:
        return _hasAccessToRbac(ApplicationRbac.sindicoComodidades) ? 1 : 0;
    }
  }

  int _countHomeTabItems() {
    final homeCardsRbac = {
      ApplicationRbac.sindicoComodidadesSeuCondominio,
      ApplicationRbac.sindicoDespesas,
      ApplicationRbac.sindicoReceitas,
      ApplicationRbac.sindicoSegundavia,
      ApplicationRbac.sindicoGestaoBiometria,
      ApplicationRbac.sindicoEquipe,
      ApplicationRbac.sindicoReservas,
      ApplicationRbac.sindicoUnidades,
      ApplicationRbac.sindicoVoxComunicados,
      ApplicationRbac.sindicoVoxAdvertencias,
      ApplicationRbac.sindicoVoxMultas,
      ApplicationRbac.sindicoVox,
      ApplicationRbac.sindicoOcorrencias,
      ApplicationRbac.sindicoGdp,
      ApplicationRbac.sindicoInadimplentes,
      ApplicationRbac.sindicoAcordos,
      ApplicationRbac.sindicoPpc,
      ApplicationRbac.sindicoFaleconosco,
      ApplicationRbac.sindicoCaixalocal,
      ApplicationRbac.sindicoComodidades,
      ApplicationRbac.sindicoGestaoAcessos,
      ApplicationRbac.sindicoGestaoDeManutencao,
      ApplicationRbac.sindicoDocumentos,
    };

    final cardsCount =
        homeCardsRbac.where((rbac) => _hasAccessToRbac(rbac)).length;

    final extraItemsCount =
        (_hasAccessToRbac(ApplicationRbac.sindicoSaldo) ? 1 : 0) +
            (_hasAccessToRbac(ApplicationRbac.sindicoBanner) ? 1 : 0) +
            (_hasBiometricAccess ? 1 : 0);

    return cardsCount + extraItemsCount;
  }

  int _countCondominiumTabItems() {
    var count = 0;

    if (_hasBiometricAccess &&
        _hasAccessToRbac(ApplicationRbac.sindicoGestaoBiometria)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoGestaoDeManutencao)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoSegundavia)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoEquipe)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoReservas)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoUnidades)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoVoxComunicados)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoVoxAdvertencias) ||
        _hasAccessToRbac(ApplicationRbac.sindicoVoxMultas)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoDocumentos)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoOcorrencias)) {
      count++;
    }

    return count;
  }

  int _countLelloTabItems() {
    var count = 0;

    if (_hasAccessToRbac(ApplicationRbac.sindicoDespesas)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoReceitas)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoGdp)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoInadimplentes)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoAcordos) &&
        _agreementFeatureEnabled) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoPpc)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoFaleconosco)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoCaixalocal)) {
      count++;
    }
    if (_hasAccessToRbac(ApplicationRbac.sindicoGestaoAcessos)) {
      count++;
    }

    return count;
  }

  bool _hasAccessToRbac(String applicationRbac) {
    return sessionBloc.checkRback(applicationRbac) &&
        circuitBreakController.checkVisible(
          applicationRbac: applicationRbac,
          reference: _reference,
        );
  }

  bool get _hasBiometricAccess {
    return sessionBloc.state.session?.selectedCondominium?.useFacialBiometric ??
        false;
  }

  bool get _agreementFeatureEnabled {
    return sessionBloc.checkConfig('agreement_reference');
  }

  String get _reference =>
      sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
      '';
}
