// Apoio dos testes de `feature/banners`: sessão falsa (o controller recebe
// `sessionBloc` dinâmico), Hive em diretório temporário, container de teste
// e harness com as classes REAIS (API chopper → data sources → repositório →
// use case → bloc/controller) ligadas ao `FakeHttp`.
import 'dart:async';
import 'dart:io';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/core/database/banners/banners_args_dao.dart';
import 'package:shared_features/core/database/banners/banners_dao.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/banners/data/data_source/local/banners_local_data_source.dart';
import 'package:shared_features/feature/banners/data/data_source/local/banners_local_data_source_impl.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_api.dart';
import 'package:shared_features/feature/banners/data/data_source/remote/banners_remote_data_source_impl.dart';
import 'package:shared_features/feature/banners/data/model/banner_model.dart';
import 'package:shared_features/feature/banners/data/repository/banners_repository_impl.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_args.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_type_enum.dart';
import 'package:shared_features/feature/banners/domain/use_case/get_banners/get_banners_impl.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_bloc.dart';
import 'package:shared_features/feature/banners/presentation/controllers/banners_controller.dart';

import '../../helpers/fake_http.dart';
import '../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Sessão falsa (dinâmica)
// ---------------------------------------------------------------------------

class FakeCondominium {
  FakeCondominium({this.id = 'C1', this.reference = 'R1'});
  final String? id;
  final String? reference;
}

class FakeUnity {
  FakeUnity({this.title = '101'});
  final String? title;
}

class FakeMe {
  FakeMe({this.id = 'ME1'});
  final String? id;
}

class FakeSession {
  FakeSession({
    this.condominium,
    this.selectedCondominium,
    this.unity,
    this.me,
  });
  final FakeCondominium? condominium;
  final FakeCondominium? selectedCondominium;
  final FakeUnity? unity;
  final FakeMe? me;
}

class FakeSessionState {
  FakeSessionState(this.session);
  final dynamic session;
}

/// `sessionBloc` dinâmico: só `state.session` é usado.
class FakeSessionBloc {
  FakeSessionBloc({dynamic session})
      : state = FakeSessionState(session ?? fullSession());
  FakeSessionState state;
}

FakeSession fullSession() => FakeSession(
      condominium: FakeCondominium(),
      selectedCondominium: FakeCondominium(id: 'SC1', reference: 'SR1'),
      unity: FakeUnity(),
      me: FakeMe(),
    );

// ---------------------------------------------------------------------------
// Fakes de infraestrutura
// ---------------------------------------------------------------------------

/// A `CustomCachedNetworkImage` só pede o header ao store; sem header ela
/// cai no SVG local.
class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;
}

/// Cache local em memória para os testes de widget (o Hive real faz IO e não
/// completa dentro do `testWidgets`).
class MemoryBannersLocalDataSource extends BannersLocalDataSource {
  final Map<String, List<BannerModel>> store = {};
  bool failSelect = false;
  final saved = <String>[];

  /// Quando definido, o `select` só responde depois que ele completar
  /// (para observar o estado de loading).
  Completer<void>? gate;

  @override
  Future<List<BannerModel>> select(String condominiumId) async {
    if (gate != null) await gate!.future;
    if (failSelect) throw StateError('cache indisponível');
    return List.of(store[condominiumId] ?? const []);
  }

  @override
  Future<List<BannerModel>?> save(
      List<BannerModel>? bannersModelList, String condominiumId) async {
    saved.add(condominiumId);
    store.remove(condominiumId);
    if (bannersModelList == null) return null;
    store[condominiumId] = List.of(bannersModelList);
    return bannersModelList;
  }
}

/// Hive em um diretório temporário exclusivo; devolve o diretório.
Directory initHiveTemp() {
  final dir = Directory.systemTemp.createTempSync('shared_banners');
  Hive.init(dir.path);
  return dir;
}

/// Fecha as caixas e apaga o diretório.
Future<void> disposeHive(Directory dir) async {
  await Hive.close();
  if (dir.existsSync()) dir.deleteSync(recursive: true);
}

// ---------------------------------------------------------------------------
// Harness com as classes reais ligadas ao FakeHttp
// ---------------------------------------------------------------------------

class BannersHarness {
  BannersHarness({
    this.origin = AppOriginEnum.owner,
    dynamic sessionBloc,
    BannersLocalDataSource? local,
    bool expired = false,
  })  : sessionBloc = sessionBloc ?? FakeSessionBloc(),
        local = local ?? MemoryBannersLocalDataSource(),
        expireCache = ((_) => expired) {
    api = BannersApi.create(buildChopperClient(http));
    remote = BannersRemoteDataSourceImpl(api: api);
    repository =
        BannersRepositoryImpl(remoteDataSource: remote, localDataSource: this.local);
    useCase = GetBannersUseCaseImpl(repository: repository);
    container
      ..register<AuthenticationStore>(FakeAuthenticationStore())
      ..registerLazy<BannersController>(buildController);
  }

