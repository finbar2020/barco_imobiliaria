import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/condominium/presentation/widget/hub_badge.dart';
import 'package:lello/feature/home/presentation/controllers/home_analytics_timer_controller.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';

enum HomeItemEnum {
  accessManagement,
  incomeMonthlyBillets,
  gdpTeam,
  manageSpace,
  units,
  announcements,
  advertences,
  documents,
  reportsBook,
  outcome,
  income,
  employee,
  hubDefault,
  agreements,
  billing,
  resin,
}

CircuitBreakerController circuitBreakController =
    ApplicationContainer.instance().resolve();

extension HomeItemExtension on HomeItemEnum {
  HomeItemEnum? homeItem(String item) {
    switch (item) {
      case "accessManagement":
        return HomeItemEnum.accessManagement;
      case "incomeMonthlyBillets":
        return HomeItemEnum.incomeMonthlyBillets;
      case "gdpTeam":
        return HomeItemEnum.gdpTeam;
      case "manageSpace":
        return HomeItemEnum.manageSpace;
      case "units":
        return HomeItemEnum.units;
      case "announcements":
        return HomeItemEnum.announcements;
      case "advertences":
        return HomeItemEnum.advertences;
      case "documents":
        return HomeItemEnum.documents;
      case "reportsBook":
        return HomeItemEnum.reportsBook;
      case "outcome":
        return HomeItemEnum.outcome;
      case "income":
        return HomeItemEnum.income;
      case "employee":
        return HomeItemEnum.employee;
      case "hubDefault":
        return HomeItemEnum.hubDefault;
      case "agreements":
        return HomeItemEnum.agreements;
      case "billing":
        return HomeItemEnum.billing;
      case "resin":
        return HomeItemEnum.resin;
      default:
        return null;
    }
  }

  bool rbac(SessionBloc sessionBloc) {
    switch (this) {
      case HomeItemEnum.accessManagement:
        return sessionBloc
                .state.session?.selectedCondominium?.useFacialBiometric ??
            false;
      case HomeItemEnum.incomeMonthlyBillets:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoSegundavia,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.gdpTeam:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoEquipe,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.manageSpace:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoReservas,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.units:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoUnidades,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.announcements:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoVoxComunicados,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.advertences:
        return circuitBreakController.checkVisible(
                applicationRbac: ApplicationRbac.sindicoVoxAdvertencias,
                reference:
                    sessionBloc.state.session?.selectedCondominium?.reference ??
                        "") ||
            circuitBreakController.checkVisible(
                applicationRbac: ApplicationRbac.sindicoVoxMultas,
                reference:
                    sessionBloc.state.session?.selectedCondominium?.reference ??
                        "");
      case HomeItemEnum.documents:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoVox,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.reportsBook:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoOcorrencias,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.outcome:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoDespesas,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.income:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoReceitas,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.employee:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoGdp,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.hubDefault:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoInadimplentes,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.agreements:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoAcordos,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.billing:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoPpc,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
      case HomeItemEnum.resin:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoCaixalocal,
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
    }
  }

  String rbacString() {
    switch (this) {
      case HomeItemEnum.accessManagement:
        return "";
      case HomeItemEnum.incomeMonthlyBillets:
        return ApplicationRbac.sindicoSegundavia;
      case HomeItemEnum.gdpTeam:
        return ApplicationRbac.sindicoEquipe;
      case HomeItemEnum.manageSpace:
        return ApplicationRbac.sindicoReservas;
      case HomeItemEnum.units:
        return ApplicationRbac.sindicoUnidades;
      case HomeItemEnum.announcements:
        return ApplicationRbac.sindicoVoxComunicados;
      case HomeItemEnum.advertences:
        return ApplicationRbac.sindicoVoxAdvertencias;
      case HomeItemEnum.documents:
        return ApplicationRbac.sindicoVox;
      case HomeItemEnum.reportsBook:
        return ApplicationRbac.sindicoOcorrencias;
      case HomeItemEnum.outcome:
        return ApplicationRbac.sindicoDespesas;
      case HomeItemEnum.income:
        return ApplicationRbac.sindicoReceitas;
      case HomeItemEnum.employee:
        return ApplicationRbac.sindicoGdp;
      case HomeItemEnum.hubDefault:
        return ApplicationRbac.sindicoInadimplentes;
      case HomeItemEnum.agreements:
        return ApplicationRbac.sindicoAcordos;
      case HomeItemEnum.billing:
        return ApplicationRbac.sindicoPpc;
      case HomeItemEnum.resin:
        return ApplicationRbac.sindicoCaixalocal;
    }
  }

