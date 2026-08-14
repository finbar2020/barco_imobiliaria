// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_rbac.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/gdp/presentation/page/gdp_main_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/analytics/analytics_log_events.dart';
import '../../../../core/navigation/application_route.dart';
import '../../../session/presentation/bloc/session_state.dart';

enum HomeItemEnum {
  digitalPoint,
  myDocuments,
  teamManagement,
  registerDigitalPoint,
  timeSheet,
  proof,
  sickNote,
  sendTimeSheet,
  incomeReport,
  payStub,
  vacation,
  exams,
  benefits,
  discounts,
  indicateReceiveBenefits,
  condolivre,
  courses,
  employeeReferral
}

CircuitBreakerController circuitBreakController =
    ApplicationContainer.instance().resolve();

extension HomeItemExtension on HomeItemEnum {
  String get titleKey {
    switch (this) {
      case HomeItemEnum.digitalPoint:
        return "home_page_digital_point";
      case HomeItemEnum.myDocuments:
        return "home_page_my_documents";
      case HomeItemEnum.teamManagement:
        return "home_page_team_management";
      case HomeItemEnum.registerDigitalPoint:
        return "digital_point_page_register_digital_point";
      case HomeItemEnum.timeSheet:
        return "digital_point_page_time_sheet";
      case HomeItemEnum.proof:
        return "digital_point_page_proof";
      case HomeItemEnum.sickNote:
        return "digital_point_page_sick_note";
      case HomeItemEnum.sendTimeSheet:
        return "home_page_send_time_sheet";
      case HomeItemEnum.incomeReport:
        return "documents_page_income_report";
      case HomeItemEnum.payStub:
        return "documents_page_pay_stub";
      case HomeItemEnum.vacation:
        return "documents_page_vacation";
      case HomeItemEnum.exams:
        return "documents_page_exams";
      case HomeItemEnum.benefits:
        return "documents_page_benefits";
      case HomeItemEnum.discounts:
        return "benefits_page_discounts";
      case HomeItemEnum.indicateReceiveBenefits:
        return "benefits_page_indicate_receive_benefits";
      case HomeItemEnum.condolivre:
        return "benefits_page_condolivre";
      case HomeItemEnum.courses:
        return "benefits_page_courses";
      case HomeItemEnum.employeeReferral:
        return "benefits_page_employee_referral";
    }
  }

  String get icon {
    switch (this) {
      case HomeItemEnum.digitalPoint:
        return "assets/ic_digital_point.svg";
      case HomeItemEnum.myDocuments:
        return "assets/ic_my_documents.svg";
      case HomeItemEnum.teamManagement:
        return "assets/ic_team_management.svg";
      case HomeItemEnum.registerDigitalPoint:
        return "assets/ic_digital_point.svg";
      case HomeItemEnum.timeSheet:
        return "assets/time_sheet.svg";
      case HomeItemEnum.proof:
        return "assets/ic_proof.svg";
      case HomeItemEnum.sickNote:
        return "assets/ic_sick_note.svg";
      case HomeItemEnum.sendTimeSheet:
        return "assets/ic_send_declaration.svg";
      case HomeItemEnum.incomeReport:
        return "assets/ic_income_report.svg";
      case HomeItemEnum.payStub:
        return "assets/ic_pay_stub.svg";
      case HomeItemEnum.vacation:
        return "assets/ic_vacation.svg";
      case HomeItemEnum.exams:
        return "assets/ic_exams.svg";
      case HomeItemEnum.benefits:
        return "assets/ic_benefits.svg";
      case HomeItemEnum.discounts:
        return "assets/ic_discounts.svg";
      case HomeItemEnum.indicateReceiveBenefits:
        return "assets/ic_indicate_receive_benefits.svg";
      case HomeItemEnum.condolivre:
        return "assets/ic_condolivre.svg";
      case HomeItemEnum.courses:
        return "assets/ic_courses.svg";
      case HomeItemEnum.employeeReferral:
        return "assets/ic_employee_referral.svg";
    }
  }

