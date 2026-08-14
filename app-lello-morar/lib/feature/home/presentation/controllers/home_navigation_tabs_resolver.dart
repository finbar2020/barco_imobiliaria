import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';

enum HomeNavigationTab {
  home,
  easyFix,
  unity,
  comodities,
}

class HomeNavigationTabsResolver {
  final SessionBloc sessionBloc;
  final CircuitBreakerController circuitBreakController;

  HomeNavigationTabsResolver({
    required this.sessionBloc,
    required this.circuitBreakController,
  });

  List<HomeNavigationTab> resolveVisibleTabs() {
    return HomeNavigationTab.values
        .where((tab) => countRbacByTab(tab) > 0)
        .toList();
  }

  int countRbacByTab(HomeNavigationTab tab) {
    switch (tab) {
      case HomeNavigationTab.home:
        return _countVisibleRbac(HomeItemEnumUtils.homePageItems) +
            (_hasAccessToRbac(ApplicationRbac.morarIaBella) ? 1 : 0) +
            (_hasAccessToRbac(ApplicationRbac.morarBanner) ? 1 : 0);
      case HomeNavigationTab.easyFix:
        return _countVisibleRbac(HomeItemEnumUtils.easyFixPageItems);
      case HomeNavigationTab.unity:
        return _countVisibleRbac(HomeItemEnumUtils.unityPageItems);
      case HomeNavigationTab.comodities:
        return _hasAccessToRbac(ApplicationRbac.morarComodidades) ? 1 : 0;
    }
  }

  int _countVisibleRbac(List<HomeItemEnum> pageItems) {
    return pageItems
        .where((item) => _hasAccessToRbac(item.rbac(sessionBloc)))
        .length;
  }

  bool _hasAccessToRbac(String applicationRbac) {
    return sessionBloc.checkRback(applicationRbac) &&
        circuitBreakController.checkVisible(
          applicationRbac: applicationRbac,
          reference: _reference,
        );
  }

  String get _reference =>
      sessionBloc.state.session?.condominium?.reference.toString() ?? '';
}
