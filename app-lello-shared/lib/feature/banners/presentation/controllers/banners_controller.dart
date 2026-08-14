import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/banners/domain/use_case/get_banners/get_banners.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_bloc.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_event.dart';

class BannersController {
  final AppOriginEnum appOriginEnum;
  final BannersBloc bloc;
  final GetBannersUseCase getBannersUseCase;
  final sessionBloc;
  final bool Function(DateTime? lastUpdateAt) expireCache;
  BannersController({
    required this.bloc,
    required this.getBannersUseCase,
    required this.sessionBloc,
    required this.expireCache,
    required this.appOriginEnum,
  });

  String getCondoIdByProject(AppOriginEnum appOriginEnum, dynamic sessionBloc) {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return sessionBloc.state.session?.condominium?.id ?? "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.id ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.id ?? "";
    }
  }

  Future<void> getBanners() async {
    bloc.add(BannersLoadingEvent());

    String condominiumId = getCondoIdByProject(appOriginEnum, sessionBloc);

    //Get Banners from cache
    final responseFromCache = await getBannersUseCase.call(GetBannersParam(
        condominiumId: condominiumId, origin: DataOrigin.local));

    bool loadedFromCache = false;

    responseFromCache.fold((error) => bloc.add(BannersErrorEvent()),
        (response) {
      if (response.isNotEmpty &&
          expireCache(response.first.lastUpdateAt) == false) {
        loadedFromCache = true;
        bloc.add(BannersLoadedEvent(banners: response));
      } else {
        bloc.add(BannersLoadingEvent());
      }
    });

    if (!loadedFromCache) {
      //Get Banners from API
      final response = await getBannersUseCase.call(GetBannersParam(
          condominiumId: condominiumId, origin: DataOrigin.remote));

      response.fold((error) => bloc.add(BannersErrorEvent()), (response) {
        bloc.add(BannersLoadedEvent(banners: response));
      });
    }
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

  String get getUnitName {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.unity?.title?.toString() ?? "";
      case AppOriginEnum.manager:
        return "";
    }
  }

  AnalyticsEvent get getAnalyticsEvent {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return AnalyticsEventsEmployee.bannerDinamicoAcessar();
      case AppOriginEnum.owner:
        return AnalyticsEventsOwner.bannerDinamicoAcessar();
      case AppOriginEnum.manager:
        return AnalyticsEventsManager.bannerDinamicoAcessar();
    }
  }
}