  String get getCircuitBreakRbacString {
    switch (this) {
      case HomeItemEnum.digitalPoint:
        return ApplicationRbacEnum.colaboradorPontodigital.toFormattedString();
      case HomeItemEnum.myDocuments:
        return ApplicationRbacEnum.colaboradorDocumentos.toFormattedString();
      case HomeItemEnum.teamManagement:
        return ApplicationRbacEnum.colaboradorGestaoEquipe.toFormattedString();
      case HomeItemEnum.registerDigitalPoint:
        return ApplicationRbacEnum.colaboradorPontodigitalMarcarPonto
            .toFormattedString();
      case HomeItemEnum.timeSheet:
        return ApplicationRbacEnum.colaboradorPontodigitalEspelhoPonto
            .toFormattedString();
      case HomeItemEnum.proof:
        return ApplicationRbacEnum.colaboradorPontodigitalComprovante
            .toFormattedString();
      case HomeItemEnum.sickNote:
        return ApplicationRbacEnum.colaboradorPontodigitalAtestado
            .toFormattedString();
      case HomeItemEnum.sendTimeSheet:
        return ApplicationRbacEnum.colaboradorPontoManual.toFormattedString();
      case HomeItemEnum.incomeReport:
        return ApplicationRbacEnum.colaboradorDocumentosInformeRendimentos
            .toFormattedString();
      case HomeItemEnum.payStub:
        return ApplicationRbacEnum.colaboradorDocumentosHolerite
            .toFormattedString();
      case HomeItemEnum.vacation:
        return ApplicationRbacEnum.colaboradorDocumentosFerias
            .toFormattedString();
      case HomeItemEnum.exams:
        return ApplicationRbacEnum.colaboradorDocumentosFerias
            .toFormattedString();
      case HomeItemEnum.benefits:
        return ApplicationRbacEnum.colaboradorDocumentosBeneficios
            .toFormattedString();
      case HomeItemEnum.discounts:
        return ApplicationRbacEnum.colaboradorVantagensDescontos
            .toFormattedString();
      case HomeItemEnum.indicateReceiveBenefits:
        return ApplicationRbacEnum.colaboradorVantagensIndiqueGanhe
            .toFormattedString();
      case HomeItemEnum.condolivre:
        return ApplicationRbacEnum.colaboradorVantagensCondoLivre
            .toFormattedString();
      case HomeItemEnum.courses:
        return ApplicationRbacEnum.colaboradorVantagensCursos
            .toFormattedString();
      case HomeItemEnum.employeeReferral:
        return ApplicationRbacEnum.colaboradorVantagensIndiqueVagasRead
            .toFormattedString();
    }
  }

