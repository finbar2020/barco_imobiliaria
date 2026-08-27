import 'dart:convert';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_invite_forward_type.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';
import 'package:morar/feature/access_control/domain/entity/access_invite_user_type_enum.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_bloc.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';
import 'package:shared_features/shared_features.dart';

class AccessControlStore {
  final AccessControlBloc bloc;
  final GetVisitants getVisitantsUseCase;
  final SaveVisitant save;
  final EditVisitant edit;
  final DeleteVisitant deleteVisitantUsecase;
  final AddVisit addVisit;
  final DeleteVisit deleteScheduled;
  final EditVisit editScheduled;
  final SessionBloc sessionBloc;
  final SendInviteUsecase sendInvite;

  AccessControlStore({
    required this.bloc,
    required this.getVisitantsUseCase,
    required this.save,
    required this.edit,
    required this.deleteVisitantUsecase,
    required this.addVisit,
    required this.deleteScheduled,
    required this.editScheduled,
    required this.sessionBloc,
    required this.sendInvite,
  });

  List<AccessControl> visitants = [];
  List<AccessControl> providers = [];

  Future<void> getLists({bool closeOnboarding = false}) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );

    if (sessionBloc.state.session?.condominium?.id == null ||
        sessionBloc.state.session?.unity?.id == null) {
      bloc.add(AccessControlFailureEvent());
      return;
    }

    var preferences = await SharedPreferences.getInstance();
    if (closeOnboarding == false) {
      var onboarding = preferences.getString(
          SharedPreferencesKeys.accessControlOnboarding.replaceAll(
              "#ref", sessionBloc.state.session?.condominium?.reference ?? ""));
      Map<String, dynamic> onboardingAccess = {
        'reference': sessionBloc.state.session?.condominium?.reference,
        'onboarding': true,
      };
      if (onboarding != null && onboarding.isNotEmpty) {
        onboardingAccess = json.decode(onboarding);
      }

      if (onboardingAccess["reference"] ==
              sessionBloc.state.session?.condominium?.reference &&
          onboardingAccess["onboarding"] == true &&
          sessionBloc.state.session?.condominium?.useFacialBiometric == true) {
        bloc.add(AccessControlOnBoardingEvent());
        return;
      }
    } else {
      await preferences.setString(
        SharedPreferencesKeys.accessControlOnboarding.replaceAll(
            "#ref", sessionBloc.state.session?.condominium?.reference ?? ""),
        json.encode({
          'reference': sessionBloc.state.session?.condominium?.reference,
          'onboarding': false
        }),
      );
    }
    final response = await getVisitantsUseCase
        .call(GetVisitantsParam(unitId: sessionBloc.state.session!.unity!.id!));

    response.fold((error) => bloc.add(AccessControlFailureEvent()), (res) {
      try {
        if (visitants.isNotEmpty) {
          visitants.clear();
        }
        if (providers.isNotEmpty) {
          providers.clear();
        }
        if (res.isNotEmpty) {
          res.forEach((element) {
            if (element.type == "GEST") {
              visitants.add(element);
            } else {
              providers.add(element);
            }
          });
        }
        bloc.add(AccessControlLoadedEvent(
          visitants: visitants,
          providers: providers,
        ));
      } catch (e) {
        bloc.add(AccessControlFailureEvent());
      }
    });
  }

  Future<bool> saveAccess(
      {required AccessControl model,
      required AccessControlAuthorizations authorizations,
      required bool useFacialBiometric}) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );

    String gestId = "";

    if (model.phone != null) {
      model.phone = model.phone!.replaceAll(RegExp(r'[^0-9]'), '');
    }

    var visitantLastUnit =
        model.gestUnits.isNotEmpty ? model.gestUnits.last : null;

    var visitant = AccessControlVisitant(
      autorizarionType: visitantLastUnit?.autorizationTypeInt,
      gest: model,
      idGestUnit: visitantLastUnit?.idGestUnit,
      observation: visitantLastUnit?.observation,
      units: [visitantLastUnit?.unit ?? sessionBloc.state.session!.unity!],
    );

    final response = await save.call(SaveVisitantParam(
      visitant: visitant,
    ));

    final result = response.fold((error) {
      bloc.add(
        SaveVisitantFailureEvent(
          visitants: visitants,
          providers: providers,
          visitant: model,
          model: authorizations,
          failureInvite: false,
        ),
      );
      return false;
    }, (res) {
      gestId = res.idGest!;
      return true;
    });
    if (result) {
      final responseVisist = await addVisit.call(AddVisitParam(
        gestId: gestId,
        unitId: sessionBloc.state.session!.unity!.id!,
        model: authorizations,
      ));

      final resultVisist = responseVisist.fold((error) {
        bloc.add(
          SaveVisitantFailureEvent(
            visitants: visitants,
            providers: providers,
            visitant: model,
            model: authorizations,
            failureInvite: false,
          ),
        );
        return false;
      }, (res) => true);
      if (resultVisist) {
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.autorizacaoEntradasAgendamentosSucesso(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          otherParameters: {
            "tipo agendamento": authorizations.recorrente,
          },
        );

        if (useFacialBiometric) {
          var responseSendInvite = await sendInvite.call(SendInviteParam(
              body: AccessControlSendInviteEntity(
                  cpf: model.document?.replaceAll(RegExp(r'[^0-9]'), ''),
                  forwardType: AccessControlInviteForwardType.sms,
                  name: model.name,
                  phone: model.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
                  foreignDocument: model.foreignDocument,
                  foreignDocumentType: model.typeDocument,
                  userType: model.prestador == false
                      ? AccessControlInviteUserType.gest
                      : AccessControlInviteUserType.serviceprovider)));

          var resultSendInvite = responseSendInvite.fold((l) {
            bloc.add(
              SaveVisitantFailureEvent(
                visitants: visitants,
                providers: providers,
                visitant: model,
                model: authorizations,
                failureInvite: true,
              ),
            );
            return false;
          }, (r) {
            bloc.add(SaveVisitantLoadedEvent(
              visitants: visitants,
              providers: providers,
              isVisitant: model.prestador == false,
              useFacial: useFacialBiometric,
              link: r,
            ));
            return true;
          });
          if (resultSendInvite == false) {
            return false;
          }
        } else {
          // Único `SaveVisitantLoadedEvent` do fluxo sem biometria: a página
          // só deve navegar quando o cadastro + agendamento terminaram.
          bloc.add(SaveVisitantLoadedEvent(
            visitants: visitants,
            providers: providers,
            isVisitant: model.prestador == false,
            useFacial: useFacialBiometric,
          ));
        }
      } else {
        await deleteVisitantUsecase.call(DeleteVisitantParam(
          gestId: gestId,
        ));
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveVisit({
    required AccessControl model,
    required AccessControlAuthorizations authorizations,
    required String? cpf,
  }) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );

    authorizations.idUnit = sessionBloc.state.session?.unity?.id ?? "";
    authorizations.idGest = model.idGest ?? "";
    var visitantLastUnit =
        model.gestUnits.isNotEmpty ? model.gestUnits.last : null;

    var curentUnit =
        visitantLastUnit?.unit?.id == null || visitantLastUnit?.unit?.id == ""
            ? sessionBloc.state.session!.unity!
            : visitantLastUnit?.unit;
    var visitant = AccessControlVisitant(
      autorizarionType: visitantLastUnit?.autorizationTypeInt,
      gest: model,
      idGestUnit: visitantLastUnit?.idGestUnit,
      observation: visitantLastUnit?.observation,
      units: [curentUnit!],
    );

    final responseEdit = await edit.call(EditVisitantParam(visitant: visitant));

    bool success = responseEdit.fold(
      (error) {
        bloc.add(
          SaveVisitantFailureEvent(
            visitants: visitants,
            providers: providers,
            visitant: model,
            model: authorizations,
            failureInvite: false,
          ),
        );
        return false;
      },
      (res) => true,
    );
    if (success) {
      final responseVisit = await addVisit.call(AddVisitParam(
        gestId: model.idGest ?? "",
        unitId: sessionBloc.state.session!.unity!.id!,
        model: authorizations,
      ));
      bool successResponseVisit = responseVisit.fold(
        (error) {
          bloc.add(
            SaveVisitantFailureEvent(
              visitants: visitants,
              providers: providers,
              visitant: model,
              model: authorizations,
              failureInvite: false,
            ),
          );
          return false;
        },
        (res) => true,
      );

      if (successResponseVisit) {
        if (authorizations.useFacialBiometric == false) {
          bloc.add(
            SaveVisitantLoadedEvent(
              visitants: visitants,
              providers: providers,
              isVisitant: model.type == "GEST",
              useFacial: authorizations.useFacialBiometric ?? false,
              newVisit: true,
            ),
          );
          return true;
        } else {
          var responseSendInvite = await sendInvite.call(
            SendInviteParam(
              body: AccessControlSendInviteEntity(
                  cpf: model.document?.replaceAll(RegExp(r'[^0-9]'), ''),
                  forwardType: AccessControlInviteForwardType.sms,
                  name: model.name,
                  phone: model.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
                  foreignDocument: model.foreignDocument,
                  foreignDocumentType: model.typeDocument,
                  userType: model.type == "GEST"
                      ? AccessControlInviteUserType.gest
                      : AccessControlInviteUserType.serviceprovider),
            ),
          );
          return responseSendInvite.fold(
            (error) {
              bloc.add(
                SaveVisitantFailureEvent(
                  visitants: visitants,
                  providers: providers,
                  visitant: model,
                  model: authorizations,
                  failureInvite: true,
                ),
              );
              return false;
            },
            (res) {
              bloc.add(
                SaveVisitantLoadedEvent(
                  visitants: visitants,
                  providers: providers,
                  isVisitant: model.type == "GEST",
                  useFacial: authorizations.useFacialBiometric ?? false,
                  link: res,
                ),
              );
              return true;
            },
          );
        }
      }
    }
    // As falhas de edição e de agendamento já emitiram o
    // `SaveVisitantFailureEvent` no respectivo `fold`.
    return false;
  }

  Future<bool> editScheduledVisit(
      {required AccessControl model,
      required AccessControlAuthorizations authorizations,
      required String? cpf}) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );
    var visitantLastUnit =
        model.gestUnits.isNotEmpty ? model.gestUnits.last : null;
    var currentUnit =
        visitantLastUnit?.unit?.id == null || visitantLastUnit?.unit?.id == ""
            ? sessionBloc.state.session!.unity!
            : visitantLastUnit?.unit;

    var visitant = AccessControlVisitant(
      autorizarionType: visitantLastUnit?.autorizationTypeInt,
      gest: model,
      idGestUnit: visitantLastUnit?.idGestUnit,
      observation: visitantLastUnit?.observation,
      units: [currentUnit!],
    );

    authorizations.idGest = model.idGest;
    authorizations.idUnit = currentUnit.id;

    final responseEdit = await edit.call(EditVisitantParam(visitant: visitant));
    bool success = responseEdit.fold((error) {
      bloc.add(
        SaveVisitantFailureEvent(
          visitants: visitants,
          providers: providers,
          visitant: model,
          model: authorizations,
          failureInvite: false,
        ),
      );
      return false;
    }, (res) {
      return true;
    });
    if (success) {
      var responseEditVisit = await editScheduled.call(
        EditVisitParam(
            recurrenceId: authorizations.id ?? "", model: authorizations),
      );
      bool response = responseEditVisit.fold((error) {
        bloc.add(
          SaveVisitantFailureEvent(
            visitants: visitants,
            providers: providers,
            visitant: model,
            model: authorizations,
            failureInvite: false,
          ),
        );
        return false;
      }, (res) {
        return true;
      });
      if (!response) {
        return response;
      }
      if (authorizations.useFacialBiometric == false) {
        bloc.add(
          SaveVisitantLoadedEvent(
            visitants: visitants,
            providers: providers,
            isVisitant: model.type == "GEST",
            useFacial: authorizations.useFacialBiometric ?? false,
            edit: true,
          ),
        );
        return true;
      } else {
        var responseSendInvite = await sendInvite.call(
          SendInviteParam(
            body: AccessControlSendInviteEntity(
                cpf: model.document?.replaceAll(RegExp(r'[^0-9]'), ''),
                forwardType: AccessControlInviteForwardType.sms,
                name: model.name,
                phone: model.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
                foreignDocument: model.foreignDocument,
                foreignDocumentType: model.typeDocument,
                userType: model.type == "GEST"
                    ? AccessControlInviteUserType.gest
                    : AccessControlInviteUserType.serviceprovider),
          ),
        );
        bool response = responseSendInvite.fold(
          (error) {
            bloc.add(
              SaveVisitantFailureEvent(
                visitants: visitants,
                providers: providers,
                visitant: model,
                model: authorizations,
                failureInvite: true,
              ),
            );
            return false;
          },
          (res) {
            bloc.add(
              SaveVisitantLoadedEvent(
                visitants: visitants,
                providers: providers,
                isVisitant: model.type == "GEST",
                useFacial: authorizations.useFacialBiometric ?? false,
                link: res,
              ),
            );
            return true;
          },
        );
        return response;
      }
    } else {
      return false;
    }
  }

  Future<void> editVisitant({
    required AccessControl visitant,
    required AccessControlAuthorizations authorizations,
  }) async {
    bloc.add(
      EditVisitantEvent(
        visitant: visitant,
        providers: providers,
        model: authorizations,
        visitants: visitants,
      ),
    );
  }

  Future<void> deleteVisitant(
      {required String gestId,
      required AccessControl visitant,
      required AccessControlAuthorizations authorizations}) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );

    final response = await deleteVisitantUsecase.call(
      DeleteVisitantParam(
        gestId: gestId,
      ),
    );
    response.fold((error) {
      bloc.add(
        SaveVisitantFailureEvent(
          visitants: visitants,
          providers: providers,
          visitant: visitant,
          failureInvite: false,
          deletVisitant: true,
          model: AccessControlAuthorizations(
            accessControl: AccessControl(),
          ),
        ),
      );
    }, (res) {
      bloc.add(
        DeleteVisitantEvent(
            visitants: visitants, providers: providers, visitant: visitant),
      );
      OwnerAnalyticsLogEvents.logEvent(
          event:
              AnalyticsEventsOwner.autorizacaoEntradasAcessarApagarVisitante(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          otherParameters: {
            "tipo": visitant.type ?? "",
          });
    });
  }

  Future<void> deleteVisit(
      {required String recurrenceId,
      required AccessControl visitant,
      required AccessControlAuthorizations authorizations}) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );
    final response = await deleteScheduled.call(
      DeleteVisitParam(
        recurrenceId: recurrenceId,
      ),
    );
    response.fold(
        (error) => bloc.add(
              DeleteFailureVisitEvent(
                  visitants: visitants,
                  providers: providers,
                  visitant: visitant,
                  model: authorizations),
            ), (res) {
      bloc.add(
        DeleteVisitEvent(isVisitant: visitant.prestador == false),
      );
      OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner
              .autorizacaoEntradasAcessarAgendamentosApagar(),
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          userId: sessionBloc.state.session?.me?.id ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          otherParameters: {
            "tipo": visitant.type ?? "",
          });
    });
  }

  Future<void> visitantSearch(
      {required String name,
      required List<AccessControl> visitant,
      required bool isProvider}) async {
    if (name.isEmpty) return;

    String searchName = name.toLowerCase().trim();
    List<AccessControl> specificList = isProvider ? providers : visitants;
    List<AccessControl> listWithDocument =
        specificList.where((element) => element.document != null).toList();
    List<AccessControl> searchList = specificList
        .where((element) =>
            element.name!.toLowerCase().trim().contains(searchName))
        .toList();

    if (searchList.isEmpty && listWithDocument.isNotEmpty) {
      searchList = listWithDocument
          .where((element) =>
              element.document!.toLowerCase().trim().contains(searchName))
          .toList();
    }

    if (isProvider) {
      bloc.add(SearchingProviderEvent(
          visitants: visitants,
          providers: searchList.isEmpty ? [] : searchList));
    } else {
      bloc.add(SearchingVisitantEvent(
          visitants: searchList.isEmpty ? [] : searchList,
          providers: providers));
    }
  }

  Future<void> sendInviteAccess(
      {required AccessControl visitant,
      required AccessControlAuthorizations authorizations}) async {
    bloc.add(
      AccessControlLoadingEvent(),
    );

    var responseSendInvite = await sendInvite.call(
      SendInviteParam(
        body: AccessControlSendInviteEntity(
            cpf: visitant.document?.replaceAll(RegExp(r'[^0-9]'), ''),
            forwardType: AccessControlInviteForwardType.sms,
            foreignDocument: visitant.foreignDocument,
            foreignDocumentType: visitant.typeDocument,
            name: visitant.name,
            phone: visitant.phone?.replaceAll(RegExp(r'[^0-9]'), ''),
            userType: visitant.type == "GEST"
                ? AccessControlInviteUserType.gest
                : AccessControlInviteUserType.serviceprovider),
      ),
    );

    responseSendInvite.fold(
      (error) => bloc.add(
        SaveVisitantFailureEvent(
          visitants: visitants,
          providers: providers,
          visitant: visitant,
          model: authorizations,
          failureInvite: true,
        ),
      ),
      (res) => bloc.add(
        SaveVisitantLoadedEvent(
          visitants: visitants,
          providers: providers,
          isVisitant: visitant.type == "GEST",
          useFacial: authorizations.useFacialBiometric ?? false,
          link: res,
        ),
      ),
    );
  }
}
