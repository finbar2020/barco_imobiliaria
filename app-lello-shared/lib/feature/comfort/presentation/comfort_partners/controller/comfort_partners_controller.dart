import 'dart:async';
import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_utils.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status.dart';
import 'package:shared_features/feature/comfort/domain/use_case/create_coupon_request/create_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/find_request_purchase/find_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partners/get_all_partners.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_coupons/get_partner_coupons.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_partner_is_favorite/get_partner_is_favorite.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnersController {
  final ComfortPartnersBloc comfortPartnersBloc;
  final ComfortPartnerCouponsBloc comfortPartnerCouponsBloc;
  final GetPartnerCouponsUseCase getPartnerCouponsUseCase;
  final GetAllPartnersUseCase getAllPartnersUseCase;
  final GetPartnerIsFavoriteUseCase getPartnerIsFavoriteUseCase;
  final ChangePartnerFavoriteStatusUseCase changePartnerFavoriteStatusUseCase;
  final CreateCouponRequestUseCase createCouponRequestUseCase;
  final FindRequestPurchaseUseCase findRequestPurchaseUseCase;
  final SendReviewRequestUseCase postRateRequestUseCase;
  final AppOriginEnum appOriginEnum;
  final GetToken getToken;
  final RequestPartnersUseCase? requestPartnersUseCase;
  AnalyticsTimer? comfortHomeAnalyticsTimer,
      comfortPartnerAnalyticsTimer,
      comfortCategoryAnalyticsTimer,
      comfortRedirectDialogAnalyticsTimer;
  AnalyticsTimer? comfortPartnerPageAnalyticsTimer;
  final sessionBloc;

  //StreamSubscription? _subscription;
  ComfortPartnerCategory? _currentCategory;

  List<ComfortPartner> allPartnersList;
  List<ComfortPartnerCoupon> coupons = [];
  List<ComfortPartnerCategory> categories;
  final bool comfortPartnerCategoryIsFilter = true;
  final bool comfortPartnersIsRandomic = false;

  ComfortPartner? selectedPartner;
  List<ComfortYourCondoRemoteConfig> categoriesToYourCondo = [];
  Map<String, bool> categoriesToYourCondoExpanded = {};
  LoadedComfortPartnersState? lastLoadedComfortPartnersState;

  ComfortPartnersController({
    required this.comfortPartnersBloc,
    required this.comfortPartnerCouponsBloc,
    required this.getPartnerCouponsUseCase,
    required this.getAllPartnersUseCase,
    required this.getPartnerIsFavoriteUseCase,
    required this.changePartnerFavoriteStatusUseCase,
    required this.createCouponRequestUseCase,
    required this.findRequestPurchaseUseCase,
    required this.postRateRequestUseCase,
    required this.sessionBloc,
    required this.appOriginEnum,
    required this.getToken,
    this.requestPartnersUseCase,
    this.allPartnersList = const [],
    this.categories = const [],
    this.selectedPartner,
  });

  Future<void> getPartnerCoupons() async {
    if (selectedPartner == null) {
      return comfortPartnerCouponsBloc.add(
        CouponsErrorEvent(
          errorMessageKey: "comfort_go_to_partner_page_error",
          errorDescription: "Nenhum parceiro selecionado",
        ),
      );
    } else {
      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      comfortPartnerCouponsBloc.add(
        LoadingCouponsEvent(
          partnerId: selectedPartner!.id,
          condominiumId: condominiumId,
        ),
      );
      final response = await getPartnerCouponsUseCase(
        GetPartnerCouponsParam(
          partnerId: selectedPartner!.id,
          condominiumId: condominiumId,
        ),
      );
      response.fold(
        (error) {
          return comfortPartnerCouponsBloc.add(
            CouponsErrorEvent(
              errorMessageKey: "comfort_get_partner_coupons_error",
              errorCode: error.code.toString(),
              errorDescription: "",
            ),
          );
        },
        (coupons) {
          this.coupons = coupons;
          return comfortPartnerCouponsBloc.add(
            LoadedCouponsEvent(coupons: coupons),
          );
        },
      );
    }
  }

  Future<void> getAllPartners(ComfortPageOriginEnum accessRouteOrigin) async {
    comfortPartnersBloc.add(
      LoadingComfortPartnersEvent(),
    );

    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await getAllPartnersUseCase(
      GetAllPartnersParam(condominiumId: condominiumId),
    );

    response.fold((error) {
      comfortPartnersBloc.add(
        ErrorComfortPartnersEvent(
            errorMessageKey: "comfort_error_message",
            errorCode: error.code.toString(),
            errorDescription: ""),
      );
    }, (response) {
      analyticsComfortAccessed(accessRouteOrigin);

      allPartnersList = response;

      response.sort(
        ((b, a) => b.partnerIntro.title.compareTo(a.partnerIntro.title)),
      );
      List<ComfortPartnerCategory> categoriesSorted =
          response.map((e) => e.category).toSet().toList();
      categories = categoriesSorted;
      categories.sort(
        ((b, a) => b.name.compareTo(a.name)),
      );

      if (categories.contains(ComfortPartnerCategory.toYourCondo)) {
        categories.remove(ComfortPartnerCategory.toYourCondo);
      }

      if (appOriginEnum == AppOriginEnum.manager) {
        categoriesToYourCondo = [...sessionBloc.getComfortToYourCondo()];

        if (categoriesToYourCondo.isNotEmpty) {
          categoriesToYourCondo.sort((a, b) {
            return a.title.toLowerCase().compareTo(b.title.toLowerCase());
          });

          // Remove categories that don't have partners
          categoriesToYourCondo.removeWhere((element) {
            return !allPartnersList.any((partner) {
              return enumToString(partner.partnerIntro.comfortType) ==
                      element.type &&
                  partner.category == ComfortPartnerCategory.toYourCondo;
            });
          });
          // Add to expanded list
          categoriesToYourCondo.forEach((element) {
            categoriesToYourCondoExpanded[element.type] = false;
          });
          if (allPartnersList.any((element) =>
              element.category == ComfortPartnerCategory.toYourCondo))
            categories.insert(0, ComfortPartnerCategory.toYourCondo);
        }
      }

      lastLoadedComfortPartnersState = LoadedComfortPartnersState(
        comfortPartnerCategoryIsFilter: comfortPartnerCategoryIsFilter,
        comfortPartnersIsRandomic: comfortPartnersIsRandomic,
        categoriesToYourCondo: categoriesToYourCondo,
      );

      comfortPartnersBloc.add(
        LoadedComfortPartnersEvent(
            comfortPartnerCategoryIsFilter: comfortPartnerCategoryIsFilter,
            comfortPartnersIsRandomic: comfortPartnersIsRandomic,
            categoriesToYourCondo: categoriesToYourCondo),
      );
    });
  }

  ComfortPartner? findPartner(String partnerId) {
    ComfortPartner? partner;
    allPartnersList.forEach((element) {
      if (element.id == partnerId) {
        partner = element;
      }
    });
    return partner;
  }

  Future<void> findRequestPurchase(String? requestId) async {
    if (requestId != null) {
      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      final response = await findRequestPurchaseUseCase(
        FindRequestPurchaseParam(
            condominiumId: condominiumId, requestId: requestId),
      );
      if (selectedPartner == null) {
        return comfortPartnersBloc.add(
          ErrorComfortPartnersEvent(
              errorMessageKey: "comfort_go_to_partner_page_error",
              errorCode: "",
              errorDescription: ""),
        );
      } else {
        response.fold(
          (error) {
            return comfortPartnersBloc.add(
              LoadedComfortPartnerDetailsEvent(
                selectedPartner: selectedPartner!,
              ),
            );
          },
          (response) {
            if (response.purchaseDone) {
              analyticsPurchased(selectedPartner);
            }

            return comfortPartnersBloc.add(
              LoadedComfortPartnerDetailsEvent(
                  selectedPartner: selectedPartner!, requestPurchase: response),
            );
          },
        );
      }
    }
  }

  Future<void> changePartnerFavoriteStatus(
      String partnerId, String partnerName, bool favorite) async {
    comfortPartnersBloc.add(
      LoadingComfortPartnersEvent(),
    );
    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await changePartnerFavoriteStatusUseCase(
      ChangePartnerFavoriteStatusParam(
          condominiumId: condominiumId,
          partnerId: partnerId,
          isFavorite: favorite),
    );
    if (selectedPartner == null) {
      return comfortPartnersBloc.add(
        ErrorComfortPartnersEvent(
            errorMessageKey: "comfort_go_to_partner_page_error",
            errorCode: "",
            errorDescription: ""),
      );
    } else {
      response.fold(
        (error) {
          return comfortPartnersBloc.add(
            LoadedComfortPartnerDetailsEvent(
                selectedPartner: selectedPartner!,
                error: "comfort_change_partner_favorite_status_error"),
          );
        },
        (response) {
          selectedPartner!.partnerIntro.favorite = response.isFavorite;
          int index = allPartnersList
              .indexWhere((element) => element.id == selectedPartner!.id);
          analyticsChangeFavorite(selectedPartner);
          allPartnersList[index].partnerIntro.favorite = response.isFavorite;

          return comfortPartnersBloc.add(
            LoadedComfortPartnerDetailsEvent(
                selectedPartner: allPartnersList[index]),
          );
        },
      );
    }
  }

  Future<void> disfavorPartner(ComfortPartner partner) async {
    comfortPartnersBloc.add(
      LoadingComfortPartnersEvent(),
    );

    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);

    final response = await changePartnerFavoriteStatusUseCase(
      ChangePartnerFavoriteStatusParam(
        condominiumId: condominiumId,
        partnerId: partner.id,
        isFavorite: false,
      ),
    );
    response.fold(
      (error) => comfortPartnersBloc.add(
        LoadedComfortPartnersEvent(
          flushbarMessage: "comfort_change_partner_favorite_status_error",
          comfortPartnerCategoryIsFilter: comfortPartnerCategoryIsFilter,
          comfortPartnersIsRandomic: comfortPartnersIsRandomic,
          categoriesToYourCondo: categoriesToYourCondo,
        ),
      ),
      (response) {
        partner.partnerIntro.favorite = response.isFavorite;
        int index =
            allPartnersList.indexWhere((element) => element.id == partner.id);
        allPartnersList[index].partnerIntro.favorite = response.isFavorite;

        analyticsChangeFavorite(selectedPartner);

        return comfortPartnersBloc.add(
          SuccessComfortPartnersEvent(selectedPartner: partner),
        );
      },
    );
  }

  Future<void> createCouponRequest(ComfortPartner partner,
      {ComfortPartnerCoupon? coupon}) async {
    comfortPartnersBloc.add(
      LoadingComfortPartnersEvent(),
    );
    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    String unitId = "";
    try {
      unitId = sessionBloc.state.session?.unity?.id ?? "";
    } catch (ex) {}
    final response =
        await createCouponRequestUseCase(CreateCouponRequestUseCaseParam(
      condominiumId: condominiumId,
      partnerId: partner.id,
      couponId: coupon?.id,
      unitId: unitId,
    ));

    response.fold(
        (error) => comfortPartnersBloc.add(
              LoadedComfortPartnerRequestErrorEvent(
                selectedPartner: partner,
                error: "comfort_get_coupon_request_error",
              ),
            ), (response) {
      analyticsEnableCoupon(partner);
      return comfortPartnersBloc.add(
        SuccessComfortPartnerCupomEvent(
          selectedPartner: partner,
          couponRequest: response,
        ),
      );
    });
  }

  Future<void> reviewRequest(
      {required String requestId,
      required double rate,
      String? comment}) async {
    comfortPartnersBloc.add(
      LoadingComfortPartnersEvent(),
    );

    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    ComfortReviewRequest review = ComfortReviewRequest(
        requestId: requestId, rating: rate, comment: comment);

    final response = await postRateRequestUseCase(
      SendReviewRequestParam(
        condominiumId: condominiumId,
        review: review,
      ),
    );
    response.fold(
        (error) => comfortPartnersBloc.add(
              ErrorComfortPartnersEvent(
                  errorMessageKey: "comfort_send_review_request_error",
                  errorCode: "",
                  errorDescription: ""),
            ), (response) {
      switch (appOriginEnum) {
        case AppOriginEnum.owner:
          AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsOwner.comodidadesAvaliar(),
            userId: sessionBloc.state.session?.me?.id ?? "",
            unitValue:
                sessionBloc.state.session!.unity?.title?.toString() ?? "",
            referenceValue:
                sessionBloc.state.session!.condominium?.reference?.toString() ??
                    "",
            appOrigin: appOriginEnum,
          );
          break;
        case AppOriginEnum.employee:
          AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsEmployee.comodidadesAvaliar(),
            referenceValue:
                sessionBloc.state.session!.condominium?.reference.toString() ??
                    "",
            appOrigin: appOriginEnum,
          );
          break;
        case AppOriginEnum.manager:
          AnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.comodidadesAvaliar(),
            referenceValue: sessionBloc
                    .state.session?.selectedCondominium?.reference
                    .toString() ??
                "",
            appOrigin: appOriginEnum,
          );
          break;
      }
      return comfortPartnersBloc.add(
        SuccessReviewSentEvent(),
      );
    });
  }

  List<ComfortPartner> partnersList({ComfortPartnerCategory? category}) {
    if (category == null) {
      return allPartnersList;
    } else {
      List<ComfortPartner> partners;
      partners = (allPartnersList)
          .where((element) => element.category == category)
          .toList();
      return partners;
    }
  }

  List<ComfortPartnerCoupon?> getTopCouponsList() {
    if (coupons.length == 0) {
      return [];
    }
    List<ComfortPartnerCoupon?> topCoupons = [];
    List<ComfortPartnerCoupon?> partnerCoupons = [];
    partnerCoupons = coupons.where((element) => element.highlight).toList();
    if (partnerCoupons.isNotEmpty) {
      topCoupons.addAll(partnerCoupons);
    }
    topCoupons
        .sort((a, b) => b!.discountPercentage.compareTo(a!.discountPercentage));
    return topCoupons;
  }

  Future<void> goToPartnerDetailsPage(
    ComfortPartner partnerSelectedPartner,
    ComfortPageOriginEnum accessOrigin, [
    bool? comfortPartnersIsRandomic,
    bool? comfortPartnerCategoryIsFilter,
  ]) async {
    selectedPartner = partnerSelectedPartner;
    analyticsPartnerAccessed(selectedPartner, accessOrigin);
    return comfortPartnersBloc.add(
      LoadedComfortPartnerDetailsEvent(
        selectedPartner: partnerSelectedPartner,
      ),
    );
  }

  Future<void> backToLoadedComfortPartnersState(
      ComfortPageOriginEnum accessRouteOrigin) async {
    if (allPartnersList.isEmpty) {
      getAllPartners(accessRouteOrigin);
    } else {
      return comfortPartnersBloc.add(
        LoadedComfortPartnersEvent(
          comfortPartnerCategoryIsFilter: comfortPartnerCategoryIsFilter,
          comfortPartnersIsRandomic: comfortPartnersIsRandomic,
          categoriesToYourCondo: categoriesToYourCondo,
          partnerFocus: selectedPartner,
        ),
      );
    }
  }

  LoadedComfortPartnersState getLastLoadedComfortPartnersState() {
    return lastLoadedComfortPartnersState!;
  }

  Future<void> requestPartners(RequestPartnersEntity request) async {
    if (requestPartnersUseCase == null) return;
    comfortPartnersBloc.add(
      LoadingComfortPartnersEvent(),
    );
    LoadedComfortPartnersState state = getLastLoadedComfortPartnersState();

    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await requestPartnersUseCase!(RequestPartnersUseCaseParam(
        condominiumId: condominiumId, request: request));
    response.fold(
        (l) => comfortPartnersBloc.add(
              LoadedComfortPartnersEvent(
                comfortPartnerCategoryIsFilter:
                    state.comfortPartnerCategoryIsFilter,
                comfortPartnersIsRandomic: state.comfortPartnersIsRandomic,
                categoriesToYourCondo: state.categoriesToYourCondo,
                isFailedCondoPartners: true,
              ),
            ), (r) {
      comfortPartnersBloc.add(
        LoadedComfortPartnersEvent(
          comfortPartnerCategoryIsFilter: state.comfortPartnerCategoryIsFilter,
          comfortPartnersIsRandomic: state.comfortPartnersIsRandomic,
          categoriesToYourCondo: state.categoriesToYourCondo,
          isSuccessYourCondoPartners: true,
        ),
      );
    });
  }

  void changeCategory(ComfortPartnerCategory? category) {
    _currentCategory = category;
  }

  // Getters
  List<ComfortPartnerCategory> getPartnersList() {
    return this.categories;
  }

  String get getCondoReference {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return sessionBloc.state.session?.condominium?.reference ?? "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.reference ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.reference ?? "";
    }
  }

  String get getUnityId {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.unity?.title ?? "";
      case AppOriginEnum.manager:
        return "";
    }
  }

  //TODO: Refactor this to a better place
  Future<AccessToken?> get _getAccessToken async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  ComfortPartnerCategory? get currentCategory {
    return _currentCategory;
  }

  String get getCondoName {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.name ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.name ?? "";
    }
  }

  String get getCondoAddress {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.address ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.address ?? "";
    }
  }

  String get getUserName {
    return sessionBloc.state.session?.me?.name ?? "";
  }

  String get getUserEmail {
    return sessionBloc.state.session?.me?.email ?? "";
  }

  // Analytics Events Getters
  AnalyticsEvent get _getAnalyticsEventPartnerBack {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesParceiroVoltar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesParceiroVoltar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesParceiroVoltar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventCategoryBack {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCategoriaVoltar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCategoriaVoltar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCategoriaVoltar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventComfortBack {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesVoltar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesVoltar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesVoltar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventCtaOptIn {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCtaOptIn();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCtaOptIn();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCtaOptIn();
    }
  }

  AnalyticsEvent get _getAnalyticsEventCtaRedirectButton {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCtaRedirecionamento();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCtaRedirecionamento();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCtaRedirecionamento();
    }
  }

  AnalyticsEvent get _getAnalyticsEventDismissCtaCard {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCtaCardFechar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCtaCardFechar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCtaCardFechar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventAccessComfortLgpd {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesLgpdAcessar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesLgpdAcessar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesLgpdAcessar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventAccessComfortCta {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCtaAcessar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCtaAcessar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCtaAcessar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventForPurchase {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCompraRealizada();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCompraRealizada();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCompraRealizada();
    }
  }

  AnalyticsEvent get _getAnalyticsEventChangeFavorite {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesMudarFavorito();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesMudarFavorito();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesMudarFavorito();
    }
  }

  AnalyticsEvent get _getAnalyticsEventCupomAtivar {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCupomAtivar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCupomAtivar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCupomAtivar();
    }
  }

  AnalyticsEvent get _getAnalyticsEventComodidadesAcessar {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesAcessar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesAcessar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesAcessar();
    }
  }

  AnalyticsEvent get _getAccessSubcategoriesAnalyticsEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesSubCategoriaAcessar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesSubCategoriaAcessar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesSubCategoriaAcessar();
    }
  }

  AnalyticsEvent get _getAccessPartnerAnalyticsEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesParceiroAcessar();
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesParceiroAcessar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesParceiroAcessar();
    }
  }

  AnalyticsEvent get _getComfortRedirectDialogAnalyticsTimerEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee
            .comodidadesModalRedirecionamentoTemporizador();
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner
            .comodidadesModalRedirecionamentoTemporizador();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager
            .comodidadesModalRedirecionamentoTemporizador();
    }
  }

  AnalyticsEvent get _getComfortCardAnalyticsTimerEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCardComodidadeTemporizador();
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCardComodidadeTemporizador();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCardComodidadeTemporizador();
    }
  }

  AnalyticsEvent get _getComfortPartnerPageAnalyticsTimerEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesPaginaParceiroTemporizador();
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesPaginaParceiroTemporizador();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesPaginaParceiroTemporizador();
    }
  }

  AnalyticsEvent get _getComfortCategoryAnalyticsTimerEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesCategoriaTemporizador();
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesCategoriaTemporizador();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesCategoriaTemporizador();
    }
  }

  AnalyticsEvent get _getComfortHomeAnalyticsTimerEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.comodidadesHomeTemporizador();
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.comodidadesHomeTemporizador();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.comodidadesHomeTemporizador();
    }
  }

  // Analytics Click Events
  void analyticsPartnerPageBack() async {
    AnalyticsLogEvents.logEvent(
      event: _getAnalyticsEventPartnerBack,
      userId: sessionBloc.state.session?.me?.id ?? "",
      userType: await getUserType,
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      otherParameters: {
        "id_parceiro": selectedPartner!.notificationParameter,
        "id_partner": selectedPartner!.notificationParameter,
        "nome_parceiro": selectedPartner!.partnerIntro.title,
        "category": selectedPartner!.category.name,
      },
    );
  }

  void analyticsComfortCategoryPageBack(ComfortPartnerCategory category) async {
    AnalyticsLogEvents.logEvent(
        event: _getAnalyticsEventCategoryBack,
        userId: sessionBloc.state.session?.me?.id ?? "",
        userType: await getUserType,
        unitValue: getUnityId,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "category": enumToString(category) ?? "",
        });
  }

  void analyticsComfortPageBack() async {
    AnalyticsLogEvents.logEvent(
      event: _getAnalyticsEventComfortBack,
      userType: await getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
    );
  }

  void analyticsCtaOptIn(
      ComfortPartner partner, ComfortPartnerCoupon? coupon) async {
    AnalyticsLogEvents.logEvent(
        event: _getAnalyticsEventCtaOptIn,
        userType: await getUserType,
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: getUnityId,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "id_partner": partner.notificationParameter,
          "id_parceiro": partner.notificationParameter,
          "nome_parceiro": partner.partnerIntro.title,
          "id_cupom": coupon?.notificationParameter ?? "",
          "nome_cupom": coupon?.title ?? "",
          "tipo_cta": enumToString(partner.cta)!,
          "category": partner.category.name,
        });
  }

  void analyticsCtaRedirectButton(
      ComfortPartner partner, ComfortPartnerCoupon? coupon) async {
    AnalyticsLogEvents.logEvent(
        event: _getAnalyticsEventCtaRedirectButton,
        userType: await getUserType,
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: getUnityId,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "id_partner": partner.notificationParameter,
          "id_parceiro": partner.notificationParameter,
          "nome_parceiro": partner.partnerIntro.title,
          "id_cupom": coupon?.notificationParameter ?? "",
          "nome_cupom": coupon?.title ?? "",
          "tipo_cta": enumToString(partner.cta)!,
          "category": partner.category.name,
        });
  }

  void analyticsCtaCardDismissed(
      ComfortPartner partner, ComfortPartnerCoupon? coupon) async {
    AnalyticsLogEvents.logEvent(
        event: _getAnalyticsEventDismissCtaCard,
        userType: await getUserType,
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: getUnityId,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "id_partner": partner.notificationParameter,
          "id_parceiro": partner.notificationParameter,
          "nome_parceiro": partner.partnerIntro.title,
          "id_cupom": coupon?.notificationParameter ?? "",
          "nome_cupom": coupon?.title ?? "",
          "tipo_cta": enumToString(partner.cta)!,
          "category": partner.category.name,
        });
  }

  void analyticsLgpdAcessar(
      ComfortPartner partner, ComfortPartnerCoupon? coupon) async {
    AnalyticsLogEvents.logEvent(
        event: _getAnalyticsEventAccessComfortLgpd,
        userType: await getUserType,
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: getUnityId,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "id_partner": partner.notificationParameter,
          "id_parceiro": partner.notificationParameter,
          "nome_parceiro": partner.partnerIntro.title,
          "id_cupom": coupon?.notificationParameter ?? "",
          "nome_cupom": coupon?.title ?? "",
          "tipo_cta": enumToString(partner.cta)!,
          "category": partner.category.name,
        });
  }

  void analyticsClickCta(
      ComfortPartner partner, ComfortPartnerCoupon? coupon) async {
    AnalyticsLogEvents.logEvent(
        event: _getAnalyticsEventAccessComfortCta,
        userType: await getUserType,
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: getUnityId,
        referenceValue: getCondoReference,
        appOrigin: appOriginEnum,
        otherParameters: {
          "id_partner": partner.notificationParameter,
          "id_parceiro": partner.notificationParameter,
          "nome_parceiro": partner.partnerIntro.title,
          "id_cupom": coupon?.notificationParameter ?? "",
          "nome_cupom": coupon?.title ?? "",
          "tipo_cta": enumToString(partner.cta)!,
          "category": partner.category.name,
        });
  }

  void analyticsPurchased(ComfortPartner? partner) {
    AnalyticsLogEvents.logEvent(
      event: _getAnalyticsEventForPurchase,
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      otherParameters: {
        "id_parceiro": partner?.notificationParameter ?? "",
        "id_partner": partner?.notificationParameter ?? "",
        "nome_parceiro": partner?.partnerIntro.title ?? "",
        "nome_usuario": getUserName,
        "email": getUserEmail,
        "nome_condominio": getCondoName,
        "endereco_condominio": getCondoAddress,
      },
    );
  }

  void analyticsChangeFavorite(ComfortPartner? partner) async {
    AnalyticsLogEvents.logEvent(
      event: _getAnalyticsEventChangeFavorite,
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      otherParameters: {
        "id_parceiro": partner?.notificationParameter ?? "",
        "id_partner": partner?.notificationParameter ?? "",
        "nome_parceiro": partner?.partnerIntro.title ?? "",
      },
    );
  }

  void analyticsEnableCoupon(ComfortPartner partner) async {
    AnalyticsLogEvents.logEvent(
      event: _getAnalyticsEventCupomAtivar,
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      otherParameters: {
        "id_parceiro": partner.notificationParameter,
        "id_partner": partner.notificationParameter,
        "nome_parceiro": partner.partnerIntro.title,
        "nome_usuario": getUserName,
        "email": getUserEmail,
        "nome_condominio": getCondoName,
        "endereco_condominio": getCondoAddress,
      },
    );
  }

  void analyticsPartnerAccessed(
      ComfortPartner? partner, ComfortPageOriginEnum accessOrigin) async {
    AnalyticsLogEvents.logEvent(
      event: _getAccessPartnerAnalyticsEvent,
      userId: sessionBloc.state.session?.me?.id ?? "",
      userType: await getUserType,
      referenceValue: getCondoReference,
      unitValue: getUnityId,
      appOrigin: appOriginEnum,
      otherParameters: {
        "id_parceiro": partner?.notificationParameter ?? "",
        "id_partner": partner?.notificationParameter ?? "",
        "nome_parceiro": partner?.partnerIntro.title ?? "",
        "nome_usuario": getUserName,
        "email": getUserEmail,
        "nome_condominio": getCondoName,
        "endereco_condominio": getCondoAddress,
        "category": enumToString(partner?.category) ?? "",
        "origem_acesso": enumToString(accessOrigin) ?? "",
      },
    );
  }

  void analyticsComfortAccessed(ComfortPageOriginEnum accessRouteOrigin) async {
    AnalyticsLogEvents.logEvent(
      event: _getAnalyticsEventComodidadesAcessar,
      userId: sessionBloc.state.session?.me?.id ?? "",
      userType: await getUserType,
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      otherParameters: {
        "origem_acesso": enumToString(accessRouteOrigin) ?? "",
      },
    );
  }

  void analyticsSubcategorieAccessed(
      {required String subcategories,
      required ComfortPartnerCategory category}) async {
    AnalyticsLogEvents.logEvent(
      event: _getAccessSubcategoriesAnalyticsEvent,
      userId: sessionBloc.state.session?.me?.id ?? "",
      userType: await getUserType,
      unitValue: getUnityId,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      otherParameters: {
        "sub_categorias": subcategories,
        "nome_usuario": getUserName,
        "email": getUserEmail,
        "nome_condominio": getCondoName,
        "endereco_condominio": getCondoAddress,
        "category": enumToString(category) ?? "",
      },
    );
  }

  void analyticsRequestButton() async {
    AnalyticsLogEvents.logEvent(
      event: AnalyticsEventsManager.comodidadesMinhasSolicitacoesAcessar(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      userType: await getUserType,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
    );
  }

  // Analytics Timer Events

  void comfortRedirectDialogAnalyticsTimerStart(
      {required String debugEventIdentifier}) async {
    comfortRedirectDialogAnalyticsTimer = AnalyticsTimer(
      userType: await getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: _getComfortRedirectDialogAnalyticsTimerEvent,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      unitValue: getUnityId,
      otherParameters: {
        "id_partner": selectedPartner?.notificationParameter ?? "",
        "id_parceiro": selectedPartner?.notificationParameter ?? "",
        "nome_parceiro": selectedPartner?.partnerIntro.title ?? "",
        "category": enumToString(selectedPartner?.category) ?? "",
        "debug_event_id": debugEventIdentifier,
      },
    );
  }

  void comfortRedirectDialogAnalyticsStopTimer() {
    comfortRedirectDialogAnalyticsTimer?.stopTimer();
    comfortRedirectDialogAnalyticsTimer = null;
  }

  void comfortCardAnalyticsTimerStart(
      {required String debugEventIdentifier}) async {
    comfortPartnerAnalyticsTimer = AnalyticsTimer(
      userType: await getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: _getComfortCardAnalyticsTimerEvent,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      unitValue: getUnityId,
      otherParameters: {
        "id_partner": selectedPartner?.notificationParameter ?? "",
        "id_parceiro": selectedPartner?.notificationParameter ?? "",
        "nome_parceiro": selectedPartner?.partnerIntro.title ?? "",
        "category": enumToString(selectedPartner?.category) ?? "",
        "debug_event_id": debugEventIdentifier,
      },
    );
  }

  void comfortCardAnalyticsStopTimer() {
    comfortPartnerAnalyticsTimer?.stopTimer();
    comfortPartnerAnalyticsTimer = null;
  }

  void comfortPartnerPageAnalyticsTimerStart(
      {required String debugEventIdentifier}) async {
    comfortPartnerPageAnalyticsTimer = AnalyticsTimer(
      userType: await getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: _getComfortPartnerPageAnalyticsTimerEvent,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      unitValue: getUnityId,
      otherParameters: {
        "id_partner": selectedPartner?.notificationParameter ?? "",
        "id_parceiro": selectedPartner?.notificationParameter ?? "",
        "nome_parceiro": selectedPartner?.partnerIntro.title ?? "",
        "category": enumToString(selectedPartner?.category) ?? "",
        "debug_event_id": debugEventIdentifier,
      },
    );
  }

  void comfortPartnerPageAnalyticsStopTimer() {
    comfortPartnerPageAnalyticsTimer?.stopTimer();
    comfortPartnerPageAnalyticsTimer = null;
  }

  void comfortCategoryAnalyticsTimerStart(ComfortPartnerCategory category,
      {required String debugEventIdentifier}) async {
    comfortPartnerAnalyticsTimer = AnalyticsTimer(
      userType: await getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: _getComfortCategoryAnalyticsTimerEvent,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      unitValue: getUnityId,
      otherParameters: {
        "category": category.name,
        "debug_event_id": debugEventIdentifier,
      },
    );
  }

  void comfortCategoryAnalyticsStopTimer() {
    comfortPartnerAnalyticsTimer?.stopTimer();
    comfortPartnerAnalyticsTimer = null;
  }

  void comfortHomeAnalyticsTimerStart(
      {required String debugEventIdentifier}) async {
    comfortHomeAnalyticsTimer = AnalyticsTimer(
      userType: await getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: _getComfortHomeAnalyticsTimerEvent,
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
      unitValue: getUnityId,
      otherParameters: {
        "debug_event_id": debugEventIdentifier,
      },
    );
  }

  void comfortHomeAnalyticsStopTimer() {
    comfortHomeAnalyticsTimer?.stopTimer();
    comfortHomeAnalyticsTimer = null;
  }

  getSessionBloc() {
    return sessionBloc;
  }
}