  String get title {
    switch (this) {
      case HomeItemEnum.accessManagement:
        return "access_management_title";
      case HomeItemEnum.incomeMonthlyBillets:
        return "income_monthly_billets";
      case HomeItemEnum.gdpTeam:
        return "gdp_team";
      case HomeItemEnum.manageSpace:
        return "condominium_hub_manage_space";
      case HomeItemEnum.units:
        return "condominium_hub_units";
      case HomeItemEnum.announcements:
        return "condominium_hub_announcements";
      case HomeItemEnum.advertences:
        return "condominium_hub_advertences";
      case HomeItemEnum.documents:
        return "condominium_hub_condominium_documents";
      case HomeItemEnum.reportsBook:
        return "condominium_hub_reports_book";
      case HomeItemEnum.outcome:
        return "lello_hub_outcome";
      case HomeItemEnum.income:
        return "lello_hub_income";
      case HomeItemEnum.employee:
        return "lello_hub_employee";
      case HomeItemEnum.hubDefault:
        return "lello_hub_default";
      case HomeItemEnum.agreements:
        return "lello_hub_agreements";
      case HomeItemEnum.billing:
        return "lello_hub_billing";
      case HomeItemEnum.resin:
        return "lello_hub_resin";
    }
  }

  Widget get icon {
    switch (this) {
      case HomeItemEnum.accessManagement:
        return SvgPicture.asset("assets/ic_access_management.svg");
      case HomeItemEnum.incomeMonthlyBillets:
        return SvgPicture.asset("assets/ic_barcode_menu.svg");
      case HomeItemEnum.gdpTeam:
        return SvgPicture.asset("assets/ic_team.svg");
      case HomeItemEnum.manageSpace:
        return SvgPicture.asset("assets/ic_hub_manage_space.svg");
      case HomeItemEnum.units:
        return SvgPicture.asset("assets/ic_hub_units.svg");
      case HomeItemEnum.announcements:
        return SvgPicture.asset("assets/ic_announcements.svg");
      case HomeItemEnum.advertences:
        return SvgPicture.asset("assets/ic_warnings_and_fines.svg");
      case HomeItemEnum.documents:
        return SvgPicture.asset("assets/ic_condo_documents.svg");
      case HomeItemEnum.reportsBook:
        return SvgPicture.asset("assets/ic_reports_book_menu.svg");
      case HomeItemEnum.outcome:
        return SvgPicture.asset("assets/ic_outcome.svg");
      case HomeItemEnum.income:
        return SvgPicture.asset("assets/ic_revenues.svg");
      case HomeItemEnum.employee:
        return SvgPicture.asset("assets/ic_people_management.svg");
      case HomeItemEnum.hubDefault:
        return SvgPicture.asset("assets/ic_non_payment.svg");
      case HomeItemEnum.agreements:
        return SvgPicture.asset("assets/ic_hub_agreements.svg");
      case HomeItemEnum.billing:
        return SvgPicture.asset("assets/ic_hub_billing.svg");
      case HomeItemEnum.resin:
        return SvgPicture.asset("assets/ic_local_checkout.svg");
    }
  }

  bool isEnabled(SessionBloc sessionBloc) {
    switch (this) {
      case HomeItemEnum.accessManagement:
        return true;
      case HomeItemEnum.incomeMonthlyBillets:
        return true;
      case HomeItemEnum.gdpTeam:
        return true;
      case HomeItemEnum.manageSpace:
        return true;
      case HomeItemEnum.units:
        return true;
      case HomeItemEnum.announcements:
        return true;
      case HomeItemEnum.advertences:
        return true;
      case HomeItemEnum.documents:
        return true;
      case HomeItemEnum.reportsBook:
        return sessionBloc.checkConfig("report_book_reference");
      case HomeItemEnum.outcome:
        return true;
      case HomeItemEnum.income:
        return true;
      case HomeItemEnum.employee:
        return true;
      case HomeItemEnum.hubDefault:
        return true;
      case HomeItemEnum.agreements:
        return sessionBloc.checkConfig("agreement_reference");
      case HomeItemEnum.billing:
        return true;
      case HomeItemEnum.resin:
        return sessionBloc.checkConfig("resin_reference");
    }
  }