  bool checkRbac(SessionBloc sessionBloc) {
    switch (this) {
      case HomeItemEnum.digitalPoint:
        return sessionBloc.checkRback(
            ApplicationRbacEnum.colaboradorPontodigital.toFormattedString());
      case HomeItemEnum.myDocuments:
        return sessionBloc.checkRback(
            ApplicationRbacEnum.colaboradorDocumentos.toFormattedString());
      case HomeItemEnum.teamManagement:
        return sessionBloc.checkRback(
            ApplicationRbacEnum.colaboradorGestaoEquipe.toFormattedString());
      case HomeItemEnum.registerDigitalPoint:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorPontodigitalMarcarPonto
            .toFormattedString());
      case HomeItemEnum.timeSheet:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorPontodigitalEspelhoPontoRead
            .toFormattedString());
      case HomeItemEnum.proof:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorPontodigitalComprovante
            .toFormattedString());
      case HomeItemEnum.sickNote:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorPontodigitalAtestado
            .toFormattedString());
      case HomeItemEnum.sendTimeSheet:
        return sessionBloc.checkRback(
            ApplicationRbacEnum.colaboradorPontoManual.toFormattedString());
      case HomeItemEnum.incomeReport:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorDocumentosInformeRendimentos
            .toFormattedString());
      case HomeItemEnum.payStub:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorDocumentosHolerite
            .toFormattedString());
      case HomeItemEnum.vacation:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorDocumentosFerias
            .toFormattedString());
      case HomeItemEnum.exams:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorDocumentosFerias
            .toFormattedString());
      case HomeItemEnum.benefits:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorDocumentosBeneficios
            .toFormattedString());
      case HomeItemEnum.discounts:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorVantagensDescontos
            .toFormattedString());
      case HomeItemEnum.indicateReceiveBenefits:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorVantagensIndiqueGanhe
            .toFormattedString());
      case HomeItemEnum.condolivre:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorVantagensCondoLivre
            .toFormattedString());
      case HomeItemEnum.courses:
        return sessionBloc.checkRback(
            ApplicationRbacEnum.colaboradorVantagensCursos.toFormattedString());
      case HomeItemEnum.employeeReferral:
        return sessionBloc.checkRback(ApplicationRbacEnum
            .colaboradorVantagensCondoLivre
            .toFormattedString());
    }
  }

  bool checkVisible(SessionBloc sessionBloc) {
    var currentSessionState = sessionBloc.state;
    if (currentSessionState is! SessionLoadedState) return false;

    String reference =
        currentSessionState.session.condominium.reference.toString();
    switch (this) {
      case HomeItemEnum.digitalPoint:
        return circuitBreakController.checkVisible(
            applicationRbac:
                ApplicationRbacEnum.colaboradorPontodigital.toFormattedString(),
            reference: reference);
      case HomeItemEnum.myDocuments:
        return circuitBreakController.checkVisible(
            applicationRbac:
                ApplicationRbacEnum.colaboradorDocumentos.toFormattedString(),
            reference: reference);
      case HomeItemEnum.teamManagement:
        return circuitBreakController.checkVisible(
            applicationRbac:
                ApplicationRbacEnum.colaboradorGestaoEquipe.toFormattedString(),
            reference: reference);
      case HomeItemEnum.registerDigitalPoint:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum
                .colaboradorPontodigitalMarcarPonto
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.timeSheet:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum
                .colaboradorPontodigitalEspelhoPonto
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.proof:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum
                .colaboradorPontodigitalComprovante
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.sickNote:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorPontodigitalAtestado
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.sendTimeSheet:
        return circuitBreakController.checkVisible(
            applicationRbac:
                ApplicationRbacEnum.colaboradorPontoManual.toFormattedString(),
            reference: reference);
      case HomeItemEnum.incomeReport:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum
                .colaboradorDocumentosInformeRendimentos
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.payStub:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorDocumentosHolerite
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.vacation:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorDocumentosFerias
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.exams:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorDocumentosFerias
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.benefits:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorDocumentosBeneficios
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.discounts:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorVantagensDescontos
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.indicateReceiveBenefits:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum
                .colaboradorVantagensIndiqueGanhe
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.condolivre:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorVantagensCondoLivre
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.courses:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum.colaboradorVantagensCursos
                .toFormattedString(),
            reference: reference);
      case HomeItemEnum.employeeReferral:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbacEnum
                .colaboradorVantagensIndiqueVagasRead
                .toFormattedString(),
            reference: reference);
    }
  }

  Future<void> onTap({required BuildContext context}) async {
    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    final RegisterPointController registerPointController =
        ApplicationContainer.instance().resolve<RegisterPointController>();
    final HomeController homeController =
        ApplicationContainer.instance().resolve<HomeController>();

    final currentPage = homeController.pageController?.page?.round() ?? 0;

    // Stop timer if current page is 0
    if (currentPage == 0) homeController.colaboradorHomeTimerStop();

    switch (this) {
      case HomeItemEnum.digitalPoint:
        return;
      case HomeItemEnum.myDocuments:
        homeController.pageController!.page;
        homeController.pageController!.jumpToPage(1);
        homeController.currentPage = 1;
        break;
      case HomeItemEnum.teamManagement:
        Navigator.pushNamed(
          context,
          SharedApplicationRoute.gdp,
          arguments: GdpMainPageArgs(
            appOriginEnum: AppOriginEnum.employee,
            reference: (sessionBloc.state as SessionLoadedState)
                .session
                .condominium
                .reference,
          ),
        ).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        break;
      case HomeItemEnum.registerDigitalPoint:
        await registerPointController.onTap();
        break;
      case HomeItemEnum.timeSheet:
        Navigator.pushNamed(context, ApplicationRoute.timesheet).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.pontoDigitalEspelhoPontoAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.proof:
        Navigator.pushNamed(context, ApplicationRoute.proof).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.pontoDigitalComprovanteAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.sickNote:
        Navigator.pushNamed(context, ApplicationRoute.sickNote).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.pontoDigitalAtestadoMedicoAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.sendTimeSheet:
        Navigator.pushNamed(context, ApplicationRoute.manualTimesheet)
            .then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.homeEnvioFolhaPontoAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.incomeReport:
        Navigator.pushNamed(context, ApplicationRoute.incomeReportList)
            .then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        break;
      case HomeItemEnum.payStub:
        Navigator.pushNamed(context, ApplicationRoute.payStubList).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.documentosHoleriteAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.vacation:
        Navigator.pushNamed(context, ApplicationRoute.vacationList).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.documentosFeriasAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.exams:
        return;
      case HomeItemEnum.benefits:
        Navigator.pushNamed(context, ApplicationRoute.benefitsList).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.documentosBeneficiosAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.discounts:
        await Navigator.pushNamed(
          context,
          ApplicationRoute.comfortEmbedded,
          arguments: ComfortPageArgs(
            appOriginEnum: AppOriginEnum.employee,
            reference: (sessionBloc.state as SessionLoadedState)
                .session
                .condominium
                .reference,
            accessRouteOrigin: ComfortPageOriginEnum.homePage,
          ),
        ).then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        break;
      case HomeItemEnum.indicateReceiveBenefits:
        FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;

        String indiqueGanheUrl = "";
        String indiqueGanhePath = "";
        try {
          if (remoteConfig != null) {
            var indiqueGanhe = jsonDecode(remoteConfig
                .getString(CustomFirebaseRemoteConfig.indiqueGanhe));
            indiqueGanheUrl = indiqueGanhe["link"];
            indiqueGanhePath = indiqueGanhe["path"];
          }
        } catch (err) {
          break;
        }

        Launch.urlUri(
                context,
                UrlsUri.indiqueGanhe(
                    url: indiqueGanheUrl, path: indiqueGanhePath),
                mode: LaunchMode.externalApplication)
            .then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.vantagensIndiqueGanheAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.condolivre:
        FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
        String condoLivreUrl = "";
        String condoLivrePath = "";
        try {
          if (remoteConfig != null) {
            var condoLivre = jsonDecode(
                remoteConfig.getString(CustomFirebaseRemoteConfig.condoLivre));
            condoLivreUrl = condoLivre["link"];
            condoLivrePath = condoLivre["path"];
          }
        } catch (err) {
          break;
        }

        Launch.urlUri(context,
                UrlsUri.condoLivre(url: condoLivreUrl, path: condoLivrePath),
                mode: LaunchMode.externalApplication)
            .then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.vantagensCondolivreAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.courses:
        FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
        String cursosUrl = "";
        String cursosPath = "";
        try {
          if (remoteConfig != null) {
            var cursos = jsonDecode(
                remoteConfig.getString(CustomFirebaseRemoteConfig.cursos));
            cursosUrl = cursos["link"];
            cursosPath = cursos["path"];
          }
        } catch (err) {
          break;
        }

        Launch.urlUri(context, UrlsUri.cursos(url: cursosUrl, path: cursosPath),
                mode: LaunchMode.inAppWebView)
            .then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.vantagensCursosAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
      case HomeItemEnum.employeeReferral:
        Navigator.pushNamed(context, ApplicationRoute.employeeReferral)
            .then((_) {
          if (currentPage == 0) homeController.colaboradorHomeTimerStart();
        });
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.indicaVagaAcessar(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        break;
    }
  }

  int priority() {
    switch (this) {
      case HomeItemEnum.discounts:
        return 0;
      case HomeItemEnum.registerDigitalPoint:
        return 1;
      case HomeItemEnum.proof:
        return 2;
      case HomeItemEnum.digitalPoint:
      case HomeItemEnum.myDocuments:
      case HomeItemEnum.teamManagement:
      case HomeItemEnum.timeSheet:
      case HomeItemEnum.sendTimeSheet:
      case HomeItemEnum.incomeReport:
      case HomeItemEnum.payStub:
      case HomeItemEnum.vacation:
      case HomeItemEnum.exams:
      case HomeItemEnum.benefits:
      case HomeItemEnum.indicateReceiveBenefits:
      case HomeItemEnum.condolivre:
      case HomeItemEnum.courses:
      case HomeItemEnum.employeeReferral:
      case HomeItemEnum.sickNote:
        return 3;
    }
  }
}
