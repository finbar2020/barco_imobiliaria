import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';

enum HomeItemEnum {
  comfort,
  reserves,
  billets,
  insurance,
  agreements,
  accessControl,
  tdb,
  horta,
  subUser,
  vehicle,
  mailing,
  reports,
  rentSell,
  zeroPaper,
  documents,
  accountability,
  digitalMeeting,
  talkToLello,
  changeOwnership,
  updateUnitData,
  cnd,
  iaBella,
  myPreferences,
  receiveDocuments,
}

CircuitBreakerController circuitBreakController =
    ApplicationContainer.instance().resolve();

extension HomeItemExtension on HomeItemEnum {
  HomeItemEnum? homeItem(String item) {
    switch (item) {
      case "ia_bella":
        return HomeItemEnum.iaBella;
      case "comfort":
        return HomeItemEnum.comfort;
      case "reserves":
        return HomeItemEnum.reserves;
      case "income_control_billets":
        return HomeItemEnum.billets;
      case "insurance":
        return HomeItemEnum.insurance;
      case "agreements":
        return HomeItemEnum.agreements;
      case "authorize_entry":
        return HomeItemEnum.accessControl;
      case "tdb":
        return HomeItemEnum.tdb;
      case "horta_title":
        return HomeItemEnum.horta;
      case "condominium_hub_residents":
        return HomeItemEnum.subUser;
      case "me_vehicles_title":
        return HomeItemEnum.vehicle;
      case "mailing_title":
        return HomeItemEnum.mailing;
      case "reports_title":
        return HomeItemEnum.reports;
      case "rent_sell":
        return HomeItemEnum.rentSell;
      case "preferences_zero_paper":
        return HomeItemEnum.zeroPaper;
      case "documents":
        return HomeItemEnum.documents;
      case "lello_hub_billing":
        return HomeItemEnum.accountability;
      case "digital_meeting":
        return HomeItemEnum.digitalMeeting;
      case "talk_to_lello":
        return HomeItemEnum.talkToLello;
      case "change_ownership":
        return HomeItemEnum.changeOwnership;
      case "change_address":
        return HomeItemEnum.updateUnitData;
      case "cnd":
        return HomeItemEnum.cnd;
      case "my_preferences":
        return HomeItemEnum.myPreferences;
      case "receiving_documents":
        return HomeItemEnum.receiveDocuments;
      default:
        return null;
    }
  }

  String text() {
    switch (this) {
      case HomeItemEnum.comfort:
        return "comfort";
      case HomeItemEnum.reserves:
        return "reserves";
      case HomeItemEnum.billets:
        return "income_control_billets";
      case HomeItemEnum.insurance:
        return "insurance";
      case HomeItemEnum.agreements:
        return "agreements";
      case HomeItemEnum.accessControl:
        return "authorize_entry";
      case HomeItemEnum.tdb:
        return "tdb";
      case HomeItemEnum.horta:
        return "horta_title";
      case HomeItemEnum.subUser:
        return "condominium_hub_residents";
      case HomeItemEnum.vehicle:
        return "me_vehicles_title";
      case HomeItemEnum.mailing:
        return "mailing_title";
      case HomeItemEnum.reports:
        return "reports_title";
      case HomeItemEnum.rentSell:
        return "rent_sell";
      case HomeItemEnum.zeroPaper:
        return "preferences_zero_paper";
      case HomeItemEnum.documents:
        return "documents";
      case HomeItemEnum.accountability:
        return "lello_hub_billing";
      case HomeItemEnum.digitalMeeting:
        return "digital_meeting";
      case HomeItemEnum.talkToLello:
        return "talk_to_lello";
      case HomeItemEnum.changeOwnership:
        return "change_ownership";
      case HomeItemEnum.updateUnitData:
        return "change_address";
      case HomeItemEnum.cnd:
        return "cnd";
      case HomeItemEnum.myPreferences:
        return "my_preferences";
      case HomeItemEnum.iaBella:
        return "ia_bella";
      case HomeItemEnum.receiveDocuments:
        return "receipt_of_documents";
    }
  }