  Widget? comingSoonBadge(SessionBloc sessionBloc, BuildContext context) {
    switch (this) {
      case HomeItemEnum.accessManagement:
        return null;
      case HomeItemEnum.incomeMonthlyBillets:
        return null;
      case HomeItemEnum.gdpTeam:
        return null;
      case HomeItemEnum.manageSpace:
        return null;
      case HomeItemEnum.units:
        return null;
      case HomeItemEnum.announcements:
        return null;
      case HomeItemEnum.advertences:
        return null;
      case HomeItemEnum.documents:
        return null;
      case HomeItemEnum.reportsBook:
        return sessionBloc.checkConfig("report_book_reference")
            ? null
            : HubBadge(text: getString(context, "lello_hub_badge_soon"));
      case HomeItemEnum.outcome:
        return null;
      case HomeItemEnum.income:
        return null;
      case HomeItemEnum.employee:
        return null;
      case HomeItemEnum.hubDefault:
        return null;
      case HomeItemEnum.agreements:
        return null;
      case HomeItemEnum.billing:
        return null;
      case HomeItemEnum.resin:
        return sessionBloc.checkConfig("resin_reference")
            ? null
            : HubBadge(text: getString(context, "lello_hub_badge_soon"));
    }
  }

  void Function()? onTap(SessionBloc sessionBloc, BuildContext context) {
    HomeAnalyticsTimerController homeAnalyticsTimerController =
        ApplicationContainer.instance().resolve();
    String reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";

    void startTimer() {
      homeAnalyticsTimerController.sindicoHomeTimerStart(3);
    }

    void stopTimer() {
      homeAnalyticsTimerController.sindicoHomeTimerStop();
    }

    void navigateTo(String route) {
      stopTimer();
      Navigator.of(context).pushNamed(route).then((_) => startTimer());
    }

    switch (this) {
      case HomeItemEnum.accessManagement:
        return () {
          stopTimer();
          navigateTo(ApplicationRoute.accessManagement);
        };
      case HomeItemEnum.incomeMonthlyBillets:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.condBoletosAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.billets);
        };
      case HomeItemEnum.gdpTeam:
        return () {
          stopTimer();
          navigateTo(ApplicationRoute.gdpEmployeeList);
        };
      case HomeItemEnum.manageSpace:
        return () {
          stopTimer();
          navigateTo(ApplicationRoute.space);
        };
      case HomeItemEnum.units:
        return () {
          stopTimer();
          navigateTo(ApplicationRoute.units);
        };
      case HomeItemEnum.announcements:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.comunicadosAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.announcementsMenu);
        };
      case HomeItemEnum.advertences:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.advertenciaMultasAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.warningsAndFines);
        };
      case HomeItemEnum.documents:
        return () {
          stopTimer();
          navigateTo(ApplicationRoute.documents);
        };
      case HomeItemEnum.reportsBook:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.ocorrenciasAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.reportsBook);
        };
      case HomeItemEnum.outcome:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.despesasAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.payment);
        };
      case HomeItemEnum.income:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.receitasAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.income);
        };
      case HomeItemEnum.employee:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.gdpAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.gdp);
        };
      case HomeItemEnum.hubDefault:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.inadimplenciaAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.nonPayments);
        };
      case HomeItemEnum.agreements:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.acordosAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.agreements);
        };
      case HomeItemEnum.billing:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.ppcAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.accountability);
        };
      case HomeItemEnum.resin:
        return () {
          stopTimer();
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.caixaLocalAcessar(),
              referenceValue: reference);
          navigateTo(ApplicationRoute.resinMenu);
        };
    }
  }

  int get priority {
    switch (this) {
      case HomeItemEnum.outcome:
        return 0;
      case HomeItemEnum.income:
        return 1;
      case HomeItemEnum.manageSpace:
      case HomeItemEnum.units:
      case HomeItemEnum.announcements:
      case HomeItemEnum.advertences:
      case HomeItemEnum.gdpTeam:
      case HomeItemEnum.incomeMonthlyBillets:
      case HomeItemEnum.accessManagement:
      case HomeItemEnum.documents:
      case HomeItemEnum.reportsBook:
      case HomeItemEnum.employee:
      case HomeItemEnum.hubDefault:
      case HomeItemEnum.agreements:
      case HomeItemEnum.billing:
      case HomeItemEnum.resin:
        return 2;
    }
  }
}
