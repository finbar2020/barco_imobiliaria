import 'dart:async';
import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/update_pendency/update_pendency.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:lello/feature/home/domain/entity/home_item_enum.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class DashboardBlocImpl extends DashboardBloc {
  final ListPendency listPendency;
  final UpdatePendency updatePendency;
  final SessionBloc sessionBloc;
  Condominium? _condominium;

  StreamSubscription? sessionSubscription;
  List<Pendency> pendences = [];
  @override
  ValueNotifier<bool> animate = ValueNotifier<bool>(true);
  @override
  List<HomeItemEnum> favorites = [];
  SharedPreferences? preferences;
  String sharedKey = "PREFERENCES_HOME_CARDS_MANAGER";
  String sharedKeyOnboarding = "PREFERENCES_HOME_CARDS_ONBOARDING_MANAGER";

  DashboardBlocImpl(
      {required this.listPendency,
      required this.sessionBloc,
      required this.updatePendency})
      : super(DashboardState.empty()) {
    if (sessionBloc.state is SessionLoadedState) {
      onSessionChanged(sessionBloc.state);
    } else {
      sessionSubscription = sessionBloc.stream.listen(onSessionChanged);
    }
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is DashboardReadPendencyEvent) yield* _mapReadNotification(event);
    if (event is DashboardLoadEvent) yield* _mapLoad(event);
    if (event is DashboardNextPageEvent) yield* _mapNextPage(event);
    if (event is DashboardSessionFailedEvent) yield* _mapSessionFailed(event);
    if (event is DashboardLockScrollEvent) yield* _mapScrollLock(event);
    if (event is DashboardLockScrollEvent) yield* _mapScrollLock(event);
    if (event is DashboardGetMostAccessedEvent) {
      yield* _mapGetMostAcessed(event);
    }
  }

  @override
  void readPendency(Pendency pendency) {
    final params = UpdatePendencyParam(_condominium!.id, pendency.id!);

    updatePendency.call(params);
    add(DashboardReadPendencyEvent(pendency));
  }

  Stream<DashboardState> _mapReadNotification(
      DashboardReadPendencyEvent event) async* {
    final params = UpdatePendencyParam(_condominium!.id, event.pendency.id!);

    updatePendency(params);
    final data = state.data;

    yield DashboardLoadingSucceededState(data,
        data.isEmpty ? null : data.last.id, data.isEmpty, state.lockScroll);
  }

  Stream<DashboardState> _mapSessionFailed(
      DashboardSessionFailedEvent event) async* {
    var data = state.data;
    final cachedData = await _fetchCache();
    if (cachedData != null) {
      data = cachedData;
    }
    yield DashboardFailedState(event.error, data: data);
  }

  Stream<DashboardState> _mapLoad(DashboardLoadEvent event) async* {
    if (_condominium == null) return;

    var data = state.data;
    var loadedCache = false;

    if (!event.refresh!) {
      final cachedData = await _fetchCache();
      if (cachedData != null) {
        data = cachedData;
        loadedCache = true;
      }
    }

    yield loadedCache || event.refresh!
        ? DashboardRefreshingState(data)
        : DashboardLoadingState(data);

    final result =
        await listPendency.call(ListPendencyParam(_condominium!.reference));

    yield result.fold(
      (err) => DashboardFailedState(err),
      (data) => DashboardLoadingSucceededState(data,
          data.isEmpty ? null : data.last.id, data.isEmpty, state.lockScroll),
    );
  }

  Stream<DashboardState> _mapNextPage(DashboardNextPageEvent event) async* {
    if (_condominium == null) return;

    final data = state.data;
    yield DashboardPagingState(data, state.lastPendencyId!);
    final result = await listPendency.call(ListPendencyParam(
        _condominium!.reference,
        lastPendencyId: state.lastPendencyId!,
        currentSize: state.data.length));

    yield result.fold(
        (err) => DashboardPageFailedState(data, state.lastPendencyId!, err),
        (res) => DashboardLoadingSucceededState(
            state.data + res,
            res.lastOrNull()?.id ?? state.lastPendencyId,
            res.isEmpty,
            state.lockScroll));
  }

  Stream<DashboardState> _mapScrollLock(DashboardLockScrollEvent event) async* {
    yield DashboardScrollLockState(state.data, event.isLocked!);
  }

  Stream<DashboardState> _mapGetMostAcessed(
      DashboardGetMostAccessedEvent event) async* {
    yield DashboardLoadingState([]);

    var itens =
        await getMostAccessedList(sessionBloc.state as SessionLoadedState);

    yield DashboardLoadedState(itens);
  }

  @override
  void beginRefresh() {
    if (state is! DashboardLoadingState) {
      add(DashboardLoadEvent(refresh: true));
    }
  }

  @override
  void beginLoadNextPage() {
    add(DashboardNextPageEvent());
  }

  Future<List<Pendency>?> _fetchCache() async {
    final result = await listPendency.call(ListPendencyParam(
        _condominium!.reference,
        dataOrigin: DataOrigin.local));
    if (result is Success<List<Pendency>>) {
      final data = result.get();
      if (data.isNotEmpty) {
        return data;
      }
    }
    return null;
  }

  Future<void> onSessionChanged(SessionState state) async {
    if (state is SessionLoadedState) {
      _condominium = state.session?.selectedCondominium;
      add(DashboardGetMostAccessedEvent());
    } else if (state is SessionFailedState) {
      _condominium = state.session?.selectedCondominium;
      add(DashboardSessionFailedEvent(state.failure));
    }
  }

  @override
  Future<void> close() async {
    await sessionSubscription?.cancel();
    return super.close();
  }

  @override
  void beginLockScroll(bool isLocked) {
    add(DashboardLockScrollEvent(isLocked: isLocked));
  }

  Future<List<HomeItemEnum>> getMostAccessedList(
      SessionLoadedState session) async {
    List<HomeItemEnum> mostAccessedList =
        await fetchMostAccessedFromFirebaseOrLocal();

    List<HomeItemEnum?> checkedList = [];

    checkedList = mostAccessedList.map(
      (e) {
        if (e.rbac(sessionBloc)) {
          return e;
        }
      },
    ).toList();

    var mostAccessedItens = checkedList.whereType<HomeItemEnum>().toList();

    return mostAccessedItens;
  }

  Future<List<HomeItemEnum>> fetchMostAccessedFromFirebaseOrLocal() async {
    List<HomeItemEnum> mostAccessedList = [
      HomeItemEnum.manageSpace,
      HomeItemEnum.outcome,
      HomeItemEnum.income,
      HomeItemEnum.incomeMonthlyBillets,
    ];

    preferences = await SharedPreferences.getInstance();
    var getfavorites = preferences
        ?.getString("$sharedKey${sessionBloc.state.session?.me?.cpf}");
    var getOnboardingInfo = preferences?.getString(
        "$sharedKeyOnboarding${sessionBloc.state.session?.me?.cpf}");
    if (animate.value) {
      animate.value = checkShowOnboarding(getOnboardingInfo);
    }

    List<HomeItemEnum> favs = checkFavoritesCard(getfavorites);

    if (favs.isEmpty) {
      return mostAccessedList;
    }

    return favs;
  }

  List<HomeItemEnum> checkFavoritesCard(String? getfavorites) {
    //desabilita a personalização de cards
    if (sessionBloc.iSPreferencesPersonalizationActive == false) {
      return [];
    }
    if (getfavorites != null && getfavorites.isNotEmpty) {
      var decode = json.decode(getfavorites);
      if (decode['favorites'].isNotEmpty) {
        List<HomeItemEnum> favs = [];
        List.generate(decode['favorites'].length, (index) {
          for (var element in HomeItemEnum.values) {
            if (element.title == decode['favorites'][index]) {
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
}
