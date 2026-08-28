import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/feature/home/data/data_source/home_api.dart';
import 'package:morar/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:morar/feature/home/data/data_source/home_remote_data_source_impl.dart';
import 'package:morar/feature/home/data/home_item_weight_cache.dart';
import 'package:morar/feature/home/data/model/home_banner_model.dart';
import 'package:morar/feature/home/data/repository/home_repository_impl.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/domain/repository/home_repository.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner_impl.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go_impl.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms_impl.dart';
import 'package:morar/feature/home/presentation/bloc/home_event.dart';
import 'package:morar/feature/home/presentation/bloc/home_state.dart';
import 'package:morar/feature/home/presentation/controllers/home_navigation_tabs_resolver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class MockHomeApi extends Mock implements HomeApi {}

class _FakeDataSource extends Fake implements HomeRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;

  @override
  Future<List<HomeBannerModel>> getBanners(String condominiumId) async {
    if (fail) throw Exception('x');
    return [HomeBannerModel(image: condominiumId)];
  }

  @override
  Future<String> getLink(String unitId) async {
    if (fail) throw Exception('x');
    return 'link-$unitId';
  }

  @override
  Future<String> postTerms(String unitId) async {
    if (fail) throw Exception('x');
    return 'terms-$unitId';
  }
}

class _FakeRepository extends Fake implements HomeRepository {
  final calls = <String>[];
  @override
  Future<Try<List<HomeBanner>>> getBanners(String condominiumId) async {
    calls.add('banners:$condominiumId');
    return Success(const []);
  }

  @override
  Future<Try<String>> getLink(String unitId) async {
    calls.add('link:$unitId');
    return Success('l');
  }

  @override
  Future<Try<String>> postTerms(String unitId) async {
    calls.add('terms:$unitId');
    return Success('t');
  }
}

