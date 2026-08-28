import 'dart:async';
import 'dart:convert';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_event.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../digital_point/domain/use_case/get_points/get_points_by_status_usecase.dart';
import '../../../session/presentation/bloc/session_state.dart';
import '../bloc/home_bloc.dart';

class HomeController {
  final SessionBloc sessionBloc;
  final AuthenticationStore authenticationStore;
  final AppConnectivity connectivity;
  final GetPointsByStatusUsecase _getPointsByStatusUsecase;
  final GetPointsUsecase _getPointsUsecase;
  final GetToken getToken;
  late GhostNotificationUsecase ghostNotificationUsecase;
  AnalyticsTimer? colaboradorHomeTimer;

  final HomeBloc homeBloc;

  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  PageController? pageController;

  int currentPage = 0;
  int previousPage = 0;
  bool isHome = true;

  List<HomeItemEnum> mostAccessedCards = [];

  List<DigitalPointEntity> points = [];
  bool isConnected = false;

  SharedPreferences? preferences;
  String sharedKey = "PREFERENCES_HOME_CARDS_EMPLOYEE";
  String sharedKeyOnboarding = "PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE";
  List<HomeItemEnum> favorites = [];
  ValueNotifier<bool> animate = ValueNotifier<bool>(true);

  HomeController({
    required GetPointsUsecase getPointsUsecase,
    required GetPointsByStatusUsecase getPointsByStatusUsecase,
    required this.sessionBloc,
    required this.connectivity,
    required this.homeBloc,
    required this.authenticationStore,
    required this.getToken,
  })  : _getPointsByStatusUsecase = getPointsByStatusUsecase,
        _getPointsUsecase = getPointsUsecase {
    if (sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(sessionBloc.state);
    } else {
      sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  Future<void> _onSessionChanged(SessionState sessionState) async {
    if (sessionState is SessionLoadedState) {
      await getDigitalPoints();
      await getMostAccessedList(sessionState);
    }
  }

  void sessionSubscription() {
    sessionBloc.stream.listen(_onSessionChanged);
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    if (connectivity.isConnected(result)) {
      sessionBloc.beginLoadSession();
    }
    if (connectivity.isConnected(result) != isConnected) {
      isConnected = !isConnected;
      homeBloc.add(HomeLoadEvent(digitalPoints: points));
    }
  }

  void setUpConnectivity() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    connectivity.checkConnectivity().then(
      (value) {
        isConnected = value;
        homeBloc.add(
          HomeLoadEvent(digitalPoints: points),
        );
      },
    );
  }

  Future getCards() async {
    await getMostAccessedList(sessionBloc.state as SessionLoadedState);
  }

  Future getMostAccessedList(SessionLoadedState session) async {
    List<HomeItemEnum> mostAccessedList =
        await fetchMostAccessedFromFirebaseOrLocal();

    List<HomeItemEnum> checkedList = [];

    checkedList = mostAccessedList
        .where(
          (e) => e.checkRbac(sessionBloc) == true,
        )
        .toList();
    if (session.session.condominium.canRegisterDigitalPointStatus == true) {
      if (checkedList.contains(HomeItemEnum.sendTimeSheet)) {
        checkedList.remove(HomeItemEnum.sendTimeSheet);
      }
    } else {
      if (checkedList.contains(HomeItemEnum.registerDigitalPoint)) {
        checkedList.remove(HomeItemEnum.registerDigitalPoint);
      }
    }

    mostAccessedCards = checkedList;

    homeBloc.add(HomeLoadEvent(digitalPoints: points));
  }

  Future<List<HomeItemEnum>> fetchMostAccessedFromFirebaseOrLocal() async {
    List<HomeItemEnum> mostAccessedList = [
      HomeItemEnum.discounts,
      HomeItemEnum.registerDigitalPoint,
      HomeItemEnum.proof,
      HomeItemEnum.myDocuments,
    ];

    preferences = await SharedPreferences.getInstance();
    var getfavorites = preferences?.getString("$sharedKey${session?.me.cpf}");
    var getOnboardingInfo =
        preferences?.getString("$sharedKeyOnboarding${session?.me.cpf}");
    if (animate.value) {
      animate.value = checkShowOnboarding(getOnboardingInfo);
    }
    List<HomeItemEnum> favs = checkFavoritesCard(getfavorites);

    if (favs.isNotEmpty) {
      mostAccessedList =
          favs.where((element) => element.checkRbac(sessionBloc)).toList();
    } else {
      mostAccessedList = mostAccessedList
          .where((element) => element.checkRbac(sessionBloc))
          .toList();
    }
    return mostAccessedList;
  }

  Future<void> getDigitalPoints() async {
    Session? session = sessionBloc.getSession;

    String condoId = session?.condominium.id ?? "";
    String meId = session?.me.id ?? "";

    final result = await _getPointsByStatusUsecase(
      GetPointsByStatusParam(
        condoId: condoId,
        meId: meId,
        pointStatus: enumToString(DigitalPointStatusEnum.pending)!,
      ),
    );

    result.fold(
      (error) => points = [],
      (points) {
        this.points = points;
        homeBloc.add(
          HomeLoadEvent(digitalPoints: this.points),
        );
      },
    );
  }

  Future<void> getAllDigitalPointsWithLogs() async {
    Session? session = sessionBloc.getSession;

    String condoId = session?.condominium.id ?? "";
    String meId = session?.me.id ?? "";

    final result = await _getPointsUsecase(
      GetPointsParam(
        condoId: condoId,
        meId: meId,
      ),
    );

    result.fold(
      (error) => points = [],
      (points) => this.points = points,
    );
  }

  Session? get session => sessionBloc.getSession;

  List<HomeItemEnum> checkFavoritesCard(String? getfavorites) {
    //desabilita a personalização de cards
    if (sessionBloc.iSPreferencesPersonalizationActive == false) {
      return <HomeItemEnum>[];
    }
    if (getfavorites != null && getfavorites.isNotEmpty) {
      var decode = json.decode(getfavorites);
      if (decode['favorites'].isNotEmpty) {
        List<HomeItemEnum> favs = [];
        List.generate(decode['favorites'].length, (index) {
          for (var element in HomeItemEnum.values) {
            if (element.titleKey == decode['favorites'][index]) {
              favs.add(element);
            }
          }
        });
        favorites = favs;
        animate.value = false;
      }
    }
    return favorites;
  }

  bool checkShowOnboarding(String? onboarding) {
    if (onboarding != null && onboarding.isNotEmpty) {
      var decode = json.decode(onboarding);
      return decode['onboarding'] != true;
    } else {
      return true;
    }
  }

  Future<AccessToken?> get _getAccessToken async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  void colaboradorHomeTimerStart() async {
    colaboradorHomeTimer = AnalyticsTimer(
      userType: await _getUserType,
      userId: session?.me.id ?? "",
      event: AnalyticsEventsEmployee.colaboradorHomeTemporizador(),
      referenceValue:
          sessionBloc.getSession?.condominium.reference.toString() ?? "",
      appOrigin: AppOriginEnum.employee,
    );
  }

  void colaboradorHomeTimerStop() {
    colaboradorHomeTimer?.stopTimer();
  }
}
