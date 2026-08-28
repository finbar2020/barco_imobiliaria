import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_bloc.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_event.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_state.dart';

import '../../helpers/firebase_mocks.dart';
import 'banners_support.dart';

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('BannersBloc reage a cada evento', () async {
    final bloc = BannersBloc();
    expect(bloc.state, isA<EmptyBannersState>());
    final states = <dynamic>[];
    bloc.stream.listen(states.add);

    bloc.add(BannersLoadingEvent());
    bloc.add(BannersLoadedEvent(banners: [buildBanner()]));
    bloc.add(BannersErrorEvent());
    await Future<void>.delayed(Duration.zero);

    expect(states[0], isA<LoadingBannersState>());
    expect((states[1] as LoadedBannersState).banners.single.id, 'b1');
    expect(states[2], isA<ErrorBannersState>());
    await bloc.close();
  });

  group('BannersController', () {
    test('lê o condomínio, a referência, a unidade e o evento por app', () {
      final owner = BannersHarness().buildController();
      expect(owner.getCondoIdByProject(AppOriginEnum.owner, owner.sessionBloc),
          'C1');
      expect(owner.getCondoReference, 'R1');
      expect(owner.getUnitName, '101');
      expect(owner.getAnalyticsEvent.name,
          AnalyticsEventsOwner.bannerDinamicoAcessar().name);

      final employee =
          BannersHarness(origin: AppOriginEnum.employee).buildController();
      expect(
          employee.getCondoIdByProject(
              AppOriginEnum.employee, employee.sessionBloc),
          'C1');
      expect(employee.getCondoReference, 'R1');
      expect(employee.getUnitName, '');
      expect(employee.getAnalyticsEvent.name,
          AnalyticsEventsEmployee.bannerDinamicoAcessar().name);

      final manager =
          BannersHarness(origin: AppOriginEnum.manager).buildController();
      expect(
          manager.getCondoIdByProject(AppOriginEnum.manager, manager.sessionBloc),
          'SC1');
      expect(manager.getCondoReference, 'SR1');
      expect(manager.getUnitName, '');
      expect(manager.getAnalyticsEvent.name,
          AnalyticsEventsManager.bannerDinamicoAcessar().name);

      final empty = BannersHarness(
              sessionBloc: FakeSessionBloc(session: FakeSession()))
          .buildController();
      expect(empty.getCondoIdByProject(AppOriginEnum.owner, empty.sessionBloc),
          '');
      expect(empty.getCondoReference, '');
      expect(empty.getUnitName, '');
      final emptyManager = BannersHarness(
              origin: AppOriginEnum.manager,
              sessionBloc: FakeSessionBloc(session: FakeSession()))
          .buildController();
      expect(emptyManager.getCondoReference, '');
    });

    test('cache fresco carrega sem chamar a API', () async {
      final memory = MemoryBannersLocalDataSource();
      memory.store['C1'] = [buildBannerModel(id: 'cache')];
      final harness = BannersHarness(local: memory);
      final controller = harness.buildController();
      final states = <dynamic>[];
      controller.bloc.stream.listen(states.add);

      await controller.getBanners();
      await Future<void>.delayed(Duration.zero);

      expect(states.map((s) => s.runtimeType),
          [LoadingBannersState, LoadedBannersState]);
      expect((states.last as LoadedBannersState).banners.single.id, 'cache');
      expect(harness.http.requests, isEmpty);
    });

    test('cache vazio ou expirado busca na API', () async {
      final harness = BannersHarness();
      harness.stubBanners([bannerJson(id: 'remoto')]);
      final controller = harness.buildController();
      final states = <dynamic>[];
      controller.bloc.stream.listen(states.add);

      await controller.getBanners();
      await Future<void>.delayed(Duration.zero);
      expect(states.map((s) => s.runtimeType),
          [LoadingBannersState, LoadingBannersState, LoadedBannersState]);
      expect((states.last as LoadedBannersState).banners.single.id, 'remoto');
      expect(harness.requestedPaths, ['/condominiums/C1/banners/v2']);

      final memory = MemoryBannersLocalDataSource();
      memory.store['C1'] = [buildBannerModel(id: 'velho')];
      final expired = BannersHarness(local: memory, expired: true);
      expired.stubBanners([bannerJson(id: 'novo')]);
      final c2 = expired.buildController();
      await c2.getBanners();
      await Future<void>.delayed(Duration.zero);
      expect((c2.bloc.state as LoadedBannersState).banners.single.id, 'novo');
    });

    test('erro no cache e na API viram ErrorBannersState', () async {
      final memory = MemoryBannersLocalDataSource()..failSelect = true;
      final harness = BannersHarness(local: memory);
      harness.http.failAll();
      final controller = harness.buildController();
      final states = <dynamic>[];
      controller.bloc.stream.listen(states.add);

      await controller.getBanners();
      await Future<void>.delayed(Duration.zero);

      expect(states.map((s) => s.runtimeType),
          [LoadingBannersState, ErrorBannersState, ErrorBannersState]);
    });
  });
}