  final AppOriginEnum origin;
  final dynamic sessionBloc;
  final BannersLocalDataSource local;
  final bool Function(DateTime?) expireCache;
  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  late final BannersApi api;
  late final BannersRemoteDataSourceImpl remote;
  late final BannersRepositoryImpl repository;
  late final GetBannersUseCaseImpl useCase;
  BannersController? controller;

  BannersController buildController() {
    final c = BannersController(
      bloc: BannersBloc(),
      getBannersUseCase: useCase,
      sessionBloc: sessionBloc,
      expireCache: expireCache,
      appOriginEnum: origin,
    );
    controller = c;
    return c;
  }

  String get condoId => origin == AppOriginEnum.manager ? 'SC1' : 'C1';

  String get bannersPath => '/condominiums/$condoId/banners/v2';

  void stubBanners(List<Map<String, dynamic>> banners) =>
      http.on('GET', bannersPath, body: banners);

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

/// Data source local real sobre o Hive.
BannersLocalDataSourceImpl hiveLocalDataSource() => BannersLocalDataSourceImpl(
      bannersDao: BannersDao(),
      argsDao: BannersArgsDao(),
    );

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> bannerJson({
  String id = 'b1',
  String? redirect = 'https://lello.com.br',
  String? redirectType = 'url',
  String? name = 'Banner 1',
  String? subTitle = 'Subtítulo 1',
  String? observacao = 'obs',
  String image = 'img1.png',
  String? urlImage,
  String? feature = 'boletos',
  String? location = 'HOME',
  String? typeBanner = 'carousel',
  Map<String, dynamic>? arg = const {'partner_id': 'p1'},
  String? projeto = 'MORAR',
  int? ordem = 1,
  String? ativo = 'S',
  String? lastUpdateAt,
}) =>
    {
      'id': id,
      'redirect': redirect,
      'redirect_type': redirectType,
      'name': name,
      'sub_title': subTitle,
      'observacao': observacao,
      'image': image,
      'url_image': urlImage,
      'feature': feature,
      'location': location,
      'type_banner': typeBanner,
      'arg': arg,
      'projeto': projeto,
      'ordem': ordem,
      'ativo': ativo,
      'last_update_at': lastUpdateAt,
    };

BannerModel buildBannerModel({
  String id = 'b1',
  String? redirect = 'https://lello.com.br',
  String? redirectType = 'url',
  String? name = 'Banner 1',
  String? subTitle = 'Subtítulo 1',
  String image = 'img1.png',
  String? feature = 'boletos',
  String? location = 'HOME',
  String? typeBanner = 'carousel',
  String? partnerId = 'p1',
  int? ordem = 1,
  String? ativo = 'S',
  DateTime? lastUpdateAt,
}) =>
    BannerModel.fromJson(bannerJson(
      id: id,
      redirect: redirect,
      redirectType: redirectType,
      name: name,
      subTitle: subTitle,
      image: image,
      feature: feature,
      location: location,
      typeBanner: typeBanner,
      arg: partnerId == null ? null : {'partner_id': partnerId},
      ordem: ordem,
      ativo: ativo,
      lastUpdateAt: lastUpdateAt?.toIso8601String(),
    ));

BannerEntity buildBanner({
  String id = 'b1',
  String? redirect = 'https://lello.com.br',
  BannerRedirectTypeEnum redirectType = BannerRedirectTypeEnum.url,
  String? name = 'Banner 1',
  String? subtitle = 'Subtítulo 1',
  String image = 'img1.png',
  String? urlImage = '/condominiums/C1/banners/b1/image/img1.png',
  BannerFeatureEnum feature = BannerFeatureEnum.boletos,
  BannerLocationEnum? location = BannerLocationEnum.home,
  BannerTypeEnum? typeBanner = BannerTypeEnum.carousel,
  String? partnerId = 'p1',
  int? ordem = 1,
  String? ativo = 'S',
  DateTime? lastUpdateAt,
}) =>
    BannerEntity(
      id: id,
      redirect: redirect,
      redirectType: redirectType,
      name: name,
      subtitle: subtitle,
      image: image,
      urlImage: urlImage,
      feature: feature,
      location: location,
      typeBanner: typeBanner,
      arg: partnerId == null ? null : BannerArgs(partnerId: partnerId),
      ordem: ordem,
      ativo: ativo,
      lastUpdateAt: lastUpdateAt,
    );
