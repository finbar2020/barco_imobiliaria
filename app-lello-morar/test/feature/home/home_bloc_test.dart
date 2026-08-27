import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/home/presentation/bloc/home_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_access_renew_reques_use_case.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class _FakeRegisterFcm extends Fake implements RegisterFcm {
  RegisterFcmToken? token;
  @override
  Future<Try<RegisterFcmToken>> call(RegisterFcmTokenParams params) async {
    token = params.fcmToken;
    return Success(params.fcmToken);
  }
}

class _FakeGetBanner extends Fake implements GetBanner {
  _FakeGetBanner({this.fail = false});
  final bool fail;
  @override
  Future<Try<List<HomeBanner>>> call(GetBannerParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success([HomeBanner(image: params.condominuimId)]);
  }
}

class _FakeHomeToGo extends Fake implements HomeToGo {
  _FakeHomeToGo({this.fail = false});
  final bool fail;
  @override
  Future<Try<String>> call(HomeToGoParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('link-${params.unitId}');
  }
}

class _FakePostTerms extends Fake implements PostTerms {
  _FakePostTerms({this.fail = false});
  final bool fail;
  @override
  Future<Try<String>> call(PostTermsParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('terms-${params.unitId}');
  }
}

class _FakeSubUsers extends Fake implements SubUserUseCase {
  _FakeSubUsers({this.users = const [], this.fail = false});
  final List<SubUser> users;
  final bool fail;
  @override
  Future<Try<List<SubUser>>> call(GetSubUserParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(users);
  }
}

class _FakeRenew extends Fake implements SendAccessRenewRequestUseCase {
  _FakeRenew({this.fail = false});
  final bool fail;
  @override
  Future<Try<String>> call(String params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('ok');
  }
}

SubUser _user({
  String id = 'm1',
  String role = 'morar.proprietario',
  DateTime? expiresAt,
  String? status,
}) =>
    SubUser(id: id, role: role, expiresAt: expiresAt, accessRenewalRequestStatus: status);

