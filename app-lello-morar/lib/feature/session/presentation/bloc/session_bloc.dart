import 'dart:async';
import 'dart:convert';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/providers/session_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:morar/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/stores/remote_config_store.dart';
import 'session_event.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final AuthenticationStore authenticationStore;
  final LoadSession loadSession;
  final SaveSession saveSesion;
  final SwitchRoles switchRoles;
  final RemoteConfigStore remoteConfigStore;
  final String baseUrl;
  var loadedFromCache = false;
  bool switchOnStart = false;
  FirebaseRemoteConfig? firebaseRemoteConfig;
  HortaRemoteConfigEntity? hortaConfig;
  InsuranceTableModel? insuranceTable;

  StreamSubscription? loginSubscription;

  final SessionDataProvider<ThemeColorValue?> sessionDataProvider =
      SessionDataProvider();

  SessionBloc({
    required this.remoteConfigStore,
    required this.authenticationStore,
    required this.loadSession,
    required this.saveSesion,
    required this.switchRoles,
    required this.baseUrl,
  }) : super(const SessionInitialState()) {
    on<SessionEmptyEvent>((event, emit) => emit(const SessionInitialState()));
    on<SessionLoadEvent>(_mapLoad);
    on<SessionSelectUnityEvent>(_mapSelectUnity);
    on<SessionSelectCondominiumEvent>(_mapSelectCondominium);
    on<SessionUpdateMeEvent>(_mapUpdateMe);
    on<SessionLogoutEvent>(_mapLogout);
    OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.sessaoIniciar(),
        userId: "",
        referenceValue: "",
        unitValue: "");
    authenticationStore.bloc.stream.listen((authstate) {
      _authenticationChanged(authstate);
    });
    if (state is SessionInitialState) {
      if (authenticationStore.bloc.state is AuthenticatedState) {
        beginLoadSession();
      }
    }
  }

  Future<void> _ensureRemoteConfig() async {
    if (firebaseRemoteConfig == null) {
      await initFirebaseRemoteConfig();
    }
  }

  void beginLoadSession({bool onLogin = false}) {
    add(SessionLoadEvent(onLogin: onLogin));
  }

  void logout({Failure? error, bool? restartApp}) {
    add(SessionLogoutEvent(error, restartApp));
  }

  void emptyState() {
    add(const SessionEmptyEvent());
  }

  void updateMe(Me? me) {
    if (me == null) {
      logout();
      return;
    }
    add(SessionUpdateMeEvent(me));
  }

  void selectedUnity(Unity unity) {
    add(SessionSelectUnityEvent(unity));
  }

  void selectedCondominium(Unity unity) {
    add(SessionSelectUnityEvent(unity));
  }

  Future<void> _mapSelectCondominium(
    SessionSelectCondominiumEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _ensureRemoteConfig();
    var session = _currentSession();
    session.condominium = event.condominium;
    emit(SessionLoadedState(session));
    await _save(session);
  }

  Future<void> _mapSelectUnity(
    SessionSelectUnityEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _ensureRemoteConfig();
    var session = _currentSession();
    emit(SessionLoadingState(session));
    var switchFailed = false;
    String? role;
    var switchR = await switchRoles
        .call(SwitchParams(role: event.unity.id!, name: session.tokenName!));
    switchR
        .fold((l) => authenticationStore.switchRole(role: session.tokenName!),
            (token) {
      role = token?.selectedRole;
      return authenticationStore.switchRole(token: token);
    });
    FirebaseAnalytics.instance.logEvent(
      name: "morar_morador_login",
      parameters: {
        "tipo": "login",
        "role": role ?? "",
      },
    );
    if ((switchR is Success)) {
      session.unity = event.unity;
    } else {
      switchFailed = true;
    }

    emit(SessionLoadedState(session, switchFailed: switchFailed));
    await _save(session);
  }

  Future<void> _mapLogout(
    SessionLogoutEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _ensureRemoteConfig();
    final session = _currentSession();
    var bkpMe = session.me == null ? null : Me.clone(session.me!);
    session.condominium = null;
    session.unity = null;
    session.me = null;
    if (event.restartApp == true) {
      emit(SessionFailedState(
        event.failure ?? UnknownFailure("expired_session"),
        bkpMe,
      ));
    } else {
      await _save(session);
    }
  }

  Future<void> _mapUpdateMe(
    SessionUpdateMeEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _ensureRemoteConfig();
    final me = event.me;
    Session session = _currentSession();
    session.me = event.me;
    if (me == null) {
      logout();
      return;
    }
    if (session.condominium == null) {
      session.condominium =
          me.condominiums?.isNotEmpty == true ? me.condominiums!.first : null;
      if (session.condominium != null) {
        session.unity = session.condominium!.blocks!.first.units!.first;
      }
    }

    emit(SessionLoadedState(session));
    await _save(session);
  }

  Future<void> _mapLoad(
    SessionLoadEvent event,
    Emitter<SessionState> emit,
  ) async {
    await _ensureRemoteConfig();
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
            data.me!.condominiums!.length > 0) {
          debugPrint("_mapLoad: Cache Válido");
          current = data;
          loadedFromCache = true;
        }
      }
    }

    final remote = await loadSession.call(DataOrigin.remote);
    final SessionState sessionState = await remote.fold((err) {
      debugPrint(
          "_mapLoad: Falha busca remoto, loadedFromCache: $loadedFromCache");
      if (!loadedFromCache) {
        FirebaseAnalytics.instance.logEvent(
          name: "morar_sessao_expirada_read",
          parameters: {
            "Tipo": "read",
          },
        );
        return SessionFailedState(err, current.me);
      } else {
        return SessionLoadedState(current);
      }
    }, (session) async {
      debugPrint("_mapLoad: Sucesso o remoto");
      if (current.condominium != null &&
          session.me?.condominiums != null &&
          session.me!.condominiums!.isNotEmpty) {
        session.condominium = session.me?.condominiums?.firstWhere(
            (element) => element.reference == current.condominium?.reference,
            orElse: () => session.me!.condominiums!.first);
      }
      if (current.unity != null) {
        session.condominium?.blocks?.forEach((element) {
          element.units?.forEach((element) {
            if (element.title == current.unity!.title) {
              session.unity = element;
            }
          });
        });
      }
      return SessionLoadedState(session);
    });

    if (sessionState is SessionLoadedState) {
      //Conseguiu buscar o session remoto
      if (switchOnStart == false &&
          sessionState.session != null &&
          sessionState.session?.unity?.id != null &&
          sessionState.session?.tokenName != null) {
        switchOnStart = true;
        debugPrint("_mapLoad: Fazendo Switch Roles");
        var switchR = await switchRoles.call(SwitchParams(
            role: sessionState.session!.unity!.id!,
            name: sessionState.session!.tokenName!));
        var resultSwitch = switchR.fold((l) {
          // switchOnStart = false;
          // loadedFromCache = false;
          if (l is! ForbidenTokenFailure) {
            debugPrint("_mapLoad: Falha no Switch roles remoto, buscando cache");
            authenticationStore.switchRole(
                role: sessionState.session!.tokenName!);
          }
          return l;
        }, (token) {
          debugPrint("_mapLoad: Sucesso no Switch roles remoto");
          FirebaseAnalytics.instance.logEvent(
            name: "morar_morador_login",
            parameters: {
              "tipo": "login",
              "role": token?.selectedRole ?? "",
            },
          );
          authenticationStore.switchRole(token: token);
          return token;
        });

        if (resultSwitch is ForbidenTokenFailure) {
          FirebaseAnalytics.instance.logEvent(
            name: "morar_sessao_expirada_switch_role",
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
      var cpf = sessionState.session!.me!.cpf!
          .replaceAll(RegExp(r'[^\d ]'), "")
          .replaceAll(RegExp(r'[^\d ]'), "");
      FirebaseAnalytics.instance.setUserId(id: cpf);
      FirebaseAnalytics.instance.setUserProperty(name: "cpf", value: cpf);
      FirebaseCrashlytics.instance.setUserIdentifier(cpf);
      DatadogSdk.instance.setUserInfo(
          id: sessionState.session?.me?.id ?? cpf,
          email: sessionState.session?.me?.email,
          name: sessionState.session?.me?.name,
          extraInfo: {
            "cpf": sessionState.session?.me?.cpf,
            "idUnidade": sessionState.session?.unity?.notificationContext,
            "unidade": sessionState.session?.unity?.title,
            "referencia": sessionState.session?.condominium?.reference,
          });
    }

    var reference = sessionState.session?.condominium?.reference;
    var unityName = sessionState.session?.unity?.title;
    if (reference != null && event.onLogin) {
      AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.loginFinalizado(),
          referenceValue: reference,
          unitValue: unityName,
          appOrigin: AppOriginEnum.owner);
    }
    emit(sessionState);
  }

  Future<void> _save(Session session) async {
    await saveSesion.call(session);
  }

  Session _currentSession() {
    var session = state.session;
    if (session == null) {
      session = Session();
    }
    return session;
  }

  void _authenticationChanged(AuthenticationState authState) async {
    if (authState is AuthenticatedState) {
      if (authState.onLogin == true || state is SessionInitialState) {
        beginLoadSession(onLogin: authState.onLogin ?? false);
      } else if (authState.me != null) {
        debugPrint("updateUserGhost: Update Me");
        updateMe(authState.me);
      }
    }
    if (authState is UnautorizedState) {
      logout(error: authState.error, restartApp: authState.restartApp);
    }
  }

  @override
  Future<void> close() {
    loginSubscription?.cancel();
    return super.close();
  }

  bool checkRback(String rbac) {
    return authenticationStore.checkRback(rbac);
  }

  Future<bool> initFirebaseRemoteConfig() async {
    var result = await remoteConfigStore.initFirebaseRemoteConfig();
    _checkHortaConfig(remoteConfigStore.remoteConfig);
    _checkInsuranceTable(remoteConfigStore.remoteConfig);
    firebaseRemoteConfig = remoteConfigStore.remoteConfig;
    return result;
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
          if (state.session?.condominium != null) {
            return references
                    .toString()
                    .split("|")
                    .contains(state.session?.condominium?.reference ?? "ALL") ||
                references.toString() == "ALL";
          }
        }
      }
    }
    return false;
  }

  FirebaseRemoteConfig? get getRemoteConfig {
    return firebaseRemoteConfig;
  }

  FirebaseRemoteConfigLink? getRemoteConfigForLinks(String configKey) {
    if (firebaseRemoteConfig == null) return null;
    try {
      return FirebaseRemoteConfigLink.fromJson(
          jsonDecode(firebaseRemoteConfig!.getString(configKey)));
    } on Exception {
      return null;
    }
  }

  String getBaseUrl() {
    return baseUrl;
  }

  HortaRemoteConfigEntity? getHortaRemoteConfig() {
    return hortaConfig;
  }

  InsuranceTableModel? getInsuranceTable() {
    return insuranceTable;
  }

  void _checkHortaConfig(FirebaseRemoteConfig remoteConfig) {
    try {
      Map<String, dynamic> json =
          jsonDecode(remoteConfig.getString(CustomFirebaseRemoteConfig.horta));
      List<HortaRemoteConfigEntity> horta = List.generate(json["horta"].length,
          (index) => HortaRemoteConfigEntity.fromRemote(json["horta"][index]));
      hortaConfig = horta.firstWhereOrNull((element) =>
          element.limitDate == null ||
          DateTime.now().isBefore(element.limitDate!));
    } catch (e) {
      hortaConfig = null;
    }
  }

  void _checkInsuranceTable(FirebaseRemoteConfig remoteConfig) {
    try {
      Map<String, dynamic> json = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.insuranceTable));
      debugPrint("INSURANCE TABLE => $json");
      insuranceTable = InsuranceTableModel.fromJson(json);
      debugPrint("INSURANCE TABLE => $insuranceTable");
    } catch (e) {
      insuranceTable = null;
    }
  }

  bool get iSPreferencesPersonalizationActive {
    return getRemoteConfig
            ?.getBool(CustomFirebaseRemoteConfig.homePersonalizationActive) ??
        false;
  }

  Future<bool> iSsplashIgnoreBiometricActive() async {
    if (firebaseRemoteConfig == null) {
      if (await initFirebaseRemoteConfig().timeout(Duration(seconds: 10),
          onTimeout: () {
        return false;
      })) {
        return false;
      }
    }
    if (getRemoteConfig?.lastFetchStatus != RemoteConfigFetchStatus.success) {
      return false;
    }
    return getRemoteConfig
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
