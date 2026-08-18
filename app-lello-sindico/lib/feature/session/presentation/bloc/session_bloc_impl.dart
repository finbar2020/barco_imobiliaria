import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/providers/session_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/shared_features.dart';

import 'session_event.dart';

class SessionBlocImpl extends SessionBloc {
  final AuthenticationStore authenticationStore;
  final LoadSession loadSession;
  final SaveSession saveSesion;
  final SwitchRoles switchRoles;
  var loadedFromCache = false;
  bool switchOnStart = false;

  FirebaseRemoteConfig? firebaseRemoteConfig;
  List<HomeNavigationItemEnum>? itens;
  List<ComfortYourCondoRemoteConfig> comfortYourCondoConfig;
  bool showAccessProfileJanitorWithGDP = false;
  final SessionDataProvider<ThemeColorValue?> sessionDataProvider =
      SessionDataProvider();

  SessionBlocImpl({
    required this.authenticationStore,
    required this.loadSession,
    required this.saveSesion,
    required this.switchRoles,
    this.comfortYourCondoConfig = const [],
  }) : super(SessionEmptyState()) {
    ManagerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.sessaoIniciar(), referenceValue: "");
    authenticationStore.bloc.stream.listen((authstate) {
      _authenticationChanged(authstate);
    });
    if (state is SessionEmptyState) {
      if (authenticationStore.bloc.state is AuthenticatedState) {
        beginLoadSession();
      }
    }
  }

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if (event is SessionLoadEvent) yield* _mapLoad(event);
    if (event is SessionSelectCondominiumEvent) {
      yield* _mapSelectCondominium(event);
    }
    if (event is SessionGetConsultorEvent) {
      yield* _mapGetConsultor(event);
    }
    if (event is SessionUpdateMeEvent) yield* _mapUpdateMe(event);
    if (event is SessionLogoutEvent) yield* _mapLogout(event);
    if (event is SessionEmptyEvent) yield SessionEmptyState();
  }

  @override
  void beginLoadSession({bool onLogin = false}) {
    add(SessionLoadEvent(onLogin: onLogin));
  }

  @override
  void selectCondominium(Condominium condo, BuildContext context) {
    add(SessionSelectCondominiumEvent(condo, context));
  }

  @override
  void logout({Failure? error, bool? restartApp}) {
    add(SessionLogoutEvent(error, restartApp));
  }

  @override
  void emptyState() {
    add(SessionEmptyEvent());
  }

  @override
  void getConsultor(ConsultantEntity consultantEntity) async {
    add(SessionGetConsultorEvent(consultantEntity));
  }

  @override
  void updateMe(Me? me) {
    if (me == null) {
      logout();
      return;
    }
    add(SessionUpdateMeEvent(me));
  }

  Stream<SessionState> _mapGetConsultor(SessionGetConsultorEvent event) async* {
    var session = _currentSession();
    session.consultantEntity = event.consultantEntity;
    yield SessionLoadedState(session, switchFailed: false, itens: itens);
    await _save(session);
  }

  Stream<SessionState> _mapSelectCondominium(
      SessionSelectCondominiumEvent event) async* {
    var session = _currentSession();
    yield SessionLoadingState(session);
    var switchFailed = false;
    var switchR = await switchRoles.call(SwitchParams(
        role: event.condominium.id, name: event.condominium.reference));
    switchR.fold(
        (l) =>
            authenticationStore.switchRole(role: event.condominium.reference),
        (token) => authenticationStore.switchRole(token: token!));
    if ((switchR is Success)) {
      session.selectedCondominium = event.condominium;
    } else {
      switchFailed = true;
    }
    yield SessionLoadedState(session, switchFailed: switchFailed, itens: itens);
    await _save(session);
  }

  Stream<SessionState> _mapLogout(SessionLogoutEvent event) async* {
    //logout
    Session session = _currentSession();
    var bkpMe = session.me?.copyWith();
    switchOnStart = false;
    session.selectedCondominium = null;
    session.me = null;
    await _save(session);
    if (event.restartApp == true) {
      yield SessionFailedState(
          event.failure ?? UnknownFailure("session_expired"), bkpMe);
    }
    return;
  }

  Stream<SessionState> _mapUpdateMe(SessionUpdateMeEvent event) async* {
    final me = event.me;
    Session session = _currentSession();
    session.me = event.me;
    if (me == null) {
      logout();
      return;
    }
    session.selectedCondominium ??=
        me.condominiums?.isNotEmpty == true ? me.condominiums!.first : null;

    yield SessionLoadedState(session, itens: itens);
    await _save(session);
  }

  Stream<SessionState> _mapLoad(SessionLoadEvent event) async* {
    await initFirebaseRemoteConfig();
    var current = _currentSession();
    yield SessionLoadingState(current);
    if (!loadedFromCache) {
      print("_mapLoad: Buscando cache");
      final cache = await loadSession.call(DataOrigin.local);
      if (cache is Success<Session>) {
        print("_mapLoad: Achou o cache");
        final Session data = cache.get();
        if (data.me != null &&
            data.me!.condominiums != null &&
            data.me!.condominiums!.isNotEmpty) {
          print("_mapLoad: Cache Válido");
          current = cache.get();
          loadedFromCache = true;
        }
      }
    }

    final remote = await loadSession.call(DataOrigin.remote);
    final SessionState sessionState = await remote.fold((err) {
      print("_mapLoad: Falha busca remoto, loadedFromCache: $loadedFromCache");
      if (!loadedFromCache) {
        return SessionFailedState(err, current.me);
      } else {
        return SessionLoadedState(current, itens: itens);
      }
    }, (session) async {
      print("_mapLoad: Sucesso o remoto");
      if (session.me?.condominiums != null) {
        session.selectedCondominium = session.me!.condominiums!.firstWhere(
            (element) => element == current.selectedCondominium,
            orElse: () => session.me!.condominiums!.first);
      }
      return SessionLoadedState(session, itens: itens);
    });

    if (sessionState is SessionLoadedState) {
      //Conseguiu buscar o session remoto
      if (switchOnStart == false &&
          (sessionState.session != null &&
              sessionState.session?.selectedCondominium?.reference != null)) {
        switchOnStart = true;
        if (kDebugMode) {
          print("_mapLoad: Fazendo Switch Roles");
        }

        var switchR = await switchRoles.call(SwitchParams(
            role: sessionState.session!.selectedCondominium?.id ?? "",
            name: sessionState.session!.selectedCondominium!.reference));
        var resultSwitch = await switchR.fold((l) {
          if (l is! ForbidenTokenFailure) {
            print("_mapLoad: Falha no Switch roles remoto, buscando cache");
            authenticationStore.switchRole(
                role: sessionState.session!.selectedCondominium!.reference);
          }
          return l;
        }, (token) {
          if (kDebugMode) {
            print("_mapLoad: Sucesso no Switch roles remoto");
          }
          authenticationStore.switchRole(token: token!);
          return token;
        });

        if (resultSwitch is ForbidenTokenFailure) {
          //Falhou o switch por forbidden token, deslogar
          FirebaseAnalytics.instance.logEvent(
            name: "sindico_sessao_expirada_switch_role",
            parameters: {
              "Tipo": "switch_role",
            },
          );
          logout(error: resultSwitch, restartApp: true);
          return;
        }
      }
    }

    if (sessionState.session?.me?.cpf?.isNotEmpty == true) {
      FirebaseCrashlytics.instance.setUserIdentifier(sessionState
          .session!.me!.cpf!
          .replaceAll(RegExp(r'[^\d ]'), "")
          .replaceAll(RegExp(r'[^\d ]'), ""));
    }

    var reference = sessionState.session?.selectedCondominium?.reference;
    if (reference != null && event.onLogin) {
      AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.geralLoginFinalizado(),
          referenceValue: reference,
          unitValue: "",
          appOrigin: AppOriginEnum.manager);
    }

    yield sessionState;
  }

  Future<void> _save(Session session) async {
    await saveSesion.call(session);
  }

  Session _currentSession() {
    var session = state.session;
    session ??= Session();
    return session;
  }

  void _authenticationChanged(AuthenticationState state) async {
    if (state is AuthenticatedState) {
      beginLoadSession(onLogin: state.onLogin ?? false);
    }
    if (state is UnautorizedState) {
      logout(restartApp: state.restartApp, error: state.error);
    }
  }

  @override
  void updatePicture(File image) {
    state.session!.me != state.session!.me!.copyWith(pictureFile: image);
  }

  @override
  bool checkRback(String rbac) {
    return authenticationStore.checkRback(rbac);
  }

  Future<bool> initFirebaseRemoteConfig() async {
    try {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(seconds: 12),
      ));
      // if (remoteConfig.lastFetchStatus != RemoteConfigFetchStatus.success) {
      await remoteConfig.fetch();
      await remoteConfig.fetchAndActivate();
      // }
      _getComfortYourCondo(remoteConfig);
      _getAccessProfileJanitorWithGDP(remoteConfig);
      mostAccessedCards = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.mostAccessedCards));

      itens = [
        HomeNavigationItemEnum.home,
        HomeNavigationItemEnum.condominium,
        HomeNavigationItemEnum.lello,
      ];
      firebaseRemoteConfig = remoteConfig;
      return true;
    } on Exception catch (e) {
      //log to crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  @override
  bool checkConfig(String rbac) {
    var remoteCustomRbacString =
        firebaseRemoteConfig?.getString(CustomFirebaseRemoteConfig.customRbac);
    if (remoteCustomRbacString == null || remoteCustomRbacString.isEmpty) {
      return false;
    }
    var remoteCustomRbac = jsonDecode(remoteCustomRbacString);

    String? references = "";
    if (remoteCustomRbac[rbac.replaceAll("_reference", "")] == true) {
      if ((references = remoteCustomRbac[rbac]) != null) {
        if (state is SessionLoadedState) {
          if (state.session?.selectedCondominium != null) {
            return references.toString().split("|").contains(
                    state.session?.selectedCondominium?.reference ?? "ALL") ||
                references.toString() == "ALL";
          }
        }
      }
    }
    return false;
  }

  @override
  FirebaseRemoteConfig? getRemoteConfig() {
    return firebaseRemoteConfig;
  }

  @override
  List<ComfortYourCondoRemoteConfig> getComfortToYourCondo() {
    return authenticationStore
            .checkRback(ApplicationRbac.sindicoComodidadesSeuCondominio)
        ? comfortYourCondoConfig
        : [];
  }

  _getComfortYourCondo(FirebaseRemoteConfig remoteConfig) {
    try {
      Map<String, dynamic> json = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.comfortYourCondo));
      comfortYourCondoConfig = List.generate(
          json[CustomFirebaseRemoteConfig.comfortYourCondo].length,
          (index) => ComfortYourCondoRemoteConfig.fromRemote(
              json[CustomFirebaseRemoteConfig.comfortYourCondo][index]));
    } catch (e) {
      comfortYourCondoConfig = [];
    }
  }

  _getAccessProfileJanitorWithGDP(FirebaseRemoteConfig remoteConfig) {
    try {
      showAccessProfileJanitorWithGDP = remoteConfig
          .getBool(CustomFirebaseRemoteConfig.showAccessProfileJanitorWithGDP);
    } catch (e) {
      showAccessProfileJanitorWithGDP = false;
    }
  }

  @override
  bool showAccessProfileJanitorGDP() {
    return showAccessProfileJanitorWithGDP;
  }

  @override
  bool get iSPreferencesPersonalizationActive {
    return getRemoteConfig()
            ?.getBool(CustomFirebaseRemoteConfig.homePersonalizationActive) ??
        false;
  }

  @override
  Future<bool> iSsplashIgnoreBiometricActive() async {
    if (firebaseRemoteConfig == null) {
      if (await initFirebaseRemoteConfig().timeout(const Duration(seconds: 10),
          onTimeout: () {
        return false;
      })) {
        return false;
      }
    }
    if (getRemoteConfig()?.lastFetchStatus != RemoteConfigFetchStatus.success) {
      return false;
    }
    return getRemoteConfig()
            ?.getBool(CustomFirebaseRemoteConfig.splashIgnoreBiometric) ??
        false;
  }

  @override
  ThemeColorValue? getThemeColor() {
    return sessionDataProvider.value;
  }

  @override
  void updateThemeColor(ThemeColorValue? value) {
    sessionDataProvider.update(value);
  }
}
