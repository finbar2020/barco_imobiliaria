import 'dart:async';
import 'dart:convert';

import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/home/domain/use_cases/get_banner/get_banner.dart';
import 'package:morar/feature/home/domain/use_cases/home_to_go/home_to_go.dart';
import 'package:morar/feature/home/domain/use_cases/post_terms/post_terms.dart';
import 'package:morar/feature/home/presentation/bloc/home_event.dart';
import 'package:morar/feature/home/presentation/bloc/home_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart';

import '../../../sub_user/domain/use_cases/get_sub_user/sub_user.dart';
import '../../../sub_user/domain/use_cases/send_access_renew_reques_use_case.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RegisterFcm registerFcm;
  final SessionBloc sessionBloc;
  final GetBanner getBanner;
  final HomeToGo clubLello;
  final PostTerms postLello;
  final SubUserUseCase subUserUseCase;
  final SendAccessRenewRequestUseCase sendAccessRenewRequestUseCase;
  final DeviceIdentifierService deviceIdentifierService;

  StreamSubscription? _subscription;

  HomeBloc({
    required this.registerFcm,
    required this.sessionBloc,
    required this.getBanner,
    required this.clubLello,
    required this.postLello,
    required this.subUserUseCase,
    required this.sendAccessRenewRequestUseCase,
    required this.deviceIdentifierService,
  }) : super(const HomeViewState(showCondominumSelector: false)) {
    on<ShowCondominiumSelectorHomeEvent>((event, emit) {
      emit(HomeViewState(showCondominumSelector: true, cards: favorites));
    });
    on<CollapseCondominiumSelectorHomeEvent>((event, emit) {
      emit(HomeViewState(showCondominumSelector: false, cards: favorites));
    });
    on<GetFavoritesCardsEvent>(_mapGetFavoriteCards);
    on<GetBannersEvent>(_mapGetBanners);
    on<HomeToGoEvent>(_mapHomeToGo);
    on<PostTermsEvent>(_mapPostTerms);
    on<ShowAgreementDialogEvent>(
        (event, emit) => emit(const ShowAgreementDialogState()));
    if (this.sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(this.sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  SharedPreferences? preferences;
  String sharedKey = "PREFERENCES_HOME_CARDS";
  String sharedKeyOnboarding = "PREFERENCES_HOME_CARDS_ONBOARDING";
  List<HomeItemEnum> favorites = [];
  bool isOwner = false;
  ValueNotifier<bool> animate = ValueNotifier<bool>(true);

  Future<void> _mapGetFavoriteCards(
    GetFavoritesCardsEvent event,
    Emitter<HomeState> emit,
  ) async {
    preferences = await SharedPreferences.getInstance();
    var getfavorites = preferences
        ?.getString("$sharedKey${sessionBloc.state.session?.me?.cpf}");
    var getOnboardingInfo = preferences?.getString(
        "$sharedKeyOnboarding${sessionBloc.state.session?.me?.cpf}");
    if (animate.value) {
      animate.value = checkShowOnboarding(getOnboardingInfo);
    }

    checkFavoritesCard(getfavorites);

    emit(HomeViewState(showCondominumSelector: false, cards: favorites));
  }

  Future<void> _mapGetBanners(
    GetBannersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const LoadingBannersState());

    final response = await getBanner.call(GetBannerParams(
        condominuimId: sessionBloc.state.session?.condominium?.id ?? ""));

    emit(response.fold((error) => const FailedBannersState(), (res) {
      return LoadedBannersState(
        banners: res,
      );
    }));
  }

  Future<void> _mapHomeToGo(
    HomeToGoEvent event,
    Emitter<HomeState> emit,
  ) async {
    bool acceptTerms = sessionBloc.state.session?.unity?.termHomeToGo ?? false;
    if (acceptTerms) {
      emit(const LoadingHomeToGoState());
      final response = await clubLello
          .call(HomeToGoParams(unitId: sessionBloc.state.session!.unity!.id!));

      emit(response.fold((error) => const FailedHomeToGoState(), (res) {
        return LoadedHomeToGoState(link: res);
      }));
    }
  }

  Future<void> _mapPostTerms(
    PostTermsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const LoadingHomeToGoState());

    //TODO:: SALVAR O ME/UNIT para salvar o termo do home to go

    final response = await postLello
        .call(PostTermsParams(unitId: sessionBloc.state.session!.unity!.id!));

    emit(response.fold((error) => const FailedHomeToGoState(), (res) {
      return LoadedHomeToGoState(link: res);
    }));
  }

  void showCondominiumSelector() {
    add(const ShowCondominiumSelectorHomeEvent());
  }

  void collapseCondominiumSelector() {
    add(const CollapseCondominiumSelectorHomeEvent());
  }

  void homeToGo() {
    add(const HomeToGoEvent());
  }

  void postTerms() {
    add(const PostTermsEvent());
  }

  void getCards() {
    add(const GetFavoritesCardsEvent());
  }

  selectedUnity(Unity unity) {
    sessionBloc.selectedUnity(unity);
  }

  Future registerFcmToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    String? fcmToken = await _fcm.getToken();
    var units = sessionBloc.state.session?.me?.allUnitIds;

    String? deviceId = await deviceIdentifierService.getDeviceIdentifier();
    RegisterFcmToken fcmTokenParams = RegisterFcmToken();
    fcmTokenParams.reference = units;
    fcmTokenParams.type = 'APPMORAR';
    fcmTokenParams.token = fcmToken;
    fcmTokenParams.deviceId = deviceId;
    debugPrint("FCM Token => $fcmToken");

    await registerFcm.call(RegisterFcmTokenParams(fcmToken: fcmTokenParams));
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      add(const GetBannersEvent());
    }
  }

  checkFavoritesCard(String? getfavorites) {
    //desabilita a personalização de cards
    if (sessionBloc.iSPreferencesPersonalizationActive == false) {
      return [];
    }
    if (getfavorites != null && getfavorites.isNotEmpty) {
      var decode = json.decode(getfavorites);
      if (decode['favorites'].isNotEmpty) {
        List<HomeItemEnum> favs = [];
        List.generate(decode['favorites'].length, (index) {
          HomeItemEnum.values.forEach((element) {
            if (element.text() == decode['favorites'][index]) {
              favs.add(element);
            }
          });
        });
        favorites = favs;
        animate.value = false;
      }
    }
  }

  bool checkShowOnboarding(String? onboarding) {
    if (onboarding != null && onboarding.isNotEmpty) {
      var decode = json.decode(onboarding);
      return decode['onboarding'] != true;
    } else {
      return true;
    }
  }

  Future<bool> checkExpiration() async {
    final unitId = sessionBloc.state.session?.unity?.id;
    final result = await subUserUseCase(
      GetSubUserParams(unityId: unitId ?? ''),
    );

    return result.fold(
      (error) => false,
      (res) async {
        if (res.isNotEmpty) {
          final me = res.firstWhere(
            (element) => element.id == sessionBloc.state.session?.me?.id,
          );

          final isOwner = me.role == 'morar.proprietario';
          this.isOwner = isOwner;

          if (isOwner) {
            return res.any((user) {
              final expirationDate = user.expiresAt;
              if (expirationDate != null) {
                final now = DateTime.now();
                final diff = expirationDate.difference(now);
                return diff.inDays <= 30 &&
                    user.accessRenewalRequestStatus == null;
              }
              return false;
            });
          } else {
            final expirationDate = me.expiresAt;

            if (expirationDate != null) {
              final now = DateTime.now();
              final diff = expirationDate.difference(now);
              if (diff.inDays <= 30 && me.accessRenewalRequestStatus == null) {
                return true;
              }
            }
          }
        }
        return false;
      },
    );
  }

  Future<bool> requestAccessRenewal() async {
    final unitId = sessionBloc.state.session?.unity?.id;
    final result = await sendAccessRenewRequestUseCase(unitId ?? '');

    return result.fold(
      (error) => false,
      (res) => true,
    );
  }

  void showAgreementDialog() {
    add(const ShowAgreementDialogEvent());
  }
}
