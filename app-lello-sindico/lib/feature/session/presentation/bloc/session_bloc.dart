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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:lello/feature/session/presentation/bloc/session_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/shared_features.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
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

  Map<String, dynamic>? mostAccessedCards;

  SessionBloc({
    required this.authenticationStore,
    required this.loadSession,
    required this.saveSesion,
    required this.switchRoles,
    this.comfortYourCondoConfig = const [],
  }) : super(const SessionEmptyState()) {
    on<SessionLoadEvent>(_mapLoad);
    on<SessionSelectCondominiumEvent>(_mapSelectCondominium);
    on<SessionGetConsultorEvent>(_mapGetConsultor);
    on<SessionUpdateMeEvent>(_mapUpdateMe);
    on<SessionLogoutEvent>(_mapLogout);
    on<SessionEmptyEvent>((event, emit) => emit(const SessionEmptyState()));
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

  void beginLoadSession({bool onLogin = false}) {
    add(SessionLoadEvent(onLogin: onLogin));
  }

  void selectCondominium(Condominium condo, BuildContext context) {
    add(SessionSelectCondominiumEvent(condo, context));
  }

  void logout({Failure? error, bool? restartApp}) {
    add(SessionLogoutEvent(error, restartApp));
  }

  void emptyState() {
    add(const SessionEmptyEvent());
  }

  void getConsultor(ConsultantEntity consultantEntity) {
    add(SessionGetConsultorEvent(consultantEntity));
  }

  void updateMe(Me? me) {
    if (me == null) {
      logout();
      return;
    }
    add(SessionUpdateMeEvent(me));
  }

  Future<void> _mapGetConsultor(
    SessionGetConsultorEvent event,
    Emitter<SessionState> emit,
  ) async {
    var session = _currentSession();
    session.consultantEntity = event.consultantEntity;
    emit(SessionLoadedState(session, switchFailed: false, itens: itens));
    await _save(session);
  }

  Future<void> _mapSelectCondominium(
    SessionSelectCondominiumEvent event,
    Emitter<SessionState> emit,
  ) async {
    var session = _currentSession();
    emit(SessionLoadingState(session));
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
    emit(SessionLoadedState(session, switchFailed: switchFailed, itens: itens));
    await _save(session);
  }

  Future<void> _mapLogout(
    SessionLogoutEvent event,
    Emitter<SessionState> emit,
  ) async {
    //logout
    Session session = _currentSession();
    var bkpMe = session.me?.copyWith();
    switchOnStart = false;
    session.selectedCondominium = null;
    session.me = null;
    await _save(session);
    if (event.restartApp == true) {
      emit(SessionFailedState(
          event.failure ?? UnknownFailure("session_expired"), bkpMe));
    }
    return;
  }

  Future<void> _mapUpdateMe(
    SessionUpdateMeEvent event,
    Emitter<SessionState> emit,
  ) async {
    final me = event.me;
    Session session = _currentSession();
    session.me = event.me;
    if (me == null) {
      logout();
      return;
    }
    session.selectedCondominium ??=
        me.condominiums?.isNotEmpty == true ? me.condominiums!.first : null;

    emit(SessionLoadedState(session, itens: itens));
    await _save(session);
  }

  Future<void> _mapLoad(
    SessionLoadEvent event,
    Emitter<SessionState> emit,
  ) async {
    await initFirebaseRemoteConfig();
    var current = _currentSession();
    emit(SessionLoadingState(current));
    if (!loadedFromCache) {
      debugPrint("_mapLoad: Buscando cache");
      final cache = await loadSession.call(DataOrigin.local);
      if (cache is Success<Session>) {
        debugPrint("_mapLoad: Achou o cache");
        final Session data = cache.get();
        if (data.me != null &&
            data.me!.condominiums != null &&
            data.me!.condominiums!.isNotEmpty) {
          debugPrint("_mapLoad: Cache Válido");
          current = cache.get();
          loadedFromCache = true;
        }
      }
    }

    final remote = await loadSession.call(DataOrigin.remote);
    final SessionState sessionState = await remote.fold((err) {
      debugPrint(
          "_mapLoad: Falha busca remoto, loadedFromCache: $loadedFromCache");
      if (!loadedFromCache) {
        return SessionFailedState(err, current.me);
      } else {
        return SessionLoadedState(current, itens: itens);
      }
    }, (session) async {
      debugPrint("_mapLoad: Sucesso o remoto");
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
          debugPrint("_mapLoad: Fazendo Switch Roles");
        }

        var switchR = await switchRoles.call(SwitchParams(
            role: sessionState.session!.selectedCondominium?.id ?? "",
            name: sessionState.session!.selectedCondominium!.reference));
        var resultSwitch = await switchR.fold((l) {
          if (l is! ForbidenTokenFailure) {
            debugPrint(
                "_mapLoad: Falha no Switch roles remoto, buscando cache");
            authenticationStore.switchRole(
                role: sessionState.session!.selectedCondominium!.reference);
          }
          return l;
        }, (token) {
          if (kDebugMode) {
            debugPrint("_mapLoad: Sucesso no Switch roles remoto");
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

    emit(sessionState);
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

  void updatePicture(File image) {
    state.session!.me != state.session!.me!.copyWith(pictureFile: image);
  }

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

  FirebaseRemoteConfig? getRemoteConfig() {
    return firebaseRemoteConfig;
  }

  List<ComfortYourCondoRemoteConfig> getComfortToYourCondo() {
    return authenticationStore
            .checkRback(ApplicationRbac.sindicoComodidadesSeuCondominio)
        ? comfortYourCondoConfig
        : [];
  }

  void _getComfortYourCondo(FirebaseRemoteConfig remoteConfig) {
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

  void _getAccessProfileJanitorWithGDP(FirebaseRemoteConfig remoteConfig) {
    try {
      showAccessProfileJanitorWithGDP = remoteConfig
          .getBool(CustomFirebaseRemoteConfig.showAccessProfileJanitorWithGDP);
    } catch (e) {
      showAccessProfileJanitorWithGDP = false;
    }
  }

  bool showAccessProfileJanitorGDP() {
    return showAccessProfileJanitorWithGDP;
  }

  bool get iSPreferencesPersonalizationActive {
    return getRemoteConfig()
            ?.getBool(CustomFirebaseRemoteConfig.homePersonalizationActive) ??
        false;
  }

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

  ThemeColorValue? getThemeColor() {
    return sessionDataProvider.value;
  }

  void updateThemeColor(ThemeColorValue? value) {
    sessionDataProvider.update(value);
  }
}