void main() {
  late FakeSessionBloc sessionBloc;

  setUpAll(() async {
    await setUpFakeFirebase();
    sessionBloc = FakeSessionBloc();
    await installTestCircuitBreaker(sessionBloc: sessionBloc);
  });

  setUp(() {
    sessionBloc.rbacAllowed = true;
    sessionBloc.allowedRbacs = null;
    sessionBloc.hortaConfig = null;
  });

  group('HomeItemEnum', () {
    test('text ↔ homeItem', () {
      for (final item in HomeItemEnum.values) {
        expect(item.text(), isNotEmpty);
        // Corrigido: a chave de texto ("receipt_of_documents") de
        // `receiveDocuments` agora é reconhecida por `homeItem`, que também
        // continua aceitando "receiving_documents".
        expect(item.homeItem(item.text()), item, reason: '$item');
        if (item == HomeItemEnum.receiveDocuments) {
          expect(item.homeItem('receiving_documents'), HomeItemEnum.receiveDocuments);
        }
        expect(item.rbac(sessionBloc), startsWith('morar.'));
        expect(item.imagePath(false), endsWith('.svg'));
      }
      expect(HomeItemEnum.comfort.homeItem('desconhecido'), isNull);
      expect(HomeItemEnum.talkToLello.imagePath(true), 'assets/ic_whats.svg');
      expect(HomeItemEnum.talkToLello.imagePath(false), 'assets/ic_talk_to_lello.svg');
    });

    test('isHighlighted, routes e priority', () {
      for (final item in HomeItemEnum.values) {
        expect(item.isHighlighted(), item == HomeItemEnum.iaBella);
      }
      expect(HomeItemEnum.horta.routes(), '');
      expect(HomeItemEnum.rentSell.routes(), '');
      expect(HomeItemEnum.talkToLello.routes(), '');
      expect(HomeItemEnum.billets.routes(), ApplicationRoute.billets);
      expect(HomeItemEnum.cnd.routes(), ApplicationRoute.certificateNoOutstandingDebt);
      expect(HomeItemEnum.receiveDocuments.routes(), ApplicationRoute.receivingDocuments);
      expect(HomeItemEnum.comfort.priority(), 0);
      expect(HomeItemEnum.agreements.priority(), 1);
      expect(HomeItemEnum.billets.priority(), 2);
      expect(HomeItemEnum.vehicle.priority(), 3);
      expect(HomeItemEnum.receiveDocuments.rbac(sessionBloc),
          ApplicationRbac.morarPreferenciasMinhaContaFull);
    });

    test('listas utilitárias não repetem itens', () {
      for (final list in [
        HomeItemEnumUtils.defaultDashboardOrder,
        HomeItemEnumUtils.homePageItems,
        HomeItemEnumUtils.easyFixPageItems,
        HomeItemEnumUtils.unityPageItems,
      ]) {
        expect(list.toSet().length, list.length);
      }
      expect(HomeItemEnumUtils.homePageItems, isNot(contains(HomeItemEnum.iaBella)));
      expect(HomeItemEnumUtils.easyFixPageItems.first, HomeItemEnum.myPreferences);
    });

    test('checkVisible consulta rbac e horta', () {
      for (final item in HomeItemEnum.values) {
        expect(item.checkVisible(sessionBloc), item != HomeItemEnum.horta,
            reason: '$item');
      }
      sessionBloc.hortaConfig = HortaRemoteConfigEntity(link: 'l');
      expect(HomeItemEnum.horta.checkVisible(sessionBloc), isTrue);

      sessionBloc.rbacAllowed = false;
      for (final item in HomeItemEnum.values) {
        expect(item.checkVisible(sessionBloc), isFalse, reason: '$item');
      }
    });
  });

  group('HomeItemWeightCache', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('updateOrder mantém o mais recente no início sem repetir', () async {
      await HomeItemWeightCache.updateOrder(HomeItemEnum.billets);
      await HomeItemWeightCache.updateOrder(HomeItemEnum.mailing);
      await HomeItemWeightCache.updateOrder(HomeItemEnum.billets);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('home_item_order_v2'), ['billets', 'mailing']);
    });

    test('getOrder prioriza o cache e completa com defaults visíveis', () async {
      SharedPreferences.setMockInitialValues({
        'home_item_order_v2': ['mailing', 'invalido', 'horta', 'mailing'],
      });
      final order = await HomeItemWeightCache.getOrder(
        HomeItemEnumUtils.defaultDashboardOrder,
        sessionBloc,
      );
      expect(order, [HomeItemEnum.mailing, HomeItemEnum.billets, HomeItemEnum.reserves]);

      await HomeItemWeightCache.clearOrder();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('home_item_order_v2'), isNull);
    });

    test('getOrder com 3 itens no cache não usa defaults', () async {
      SharedPreferences.setMockInitialValues({
        'home_item_order_v2': ['cnd', 'tdb', 'vehicle', 'billets'],
      });
      final order = await HomeItemWeightCache.getOrder(
        HomeItemEnumUtils.defaultDashboardOrder,
        sessionBloc,
      );
      expect(order, [HomeItemEnum.cnd, HomeItemEnum.tdb, HomeItemEnum.vehicle]);
    });
  });

  group('HomeNavigationTabsResolver', () {
    test('conta rbacs visíveis por aba', () async {
      final circuit = await installTestCircuitBreaker(sessionBloc: sessionBloc);
      final resolver = HomeNavigationTabsResolver(
        sessionBloc: sessionBloc,
        circuitBreakController: circuit,
      );
      expect(resolver.resolveVisibleTabs(), HomeNavigationTab.values);
      expect(resolver.countRbacByTab(HomeNavigationTab.home),
          HomeItemEnumUtils.homePageItems.length + 2);
      expect(resolver.countRbacByTab(HomeNavigationTab.comodities), 1);

      sessionBloc.allowedRbacs = {ApplicationRbac.morarMoradores};
      expect(resolver.resolveVisibleTabs(), [HomeNavigationTab.home, HomeNavigationTab.unity]);
      expect(resolver.countRbacByTab(HomeNavigationTab.easyFix), 0);
      expect(resolver.countRbacByTab(HomeNavigationTab.unity), 1);

      sessionBloc.allowedRbacs = {};
      expect(resolver.resolveVisibleTabs(), isEmpty);
    });
  });

  group('banners / club lello', () {
    test('HomeBanner e HomeBannerModel', () {
      final model = HomeBannerModel.fromJson({'inside_app': true, 'image': 'i', 'url': 'u'});
      final entity = model.toEntity();
      expect(entity.insideApp, isTrue);
      expect(HomeBannerModel.fromEntity(entity)!.toJson()['url'], 'u');
      expect(HomeBannerModel.fromEntity(null), isNull);
      expect(HomeBanner().insideApp, isFalse);
    });

    test('use cases validam', () async {
      final repo = _FakeRepository();
      expect(
        (await GetBannerImpl(repository: repo)(GetBannerParams(condominuimId: '')))
            .fold((f) => f, (_) => null),
        isA<InvalidParamFailure>(),
      );
      expect(
        (await HomeToGoImpl(repository: repo)(HomeToGoParams(unitId: '')))
            .fold((f) => f, (_) => null),
        isA<InvalidParamFailure>(),
      );
      expect(
        (await PostTermsImpl(repository: repo)(PostTermsParams(unitId: '')))
            .fold((f) => f, (_) => null),
        isA<InvalidParamFailure>(),
      );
      await GetBannerImpl(repository: repo)(GetBannerParams(condominuimId: 'c'));
      await HomeToGoImpl(repository: repo)(HomeToGoParams(unitId: 'u'));
      await PostTermsImpl(repository: repo)(PostTermsParams(unitId: 'u'));
      expect(repo.calls, ['banners:c', 'link:u', 'terms:u']);
    });

    test('repository', () async {
      final ok = HomeRepositoryImpl(dataSource: _FakeDataSource());
      expect((await ok.getBanners('c')).fold((_) => null, (b) => b.single.image), 'c');
      expect((await ok.getLink('u')).fold((_) => null, (l) => l), 'link-u');
      expect((await ok.postTerms('u')).fold((_) => null, (l) => l), 'terms-u');

      final bad = HomeRepositoryImpl(dataSource: _FakeDataSource(fail: true));
      expect((await bad.getBanners('c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await bad.getLink('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await bad.postTerms('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('data source', () async {
      final api = MockHomeApi();
      final ds = HomeRemoteDataSourceImpl(api: api);
      expect((await ds.getBanners('c')).map((b) => b.image),
          everyElement(startsWith('assets/banner_')));
      when(() => api.getLink('u')).thenAnswer(
        (_) async => Response<dynamic>(http.Response('https://club', 200), 'https://club'),
      );
      when(() => api.postTerms('u')).thenAnswer(
        (_) async => Response<dynamic>(http.Response('ok', 200), 'ok'),
      );
      when(() => api.getLink('e')).thenAnswer(
        (_) async => Response<dynamic>(http.Response('', 500), null, error: 'boom'),
      );
      when(() => api.postTerms('e')).thenAnswer(
        (_) async => Response<dynamic>(http.Response('', 500), null, error: 'boom'),
      );
      expect(await ds.getLink('u'), 'https://club');
      expect(await ds.postTerms('u'), 'ok');
      expect(() => ds.getLink('e'), throwsA('boom'));
      expect(() => ds.postTerms('e'), throwsA('boom'));
    });

    test('estados e eventos', () {
      expect(const HomeViewState(showCondominumSelector: true).props, [true, null]);
      expect(const LoadedBannersState(banners: []).props, [[]]);
      expect(const LoadedHomeToGoState(link: 'l').props, ['l']);
      expect(const LoadedFavoritesCardsState(cards: [HomeItemEnum.cnd]).props, [
        [HomeItemEnum.cnd]
      ]);
      expect(const RegisterFcmTokenEvent('c').props, ['c']);
      expect(const GetBannersEvent().props, isEmpty);
      expect(const ShowHomeToGoState(), const ShowHomeToGoState());
      expect(jsonEncode({'a': 1}), '{"a":1}');
    });
  });
}
