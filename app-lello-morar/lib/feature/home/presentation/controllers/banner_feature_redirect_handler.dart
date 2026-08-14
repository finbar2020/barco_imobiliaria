import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/presentation/controllers/home_navigation_redirect_resolver.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class BannerFeatureRedirectHandler {
  static void redirect({
    required BuildContext context,
    required SessionBloc sessionBloc,
    required BannerEntity banner,
    required bool isGeneric,
    VoidCallback? onNavigateToComodities,
  }) {
    final feature = banner.feature;

    if (_isComfortPartnerFeature(feature)) {
      _openComfort(
        context: context,
        sessionBloc: sessionBloc,
        partnerId: banner.arg?.partnerId,
        onNavigateToComodities: onNavigateToComodities,
      );
      return;
    }

    final mappedFeatureRoute = _mapFeatureToNotificationRoute(feature);

    if (mappedFeatureRoute == null) {
      return;
    }

    final redirectResolver = HomeNavigationRedirectResolver(
      sessionBloc: sessionBloc,
      isGeneric: isGeneric,
    );

    final result = redirectResolver.resolve(
      SharedApplicationRedirectRoute(
        rote: enumToString(mappedFeatureRoute) ?? '',
        context: sessionBloc.state.session?.unity?.notificationContext,
        notificationId: '',
      ),
    );

    switch (result.action) {
      case HomeRedirectAction.navigateRoute:
        if (result.route != null) {
          Navigator.pushNamed(
            context,
            result.route!,
            arguments: result.arguments,
          );
        }
        break;
      case HomeRedirectAction.openComoditiesTab:
        _openComfort(
          context: context,
          sessionBloc: sessionBloc,
          onNavigateToComodities: onNavigateToComodities,
        );
        break;
      case HomeRedirectAction.openNotifications:
        break;
      case HomeRedirectAction.none:
        break;
    }
  }

  static bool _isComfortPartnerFeature(BannerFeatureEnum feature) {
    switch (feature) {
      case BannerFeatureEnum.lelloMorarComfortPartner:
        return true;
      default:
        return false;
    }
  }

  static FeaturesRoutesEnum? _mapFeatureToNotificationRoute(
    BannerFeatureEnum feature,
  ) {
    switch (feature) {
      case BannerFeatureEnum.lelloMorarInsurance:
      case BannerFeatureEnum.seguros:
        return FeaturesRoutesEnum.SEGUROS;

      case BannerFeatureEnum.acordos:
      case BannerFeatureEnum.acordosRealizados:
        return FeaturesRoutesEnum.ACORDO_PROPOSTA;

      case BannerFeatureEnum.assembleia:
        return FeaturesRoutesEnum.ASSEMBLEIA;

      case BannerFeatureEnum.autorizacaoEntrada:
        return FeaturesRoutesEnum.ENTRADA_LIBERACAO;

      case BannerFeatureEnum.boletos:
        return FeaturesRoutesEnum.BOLETOS;

      case BannerFeatureEnum.correspondencias:
        return FeaturesRoutesEnum.CORRESPONDENCIAS_ENTRADA;

      case BannerFeatureEnum.documentosAdvertencias:
        return FeaturesRoutesEnum.DOCUMENTOS_ADVERTENCIAS;

      case BannerFeatureEnum.documentosAtas:
        return FeaturesRoutesEnum.DOCUMENTOS_ATAS;

      case BannerFeatureEnum.documentosCirculares:
        return FeaturesRoutesEnum.DOCUMENTOS_CIRCULARES;

      case BannerFeatureEnum.documentosEditais:
        return FeaturesRoutesEnum.DOCUMENTOS_EDITAIS;

      case BannerFeatureEnum.documentosMultas:
        return FeaturesRoutesEnum.DOCUMENTOS_MULTAS;

      case BannerFeatureEnum.minhasOcorrencias:
      case BannerFeatureEnum.ocorrencias:
        return FeaturesRoutesEnum.OCORRENCIA_NOVA;

      case BannerFeatureEnum.moradoresSubmoradores:
        return FeaturesRoutesEnum.MORADORES_ACESSOU;

      case BannerFeatureEnum.prestacaoContas:
        return FeaturesRoutesEnum.PPC_DISPONIVEL;

      case BannerFeatureEnum.reservaAreaAgendamentos:
        return FeaturesRoutesEnum.RESERVA_AREA;

      case BannerFeatureEnum.minhaConta:
        return FeaturesRoutesEnum.MINHA_CONTA;

      case BannerFeatureEnum.bella:
        return FeaturesRoutesEnum.BELLA;

      case BannerFeatureEnum.gestaoTecnica:
      case BannerFeatureEnum.lelloMorarTDB:
      case BannerFeatureEnum.lelloMorarComfortPartner:
      case BannerFeatureEnum.despesasAprovacoesPendentes:
      case BannerFeatureEnum.despesasConsultarPagamentos:
      case BannerFeatureEnum.espelhoPonto:
      case BannerFeatureEnum.others:
        return null;
    }
  }

  static void _openComfort({
    required BuildContext context,
    required SessionBloc sessionBloc,
    String? partnerId,
    VoidCallback? onNavigateToComodities,
  }) {
    final normalizedPartnerId = partnerId?.trim();

    if (!sessionBloc.checkRback(ApplicationRbac.morarComodidades)) {
      return;
    }

    if (onNavigateToComodities != null &&
        (normalizedPartnerId == null || normalizedPartnerId.isEmpty)) {
      onNavigateToComodities();
      return;
    }

    Navigator.pushNamed(
      context,
      ApplicationRoute.comfort,
      arguments: ComfortPageArgs(
        partnerId: normalizedPartnerId,
        appOriginEnum: AppOriginEnum.owner,
        reference: sessionBloc.state.session?.condominium?.reference ?? '',
        accessRouteOrigin: ComfortPageOriginEnum.banner,
        unit: sessionBloc.state.session?.unity?.title ?? '',
      ),
    );
  }
}