  bool isHighlighted() {
    switch (this) {
      case HomeItemEnum.comfort:
      case HomeItemEnum.reserves:
      case HomeItemEnum.billets:
      case HomeItemEnum.insurance:
      case HomeItemEnum.agreements:
      case HomeItemEnum.accessControl:
      case HomeItemEnum.tdb:
      case HomeItemEnum.horta:
      case HomeItemEnum.subUser:
      case HomeItemEnum.vehicle:
      case HomeItemEnum.mailing:
      case HomeItemEnum.reports:
      case HomeItemEnum.rentSell:
      case HomeItemEnum.zeroPaper:
      case HomeItemEnum.documents:
      case HomeItemEnum.accountability:
      case HomeItemEnum.digitalMeeting:
      case HomeItemEnum.talkToLello:
      case HomeItemEnum.changeOwnership:
      case HomeItemEnum.updateUnitData:
      case HomeItemEnum.cnd:
      case HomeItemEnum.myPreferences:
      case HomeItemEnum.receiveDocuments:
        return false;
      case HomeItemEnum.iaBella:
        return true;
    }
  }

  bool checkVisible(SessionBloc sessionBloc) {
    String reference =
        sessionBloc.state.session?.condominium?.reference.toString() ?? "";
    switch (this) {
      case HomeItemEnum.comfort:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarComodidades,
            reference: reference);
      case HomeItemEnum.reserves:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarReservas,
            reference: reference);
      case HomeItemEnum.billets:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarBoletos,
            reference: reference);
      case HomeItemEnum.insurance:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarSeguros,
            reference: reference);
      case HomeItemEnum.agreements:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarAcordos,
            reference: reference);
      case HomeItemEnum.accessControl:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarAutorizarEntrada,
            reference: reference);
      case HomeItemEnum.tdb:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarTesourosDoBairro,
            reference: reference);
      case HomeItemEnum.horta:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarHorta,
            reference: reference,
            hasHortaCheck: true);
      case HomeItemEnum.subUser:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarMoradores,
            reference: reference);
      case HomeItemEnum.vehicle:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarVeiculos,
            reference: reference);
      case HomeItemEnum.mailing:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarCorrespondencias,
            reference: reference);
      case HomeItemEnum.reports:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarOcorrencias,
            reference: reference);
      case HomeItemEnum.rentSell:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarAlugue, reference: reference);
      case HomeItemEnum.zeroPaper:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarPreferenciasPapelzero,
            reference: reference);
      case HomeItemEnum.documents:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarDocumentos,
            reference: reference);
      case HomeItemEnum.accountability:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarPpc, reference: reference);
      case HomeItemEnum.digitalMeeting:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarAssembleia,
            reference: reference);
      case HomeItemEnum.talkToLello:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarFaleLello,
            reference: reference);
      case HomeItemEnum.changeOwnership:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarAlteracaoTitularidade,
            reference: reference);
      case HomeItemEnum.updateUnitData:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarAlteracaoEndereco,
            reference: reference);
      case HomeItemEnum.cnd:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarCnd, reference: reference);
      case HomeItemEnum.iaBella:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarIaBella,
            reference: reference);
      case HomeItemEnum.myPreferences:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.morarPreferenciasMinhaConta,
            reference: reference);
      case HomeItemEnum.receiveDocuments:
        return circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac
                .morarPreferenciasMinhaContaFull, //Usando mesmo Rbac que essa featura usa na tela de Minha Conta
            reference: reference);
    }
  }

  String rbac(SessionBloc sessionBloc) {
    switch (this) {
      case HomeItemEnum.comfort:
        return ApplicationRbac.morarComodidades;
      case HomeItemEnum.reserves:
        return ApplicationRbac.morarReservas;
      case HomeItemEnum.billets:
        return ApplicationRbac.morarBoletos;
      case HomeItemEnum.insurance:
        return ApplicationRbac.morarSeguros;
      case HomeItemEnum.agreements:
        return ApplicationRbac.morarAcordos;
      case HomeItemEnum.accessControl:
        return ApplicationRbac.morarAutorizarEntrada;
      case HomeItemEnum.tdb:
        return ApplicationRbac.morarTesourosDoBairro;
      case HomeItemEnum.horta:
        return ApplicationRbac.morarHorta;
      case HomeItemEnum.subUser:
        return ApplicationRbac.morarMoradores;
      case HomeItemEnum.vehicle:
        return ApplicationRbac.morarVeiculos;
      case HomeItemEnum.mailing:
        return ApplicationRbac.morarCorrespondencias;
      case HomeItemEnum.reports:
        return ApplicationRbac.morarOcorrencias;
      case HomeItemEnum.rentSell:
        return ApplicationRbac.morarAlugue;
      case HomeItemEnum.zeroPaper:
        return ApplicationRbac.morarPreferenciasPapelzero;
      case HomeItemEnum.documents:
        return ApplicationRbac.morarDocumentos;
      case HomeItemEnum.accountability:
        return ApplicationRbac.morarPpc;
      case HomeItemEnum.digitalMeeting:
        return ApplicationRbac.morarAssembleia;
      case HomeItemEnum.talkToLello:
        return ApplicationRbac.morarFaleLello;
      case HomeItemEnum.changeOwnership:
        return ApplicationRbac.morarAlteracaoTitularidade;
      case HomeItemEnum.updateUnitData:
        return ApplicationRbac.morarAlteracaoEndereco;
      case HomeItemEnum.cnd:
        return ApplicationRbac.morarCnd;
      case HomeItemEnum.iaBella:
        return ApplicationRbac.morarIaBella;
      case HomeItemEnum.myPreferences:
        return ApplicationRbac.morarPreferenciasMinhaConta;
      case HomeItemEnum.receiveDocuments:
        return ApplicationRbac.morarPreferenciasMinhaContaFull;
    }
  }

  String imagePath(bool isGeneric) {
    switch (this) {
      case HomeItemEnum.iaBella:
        return "assets/ic_bella.svg";
      case HomeItemEnum.comfort:
        return "assets/comodities_icon.svg";
      case HomeItemEnum.reserves:
        return "assets/reserva_de_areas_icon.svg";
      case HomeItemEnum.billets:
        return "assets/ic_segunda_via_boletos.svg";
      case HomeItemEnum.insurance:
        return "assets/ic_insurance.svg";
      case HomeItemEnum.agreements:
        return "assets/ic_agreements.svg";
      case HomeItemEnum.accessControl:
        return "assets/autorizar_icon.svg";
      case HomeItemEnum.tdb:
        return "assets/tdb_icon.svg";
      case HomeItemEnum.horta:
        return "assets/ic_horta_card.svg";
      case HomeItemEnum.subUser:
        return "assets/ic_moradores.svg";
      case HomeItemEnum.vehicle:
        return "assets/vehicles_icon.svg";
      case HomeItemEnum.mailing:
        return "assets/ic_correspondencia.svg";
      case HomeItemEnum.reports:
        return "assets/ocorrencias_icon.svg";
      case HomeItemEnum.rentSell:
        return "assets/ic_rent_sell.svg";
      case HomeItemEnum.zeroPaper:
        return "assets/ic_zero_paper.svg";
      case HomeItemEnum.documents:
        return "assets/ic_documents.svg";
      case HomeItemEnum.accountability:
        return "assets/ic_accountability.svg";
      case HomeItemEnum.digitalMeeting:
        return "assets/ic_digital_assembly.svg";
      case HomeItemEnum.talkToLello:
        return isGeneric
            ? "assets/ic_whats.svg"
            : "assets/ic_talk_to_lello.svg";
      case HomeItemEnum.changeOwnership:
        return "assets/ic_change_ownership.svg";
      case HomeItemEnum.updateUnitData:
        return "assets/ic_change_address.svg";
      case HomeItemEnum.cnd:
        return "assets/ic_cnd.svg";
      case HomeItemEnum.myPreferences:
        return "assets/ic_minha_conta.svg";
      case HomeItemEnum.receiveDocuments:
        return "assets/ic_carta.svg";
    }
  }

  String routes() {
    switch (this) {
      case HomeItemEnum.comfort:
        return ApplicationRoute.comfort;
      case HomeItemEnum.reserves:
        return ApplicationRoute.reserve;
      case HomeItemEnum.billets:
        return ApplicationRoute.billets;
      case HomeItemEnum.insurance:
        return ApplicationRoute.insurance;
      case HomeItemEnum.agreements:
        return ApplicationRoute.agreements;
      case HomeItemEnum.accessControl:
        return ApplicationRoute.accessControl;
      case HomeItemEnum.tdb:
        return ApplicationRoute.tdb;
      case HomeItemEnum.horta:
        return "";
      case HomeItemEnum.subUser:
        return ApplicationRoute.subUser;
      case HomeItemEnum.vehicle:
        return ApplicationRoute.vehiclePage;
      case HomeItemEnum.mailing:
        return ApplicationRoute.mailing;
      case HomeItemEnum.reports:
        return ApplicationRoute.reports;
      case HomeItemEnum.rentSell:
        return "";
      case HomeItemEnum.zeroPaper:
        return ApplicationRoute.preferencesZeroPaper;
      case HomeItemEnum.documents:
        return ApplicationRoute.documents;
      case HomeItemEnum.accountability:
        return ApplicationRoute.accountability;
      case HomeItemEnum.digitalMeeting:
        return ApplicationRoute.digitalMeeting;
      case HomeItemEnum.talkToLello:
        return "";
      case HomeItemEnum.changeOwnership:
        return ApplicationRoute.changeOwnership;
      case HomeItemEnum.updateUnitData:
        return ApplicationRoute.updateUnitData;
      case HomeItemEnum.cnd:
        return ApplicationRoute.certificateNoOutstandingDebt;
      case HomeItemEnum.iaBella:
        return ApplicationRoute.iaBella;
      case HomeItemEnum.myPreferences:
        return ApplicationRoute.myPreferences;
      case HomeItemEnum.receiveDocuments:
        return ApplicationRoute.receivingDocuments;
    }
  }

  int priority() {
    switch (this) {
      case HomeItemEnum.comfort:
        return 0;
      case HomeItemEnum.agreements:
        return 1;
      case HomeItemEnum.billets:
        return 2;
      case HomeItemEnum.reserves:
      case HomeItemEnum.insurance:
      case HomeItemEnum.accessControl:
      case HomeItemEnum.tdb:
      case HomeItemEnum.horta:
      case HomeItemEnum.subUser:
      case HomeItemEnum.vehicle:
      case HomeItemEnum.mailing:
      case HomeItemEnum.reports:
      case HomeItemEnum.rentSell:
      case HomeItemEnum.zeroPaper:
      case HomeItemEnum.documents:
      case HomeItemEnum.accountability:
      case HomeItemEnum.digitalMeeting:
      case HomeItemEnum.talkToLello:
      case HomeItemEnum.changeOwnership:
      case HomeItemEnum.updateUnitData:
      case HomeItemEnum.iaBella:
      case HomeItemEnum.myPreferences:
      case HomeItemEnum.cnd:
      case HomeItemEnum.receiveDocuments:
        return 3;
    }
  }
}

