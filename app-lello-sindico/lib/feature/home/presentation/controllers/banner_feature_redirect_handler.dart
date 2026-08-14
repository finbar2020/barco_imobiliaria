import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/shared_features.dart';

class BannerFeatureRedirectHandler {
  static void redirect({
    required BuildContext context,
    required SessionBloc sessionBloc,
    required BannerEntity banner,
  }) {
    final feature = banner.feature;

    if (feature == BannerFeatureEnum.lelloMorarComfortPartner) {
      _openComfort(
        context: context,
        sessionBloc: sessionBloc,
        partnerId: banner.arg?.partnerId,
      );
      return;
    }

    final result = _mapFeatureToRoute(feature, sessionBloc);
    if (result != null) {
      Navigator.pushNamed(context, result.route, arguments: result.arguments);
    }
  }

  static _RouteResult? _mapFeatureToRoute(
    BannerFeatureEnum feature,
    SessionBloc sessionBloc,
  ) {
    switch (feature) {
      case BannerFeatureEnum.acordos:
      case BannerFeatureEnum.acordosRealizados:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoAcordos)) {
          return _RouteResult(ApplicationRoute.agreements);
        }
        return null;

      case BannerFeatureEnum.boletos:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoSegundavia)) {
          return _RouteResult(ApplicationRoute.billets);
        }
        return null;

      case BannerFeatureEnum.ocorrencias:
      case BannerFeatureEnum.minhasOcorrencias:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoOcorrencias)) {
          return _RouteResult(ApplicationRoute.reportsBook);
        }
        return null;

      case BannerFeatureEnum.prestacaoContas:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoPpc)) {
          return _RouteResult(ApplicationRoute.accountability);
        }
        return null;

      case BannerFeatureEnum.reservaAreaAgendamentos:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoReservas)) {
          return _RouteResult(ApplicationRoute.space);
        }
        return null;

      case BannerFeatureEnum.despesasAprovacoesPendentes:
      case BannerFeatureEnum.despesasConsultarPagamentos:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoDespesas)) {
          return _RouteResult(ApplicationRoute.payment);
        }
        return null;

      case BannerFeatureEnum.documentosAdvertencias:
      case BannerFeatureEnum.documentosMultas:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoVoxAdvertencias)) {
          return _RouteResult(ApplicationRoute.warningsAndFines);
        }
        return null;

      case BannerFeatureEnum.documentosAtas:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoDocumentos) &&
            sessionBloc.checkRback(ApplicationRbac.sindicoDocumentosAtas)) {
          return _RouteResult(ApplicationRoute.documentsMinutes);
        }
        return null;

      case BannerFeatureEnum.documentosCirculares:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoDocumentos) &&
            sessionBloc
                .checkRback(ApplicationRbac.sindicoDocumentosCirculares)) {
          return _RouteResult(ApplicationRoute.documentsCirculars);
        }
        return null;

      case BannerFeatureEnum.documentosEditais:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoDocumentos) &&
            sessionBloc.checkRback(ApplicationRbac.sindicoDocumentosEditais)) {
          return _RouteResult(ApplicationRoute.documentsNotices);
        }
        return null;

      case BannerFeatureEnum.moradoresSubmoradores:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoUnidades)) {
          return _RouteResult(ApplicationRoute.units);
        }
        return null;

      case BannerFeatureEnum.minhaConta:
        return _RouteResult(ApplicationRoute.me);

      case BannerFeatureEnum.assembleia:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoVoxComunicados)) {
          return _RouteResult(ApplicationRoute.announcementsMenu);
        }
        return null;

      case BannerFeatureEnum.seguros:
      case BannerFeatureEnum.lelloMorarInsurance:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoComodidades)) {
          return _RouteResult(SharedApplicationRoute.comfort);
        }
        return null;

      case BannerFeatureEnum.gestaoTecnica:
        if (sessionBloc.checkRback(ApplicationRbac.sindicoGestaoDeManutencao)) {
          return _RouteResult(ApplicationRoute.maintenanceManagement);
        }
        return null;

      case BannerFeatureEnum.lelloMorarTDB:
      case BannerFeatureEnum.lelloMorarComfortPartner:
      case BannerFeatureEnum.autorizacaoEntrada:
      case BannerFeatureEnum.correspondencias:
      case BannerFeatureEnum.espelhoPonto:
      case BannerFeatureEnum.bella:
      case BannerFeatureEnum.others:
        return null;
    }
  }

  static void _openComfort({
    required BuildContext context,
    required SessionBloc sessionBloc,
    String? partnerId,
  }) {
    if (!sessionBloc.checkRback(ApplicationRbac.sindicoComodidades)) {
      return;
    }

    Navigator.pushNamed(
      context,
      SharedApplicationRoute.comfort,
      arguments: ComfortPageArgs(
        partnerId: partnerId,
        appOriginEnum: AppOriginEnum.manager,
        reference:
            sessionBloc.state.session?.selectedCondominium?.reference ?? '',
        unit: '',
        accessRouteOrigin: ComfortPageOriginEnum.banner,
      ),
    );
  }
}

class _RouteResult {
  final String route;
  final Object? arguments = null;

  _RouteResult(this.route);
}