void main() {
  late FakeSessionBloc sessionBloc;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({'device_unique_id': 'dev-1'});
    sessionBloc = FakeSessionBloc();
  });

  HomeBloc build({
    _FakeGetBanner? banner,
    _FakeHomeToGo? homeToGo,
    _FakePostTerms? postTerms,
    _FakeSubUsers? subUsers,
    _FakeRenew? renew,
    _FakeRegisterFcm? registerFcm,
  }) =>
      HomeBloc(
        registerFcm: registerFcm ?? _FakeRegisterFcm(),
        sessionBloc: sessionBloc,
        getBanner: banner ?? _FakeGetBanner(),
        clubLello: homeToGo ?? _FakeHomeToGo(),
        postLello: postTerms ?? _FakePostTerms(),
        subUserUseCase: subUsers ?? _FakeSubUsers(),
        sendAccessRenewRequestUseCase: renew ?? _FakeRenew(),
        deviceIdentifierService: DeviceIdentifierService(),
      );

  test('carrega banners quando a sessão já está carregada', () async {
    final bloc = build();
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is LoadedBannersState);
    expect((bloc.state as LoadedBannersState).banners.single.image, 'c1');
  });

  test('banners com falha', () async {
    final bloc = build(banner: _FakeGetBanner(fail: true));
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is FailedBannersState);
  });

  test('escuta a sessão quando ainda não carregou', () async {
    sessionBloc.currentState = const SessionInitialState();
    final bloc = build();
    expect(bloc.state, const HomeViewState(showCondominumSelector: false));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await bloc.close();
  });

  test('seletor de condomínio e diálogo de acordos', () async {
    final bloc = build();
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is LoadedBannersState);
    bloc.showCondominiumSelector();
    await waitFor(() => bloc.state == const HomeViewState(showCondominumSelector: true, cards: []));
    bloc.collapseCondominiumSelector();
    await waitFor(() => bloc.state == const HomeViewState(showCondominumSelector: false, cards: []));
    bloc.showAgreementDialog();
    await waitFor(() => bloc.state is ShowAgreementDialogState);
    bloc.selectedUnity(testUnity(id: 'u9'));
    expect(sessionBloc.selectedUnits.single.id, 'u9');
  });

  test('getCards lê favoritos e onboarding do SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({
      'PREFERENCES_HOME_CARDS12345678901': jsonEncode({
        'favorites': ['income_control_billets', 'mailing_title', 'xpto']
      }),
      'PREFERENCES_HOME_CARDS_ONBOARDING12345678901': jsonEncode({'onboarding': true}),
    });
    final bloc = build();
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is LoadedBannersState);
    bloc.getCards();
    await waitFor(() => bloc.state is HomeViewState);
    expect(bloc.favorites, [HomeItemEnum.billets, HomeItemEnum.mailing]);
    expect((bloc.state as HomeViewState).cards, bloc.favorites);
    expect(bloc.animate.value, isFalse);
    expect(bloc.checkShowOnboarding(null), isTrue);
    expect(bloc.checkShowOnboarding(jsonEncode({'onboarding': false})), isTrue);
    expect(bloc.checkShowOnboarding(jsonEncode({'onboarding': true})), isFalse);
  });

  test('personalização desligada ignora favoritos', () async {
    sessionBloc = FakeSessionBloc(personalizationActive: false);
    final bloc = build();
    addTearDown(bloc.close);
    expect(bloc.checkFavoritesCard(jsonEncode({'favorites': ['tdb']})), isEmpty);
    expect(bloc.favorites, isEmpty);
    bloc.checkFavoritesCard(null);
    expect(bloc.favorites, isEmpty);
  });

  test('homeToGo depende do termo aceito', () async {
    final bloc = build();
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is LoadedBannersState);
    bloc.homeToGo();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state, isA<LoadedBannersState>());

    sessionBloc.session.unity = testUnity(id: 'u1', termHomeToGo: true);
    bloc.homeToGo();
    await waitFor(() => bloc.state is LoadedHomeToGoState);
    expect((bloc.state as LoadedHomeToGoState).link, 'link-u1');

    bloc.postTerms();
    await waitFor(() => bloc.state == const LoadedHomeToGoState(link: 'terms-u1'));
  });

  test('homeToGo e postTerms com falha', () async {
    sessionBloc.session.unity = testUnity(id: 'u1', termHomeToGo: true);
    final bloc = build(homeToGo: _FakeHomeToGo(fail: true), postTerms: _FakePostTerms(fail: true));
    addTearDown(bloc.close);
    await waitFor(() => bloc.state is LoadedBannersState);
    bloc.homeToGo();
    await waitFor(() => bloc.state is FailedHomeToGoState);
    bloc.postTerms();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(bloc.state, isA<FailedHomeToGoState>());
  });

  test('registerFcmToken monta o token com as unidades', () async {
    final register = _FakeRegisterFcm();
    final bloc = build(registerFcm: register);
    addTearDown(bloc.close);
    await bloc.registerFcmToken();
    expect(register.token!.token, 'fcm-token');
    expect(register.token!.type, 'APPMORAR');
    expect(register.token!.reference, ['u1']);
    expect(register.token!.deviceId, 'dev-1');
  });

  test('checkExpiration para proprietário', () async {
    final soon = DateTime.now().add(const Duration(days: 10));
    final far = DateTime.now().add(const Duration(days: 90));
    var bloc = build(subUsers: _FakeSubUsers(users: [_user(), _user(id: 'x', role: 'morar.morador', expiresAt: soon)]));
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isTrue);
    expect(bloc.isOwner, isTrue);

    bloc = build(subUsers: _FakeSubUsers(users: [_user(), _user(id: 'x', expiresAt: soon, status: 'PENDENTE')]));
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isFalse);

    bloc = build(subUsers: _FakeSubUsers(users: [_user(), _user(id: 'x', expiresAt: far)]));
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isFalse);
  });

  test('checkExpiration para morador comum', () async {
    final soon = DateTime.now().add(const Duration(days: 3));
    var bloc = build(subUsers: _FakeSubUsers(users: [_user(role: 'morar.morador', expiresAt: soon)]));
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isTrue);
    expect(bloc.isOwner, isFalse);

    bloc = build(subUsers: _FakeSubUsers(users: [_user(role: 'morar.morador')]));
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isFalse);

    bloc = build(subUsers: _FakeSubUsers());
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isFalse);

    bloc = build(subUsers: _FakeSubUsers(fail: true));
    addTearDown(bloc.close);
    expect(await bloc.checkExpiration(), isFalse);
  });

  test('requestAccessRenewal', () async {
    var bloc = build();
    addTearDown(bloc.close);
    expect(await bloc.requestAccessRenewal(), isTrue);
    bloc = build(renew: _FakeRenew(fail: true));
    addTearDown(bloc.close);
    expect(await bloc.requestAccessRenewal(), isFalse);
  });
}