class HomeItemEnumUtils {
  static List<HomeItemEnum> get defaultDashboardOrder => [
        HomeItemEnum.billets, // income_control_billets
        HomeItemEnum.reserves,
        HomeItemEnum.accessControl, // authorize_entry
        HomeItemEnum.comfort,
        HomeItemEnum.documents,
        HomeItemEnum.agreements,
        HomeItemEnum.subUser, // condominium_hub_residents
        HomeItemEnum.reports, // reports_title
        HomeItemEnum.mailing, // mailing_title
        HomeItemEnum.accountability, // lello_hub_billing
        HomeItemEnum.vehicle, // me_vehicles_title
        HomeItemEnum.digitalMeeting,
        HomeItemEnum.tdb,
        HomeItemEnum.insurance,
        HomeItemEnum.rentSell,
        HomeItemEnum.horta, // horta_title
        HomeItemEnum.zeroPaper, // preferences_zero_paper
        HomeItemEnum.myPreferences,
        HomeItemEnum.talkToLello,
        HomeItemEnum.changeOwnership,
        HomeItemEnum.updateUnitData,
        HomeItemEnum.cnd,
        HomeItemEnum.receiveDocuments,
      ];

  static List<HomeItemEnum> get homePageItems => [
        HomeItemEnum.billets,
        HomeItemEnum.reserves,
        HomeItemEnum.accessControl,
        HomeItemEnum.comfort,
        HomeItemEnum.documents,
        HomeItemEnum.agreements,
        HomeItemEnum.subUser,
        HomeItemEnum.reports,
        HomeItemEnum.mailing,
        HomeItemEnum.accountability,
        HomeItemEnum.vehicle,
        HomeItemEnum.digitalMeeting,
        HomeItemEnum.tdb,
        HomeItemEnum.insurance,
        HomeItemEnum.rentSell,
        HomeItemEnum.horta,
        HomeItemEnum.zeroPaper,
        HomeItemEnum.myPreferences,
        HomeItemEnum.talkToLello,
        HomeItemEnum.changeOwnership,
        HomeItemEnum.updateUnitData,
        HomeItemEnum.cnd,
        HomeItemEnum.receiveDocuments,
      ];

  static List<HomeItemEnum> get easyFixPageItems => [
        HomeItemEnum.myPreferences,
        HomeItemEnum.billets,
        HomeItemEnum.accountability,
        HomeItemEnum.agreements,
        HomeItemEnum.changeOwnership,
        HomeItemEnum.cnd,
        HomeItemEnum.documents,
        HomeItemEnum.reserves,
      ];

  static List<HomeItemEnum> get unityPageItems => [
        HomeItemEnum.subUser,
        HomeItemEnum.digitalMeeting,
        HomeItemEnum.vehicle,
        HomeItemEnum.mailing,
        HomeItemEnum.reports,
        HomeItemEnum.accessControl,
        HomeItemEnum.insurance,
      ];
}
