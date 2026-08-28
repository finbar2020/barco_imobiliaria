import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:colaborador/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_event.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/navigation/application_rbac.dart';
import '../../../../core/stores/session_store.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SwitchRoles switchRoles;
  final AuthenticationStore authenticationStore;
  final LoadSession loadSession;
  final SaveSession saveSession;
  final LogMeOut logMeOut;
  final String baseUrl;
  final SessionStore store;

  FirebaseRemoteConfig? firebaseRemoteConfig;
  Timer? sessionTimer;
  bool doSchedule = true;
  bool switchOnStart = false;
  bool loadedFromCache = false;

  StreamSubscription? sessionListener;
  late StreamSubscription authListener;

  SessionBloc({
    required this.authenticationStore,
    required this.saveSession,
    required this.loadSession,
    required this.baseUrl,
    required this.switchRoles,
    required this.logMeOut,
    required this.store,
  }) : super(const SessionInitialState()) {
    EmployeeAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsEmployee.sessaoIniciar(),
      referenceValue: "",
    );
    on<SessionLoadEvent>(handleSessionLoadEvent);
    on<SessionUpdateMeEvent>(handleSessionUpdateMeEvent);
    on<SessionCheckTabletSessionExpiredEvent>(
        handleSessionCheckTabletSessionExpiredEvent);
    on<SessionLogoutEvent>(_mapLogout);
    if (firebaseRemoteConfig == null) {
      initFirebaseRemoteConfig();
    }
    authListener = authenticationStore.bloc.stream.listen((authstate) {
      _authenticationChanged(authstate);
    });
    pipeline();
  }

  void pipeline() {
    if (authenticationStore.bloc.state is AuthenticatedState) {
      beginLoadSession();
    }
  }

  void handleSessionCheckTabletSessionExpiredEvent(
    SessionCheckTabletSessionExpiredEvent event,
    Emitter emit,
  ) async {
    bool isValid = true;
    // isValid = await authenticationBloc
    //     .checkValidTabletSession(const Duration(minutes: 30));

    log("checkTabletSession: isValid: $isValid");
    // if (!isValid) {
    //   var result = await logoutPipeline();
    //   if (result is Success) {
    //     emit(
    //       SessionExpiredTabletState(),
    //     );
    //   }
    // }
  }

  void _mapLogout(
    SessionLogoutEvent event,
    Emitter emit,
  ) async {
    await _save(null);
    if (event.restartApp == true) {
      emit(SessionFailedState(
          error: event.failure ?? UnknownFailure("session_expired")));
      return;
    }
    emit(const SessionInitialState());
    return;
  }

  void handleSessionUpdateMeEvent(
    SessionUpdateMeEvent event,
    Emitter emit,
  ) async {
    var session = getSession;
    if (event.me == null) {
      logout();
    } else {
      if (session != null) {
        // Um novo `Session` é obrigatório: o bloc descarta estados iguais ao
        // atual e `SessionLoadedState` compara pela instância da sessão, então
        // mutar a sessão existente não notificaria ninguém.
        final updated = Session(
          me: event.me!,
          condominium: session.condominium,
        );
        final lastPosition = session.lastPosition;
        if (lastPosition != null) {
          updated.setLastPosition(lastPosition);
        }
        emit(
          SessionLoadedState(
            session: updated,
            isTabletSession: await TabletSessionUtils.getIsTabletSession(
                AppOriginEnum.employee),
          ),
        );
        store.setSession(session: updated);
        await _save(updated);
      }
    }
  }

  Future<void> handleSessionLoadEvent(
    SessionLoadEvent event,
    Emitter emit,
  ) async {
    debugPrint(
        "_mapLoad: yield Loading State - loadedFromCache: $loadedFromCache");

    emit(const SessionLoadingState());

    final sessionRemote = await getRemoteSession();
    if (sessionRemote is SessionFailedState) {
      final sessionLocal = await getLocalSession();
      if (sessionLocal != null) {
        emit(sessionLocal);
      } else {
        emit(sessionRemote);
      }
    } else {
      emit(sessionRemote);
    }
    loadedFromCache = false;
  }

  Future<SessionState?> getLocalSession() async {
    bool? isTabletSession =
        await TabletSessionUtils.getIsTabletSession(AppOriginEnum.employee);
    Session? current = getSession;

    if (!loadedFromCache) {
      debugPrint("_mapLoad: Buscando cache");
      final cache = await loadSession.call(DataOrigin.local);
      if (cache is Success<Session>) {
        debugPrint("_mapLoad: Achou o cache");
        final Session data = cache.get();
        if (data.me.isValid) {
          debugPrint("_mapLoad: Cache Válido");
          current = data;
          loadedFromCache = true;

          store.setSession(session: current);
          return SessionLoadedState(
              session: current, isTabletSession: isTabletSession);
        }
      }
    }
    return null;
  }

  Future<SessionState> getRemoteSession() async {
    bool? isTabletSession =
        await TabletSessionUtils.getIsTabletSession(AppOriginEnum.employee);
    Session? current = getSession;

    final remote = await loadSession.call(DataOrigin.remote);
    final SessionState sessionState = await remote.fold(
      (err) {
        debugPrint(
            "_mapLoad: Falha busca remoto, loadedFromCache: $loadedFromCache");
        if (!loadedFromCache || current == null) {
          return SessionFailedState(error: err);
        } else {
          return SessionLoadedState(
              session: current, isTabletSession: isTabletSession);
        }
      },
      (session) {
        if (session.me.condominiums.isNotEmpty) {
          debugPrint(
              "_mapLoad: Sucesso busca remoto, session.me.condominiums.isNotEmpty: ${session.me.condominiums.isNotEmpty}");
          session.condominium = session.me.condominiums.firstWhere(
            (element) => element.reference == current?.condominium.reference,
            orElse: () => session.me.condominiums.first,
          );
        }
        if (isTabletSession) {
          session.me.isTabletSession = isTabletSession;
        }

        return SessionLoadedState(
          session: session,
          isTabletSession: isTabletSession,
        );
      },
    );

    if (sessionState is SessionLoadedState) {
      store.setSession(session: sessionState.session);
      //Conseguiu buscar o session remoto
      if (switchOnStart == false) {
        switchOnStart = true;
        debugPrint("_mapLoad: Fazendo Switch Roles");

        var switchR = await switchRoles.call(
          SwitchParams(
              role: sessionState.session.condominium.id,
              name: sessionState.session.condominium.reference),
        );
        switchR.fold(
          (failure) {
            debugPrint(
                "_mapLoad: Falha no Switch roles remoto, buscando cache");

            return authenticationStore.switchRole(
                role: sessionState.session.condominium.reference);
          },
          (token) {
            debugPrint("_mapLoad: Sucesso no Switch roles remoto");
            return authenticationStore.switchRole(token: token!);
          },
        );
      }

      if (sessionState.session.me.cpf.isNotEmpty != true) {
        FirebaseCrashlytics.instance.setUserIdentifier(
          sessionState.session.me.cpf
              .replaceAll(RegExp(r'[^\d ]'), "")
              .replaceAll(RegExp(r'[^\d ]'), ""),
        );
      }
      if (doSchedule) {
        _scheduleNotifications(sessionState);
      }
    }
    return sessionState;
  }

  void beginLoadSession({bool onLogin = false, bool onlyLocal = false}) {
    debugPrint("Emitindo session Load Event");
    add(SessionLoadEvent(onLogin: onLogin, onlyLocal: onlyLocal));
  }

  void logout({Failure? error, bool? restartApp}) {
    add(SessionLogoutEvent(error, restartApp));
  }

  void updateMe(Me? me) {
    if (me == null) {
      logout();
      return;
    }
    add(SessionUpdateMeEvent(me));
  }

  bool checkRback(String rbac) {
    return authenticationStore.checkRback(rbac);
  }

  String getBaseUrl() {
    return baseUrl;
  }

  void initFirebaseRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 60),
      minimumFetchInterval: const Duration(seconds: 10),
      // minimumFetchInterval: const Duration(hours: 12),
    ));
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    firebaseRemoteConfig = remoteConfig;
  }

  void _scheduleNotifications(SessionLoadedState sessionState) {
    // Workmanager().cancelAll();

    var proximosDias = sessionState.session.condominium.nextWorkSchedule(2);

    var today = DateTime.now();

    for (WorkShiftDetails day in proximosDias) {
      if (day.isDayOff) continue;

      //hora1
      if (day.entry1DateLate != null &&
          day.entry1DateLate!.millisecondsSinceEpoch > 0 &&
          day.entry1DateLate!.isAfter(today)) {
        Workmanager().registerOneOffTask("verificar-ponto-entry1Date-Task",
            "verificar-ponto-entry1Date-Task",
            initialDelay: day.entry1DateLate!.difference(today),
            inputData: {"date": day.entry1Date!.toIso8601String()});
      }
      //hora2
      if (day.out1DateLate != null &&
          day.out1DateLate!.millisecondsSinceEpoch > 0 &&
          day.out1DateLate!.isAfter(today)) {
        Workmanager().registerOneOffTask(
            "verificar-ponto-out1Date-Task", "verificar-ponto-out1Date-Task",
            initialDelay: day.out1DateLate!.difference(today),
            inputData: {"date": day.out1Date!.toIso8601String()});
      }
      //hora3
      if (day.entry2DateLate != null &&
          day.entry2DateLate!.millisecondsSinceEpoch > 0 &&
          day.entry2DateLate!.isAfter(today)) {
        Workmanager().registerOneOffTask("verificar-ponto-entry2Date-Task",
            "verificar-ponto-entry2Date-Task",
            initialDelay: day.entry2DateLate!.difference(today),
            inputData: {"date": day.entry2Date!.toIso8601String()});
      }
      //hora4
      if (day.out2DateLate != null &&
          day.out2DateLate!.millisecondsSinceEpoch > 0 &&
          day.out2DateLate!.isAfter(today)) {
        Workmanager().registerOneOffTask(
          "verificar-ponto-out2Date-Task",
          "verificar-ponto-out2Date-Task",
          initialDelay: day.out2DateLate!.difference(today),
          inputData: {
            "date": day.out2Date!.toIso8601String(),
          },
        );
      }
    }
  }

  void _authenticationChanged(AuthenticationState authenticationState) async {
    debugPrint(
        "AuthenticationChanged : authenticationState is ${authenticationState.toString()}");
    if (authenticationState is AuthenticatedState) {
      debugPrint("AuthenticationChanged : state is AuthenticatedState");
      if (state is SessionInitialState || authenticationState.onLogin == true) {
        beginLoadSession(onLogin: authenticationState.onLogin ?? false);
      }
    } else if (authenticationState is UnauthenticatedState) {
      switchOnStart = false;
      debugPrint(
          "AuthenticationChanged : authenticationState is ${authenticationState.toString()}");
    } else if (authenticationState is UnautorizedState) {
      switchOnStart = false;
      debugPrint(
          "AuthenticationChanged : UnautorizedState is ${authenticationState.toString()}");
      logout(
          error: authenticationState.error,
          restartApp: authenticationState.restartApp);
    }
  }

  Future<void> _save(Session? session) async {
    await saveSession.call(session);
  }

  FirebaseRemoteConfig? get remoteConfig => firebaseRemoteConfig;

  void stopSchedulerTask() {
    doSchedule = false;
  }

  @override
  Future<void> close() {
    authListener.cancel();
    sessionListener?.cancel();
    sessionTimer?.cancel();
    return super.close();
  }

  Future<Try<Nothing>> logoutPipeline() async {
    sessionTimer?.cancel();
    final result = await logMeOut();
    logout();
    authenticationStore.logout();
    return result;
  }

  Session? get getSession => (state is SessionLoadedState)
      ? (state as SessionLoadedState).session
      : null;

  bool get canRegisterPoint => checkRback(
        ApplicationRbacEnum.colaboradorPontodigitalMarcarPontoWrite
            .toFormattedString(),
      );

  bool showButtonNoAuthPointList(String reference) {
    try {
      if (remoteConfig != null) {
        Map<String, dynamic> map = json.decode(
          remoteConfig!.getString("button_no_auth_points_list"),
        );
        if (map["references"].isEmpty) {
          return false;
        }
        List<String> references = List.generate(
            map["references"].length, (index) => map["references"][index]);
        String hasRef = references.firstWhere((element) => element == reference,
            orElse: () => "");
        return hasRef.isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool get iSPreferencesPersonalizationActive {
    return firebaseRemoteConfig
            ?.getBool(CustomFirebaseRemoteConfig.homePersonalizationActive) ??
        false;
  }
}
