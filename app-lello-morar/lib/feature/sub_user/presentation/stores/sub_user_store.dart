import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:image/image.dart' as img;
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/use_case/facial_biometric/facial_biometric_usecase.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service.dart';
import 'package:morar/feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_roles/sub_user_roles.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_access_renew_reques_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_add_bloc.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/dependency/application_container.dart';
import '../../../../core/stores/remote_config_store.dart';
import '../../domain/entity/sub_user_role.dart';
import '../bloc/sub_user_edit_bloc.dart';

class SubUserStore {
  final SubUsersBloc bloc;
  final SubUserAddBloc addBloc;
  final SubUserEditBloc editBloc;
  final SubUserUseCase subUserUseCase;
  final UpdateSubUser updateSubUser;
  final InsertSubUser insertSubUser;
  final SubUserRoleCase subUserRoleCase;
  final SessionBloc sessionBloc;
  final SubUserCheckServiceCase checkServiceCase;
  final FacialBiometricUsecase facialBiometricUsecase;
  final SendInviteUsecase sendInviteUsecase;
  final GetImageFromCameraViewPickerUsecase getImageFromCameraViewPickerUsecase;
  final MeController meController;
  final SendAccessRenewRequestUseCase sendAccessRenewRequestUseCase;
  final GetPendingRequestsUseCase getPendingRequestsUseCase;
  final UpdateAccessRequestUseCase updateAccessRequestUseCase;
  final DeleteSubUser deleteSubUser;

  SubUserStore({
    required this.addBloc,
    required this.bloc,
    required this.editBloc,
    required this.subUserUseCase,
    required this.sessionBloc,
    required this.updateSubUser,
    required this.insertSubUser,
    required this.subUserRoleCase,
    required this.checkServiceCase,
    required this.facialBiometricUsecase,
    required this.sendInviteUsecase,
    required this.getImageFromCameraViewPickerUsecase,
    required this.meController,
    required this.sendAccessRenewRequestUseCase,
    required this.getPendingRequestsUseCase,
    required this.updateAccessRequestUseCase,
    required this.deleteSubUser,
  });

  late SubUser mainUser;

  Future<List<SubUser>> getSubUsers() async {
    bloc.add(SubUserLoadingEvent());

    if (sessionBloc.state.session?.unity?.id == null) {
      bloc.add(SubUserErrorEvent(error: null));
      return [];
    }
    meController.originalMe = sessionBloc.state.session!.me!;
    final unitId = sessionBloc.state.session!.unity!.id!;
    final response =
        await subUserUseCase.call(GetSubUserParams(unityId: unitId));
    final pendingRequestsResponse = await getPendingRequestsUseCase(unitId);

    final List<PendingRequestEntity> pending =
        pendingRequestsResponse.fold((error) {
      return [];
    }, (success) {
      return success;
    });

    return response.fold((error) {
      bloc.add(SubUserErrorEvent(error: error));
      return [];
    }, (list) {
      list.forEach((element) {
        element =
            element.copyWith(unitId: sessionBloc.state.session!.unity!.id);
      });
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.moradoresAcessar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      if (list.first.mainUser) {
        FirebaseAnalytics.instance.logEvent(
          name: "morar_moradores_principal_read",
          parameters: {
            "tipo": "read",
            "qtd": list.length,
          },
        );
      } else {
        FirebaseAnalytics.instance.logEvent(
          name: "morar_moradores_outros_read",
          parameters: {
            "tipo": "read",
            "qtd": list.length,
          },
        );
      }

      bloc.add(SubUserLoadedEvent(subUsers: list, pendingRequests: pending));
      return list;
    });
  }

  Future<SubUser?> subUserUpdate({
    required SubUser userSelected,
    bool isBlock = false,
    bool isUseApp = false,
    DateTime? expirationDate,
  }) async {
    editBloc.add(SubUserEditLoadingEvent());

    if (isBlock) {
      userSelected = userSelected.copyWith(
          blocked: !userSelected.blocked!, expiresAt: expirationDate);
    }
    if (isUseApp) {
      userSelected = userSelected.copyWith(
          useApp: !userSelected.useApp!, expiresAt: expirationDate);
    }
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.moradoresAcessarEditarBloquear(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );

    final updateUser = userSelected.copyWith(
      cpf: userSelected.cpf!.replaceAll(RegExp(r'[^0-9]'), ''),
      role: userSelected.role,
      unitId: sessionBloc.state.session!.unity!.id!,
      mainUser: false,
      expiresAt: expirationDate,
    );

    final response =
        await updateSubUser.call(UpdateSubUserParams(subUser: updateUser));

    return response.fold((error) {
      editBloc.add(SubUserEditErrorEvent());
      return null;
    }, (data) {
      if (isBlock) {
        editBloc.add(SubUserEditConcludeEvent(subUser: updateUser));
      } else {
        editBloc.add(SubUserEditSuccessEvent(subUser: updateUser));
      }
      return updateUser;
    });
  }

  Future<List<SubUser>> getContacts({required List<SubUser> contacts}) async {
    addBloc.add(SubUserAddLoadingEvent());

    if (contacts.isEmpty) {
      final response = await _askPermissions();

      if (response.isEmpty) {
        addBloc.add(SubUserAddErrorEvent());
      } else {
        response.forEach((element) {
          element = element.copyWith(blocked: false);
        });
        contacts = response;
        addBloc.add(SubUserAddSuccessEvent(subUsers: contacts));
      }
    } else {
      addBloc.add(SubUserAddSuccessEvent(subUsers: contacts));
    }
    return contacts;
  }

  Future<List<SubUserRole>> getRoles({required SubUser subUser}) async {
    if (sessionBloc.state.session == null) {
      return [];
    }

    final response = await subUserRoleCase.call(sessionBloc.state.session!);
    List<SubUserRole> roles = [];
    response.fold((error) {}, (list) {
      list.forEach((element) {
        roles.add(element);
      });

      return roles;
    });
    return roles;
  }

  Future<void> inviteResident({required SubUser creationUser}) async {
    bloc.add(SubUserInviteResidentLoadingEvent());

    SubUser newSubUser = creationUser.copyWith(
        cpf: creationUser.cpf!.replaceAll(RegExp(r'[^0-9]'), ''),
        unitId: sessionBloc.state.session!.unity!.id,
        role: creationUser.role,
        registered: false,
        expiresAt: creationUser.expiresAt,
        phone: creationUser.phone,
        email: creationUser.email,
        name: creationUser.name,
        mainUser: false,
        blocked: false,
        useApp: true,
        creator: ConciergeCreator(
          id: sessionBloc.state.session?.me?.id,
          name: sessionBloc.state.session?.me?.name,
          type: ConciergeCreatorType.appmorar,
        ));

    final response =
        await insertSubUser.call(InsertSubUserParam(subUser: newSubUser));

    response.fold((error) {
      bloc.add(SubUserInviteResidentFailureEvent(
          subUser: creationUser, failure: error));
    }, (data) async {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.moradoresAdicionarNovoUsuarioSucesso(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );

      bloc.add(SubUserInviteResidentSuccessEvent());
      await _shareWhatsapp(newSubUser.phone!, newSubUser.name!);
    });
  }

  // Future<List<String>> getRolesFromSubuser({required SubUser editUser}) async {
  //   editBloc.add(SubUserEditLoadingEvent());

  //   if (sessionBloc.state.session == null) {
  //     editBloc.add(SubUserEditErrorEvent());
  //     return [];
  //   }

  //   final response = await subUserRoleCase.call(sessionBloc.state.session!);

  //   response.fold(
  //     (error) => editBloc.add(SubUserEditErrorEvent()),
  //     (list) {
  //       List<String> descriptions = [];
  //       for (var element in list) {
  //         if (element.role == "morar.morador" &&
  //             sessionBloc
  //                 .checkRback(ApplicationRbac.morarMoradoresPrincipalWrite))
  //           descriptions.add(element.description!);
  //         if (element.role != "morar.morador" &&
  //             sessionBloc.checkRback(ApplicationRbac.morarMoradoresOutrosWrite))
  //           descriptions.add(element.description!);
  //       }
  //       OwnerAnalyticsLogEvents.logEvent(
  //         event: AnalyticsEventsOwner.moradoresAcessarEditar(),
  //         unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
  //         referenceValue:
  //             sessionBloc.state.session!.condominium?.reference?.toString() ??
  //                 "",
  //       );

  //       editBloc.add(SubUserEditLoadedEvent());
  //       return descriptions;
  //     },
  //   );
  //   return [];
  // }

  Future<void> checkService() async {
    bloc.add(SubUserLoadingEvent());

    final response = await checkServiceCase.call(GetSubUserCheckServiceParams(
        reference: sessionBloc.state.session?.condominium?.reference ?? ""));

    response.fold(
      (error) => bloc.add(SubUserServiceOffEvent()),
      (success) => success.condominiumActive
          ? bloc.add(SubUserServiceOnEvent())
          : bloc.add(SubUserServiceOffEvent()),
    );
  }

  Future<void> getFacialBiometric() async {
    var cameras = await availableCameras();
    final image = await handleUseCase(
      getImageFromCameraViewPickerUsecase,
      ParamsGetImageFromCameraViewPickerUsecase(
        context: navigatorKey.currentState!.context,
        cameras: cameras,
        captureEnum: TypeCaptureEnum.automatic,
      ),
    );
    if (image != null && image.file != null) {
      bloc.add(SubUserFacialLoadingEvent());

      File? file = await _convertFile(image.file!);

      if (file == null) {
        bloc.add(SubUserFacialErrorEvent());
        return;
      }

      final response =
          await facialBiometricUsecase.call(FacialBiometricParam(file: file));

      response.fold(
        (error) => bloc.add(SubUserFacialErrorEvent()),
        (response) => response.success == true
            ? bloc.add(SubUserFacialLoadedEvent())
            : bloc.add(
                SubUserFacialErrorEvent(
                  message: response.message,
                  code: response.codigo,
                ),
              ),
      );
    }
  }

  Future<void> subUserSendInviteFromList({
    required AccessControlSendInviteEntity body,
  }) async {
    bloc.add(SubUserLoadingEvent());

    final response = await sendInviteUsecase.call(SendInviteParam(body: body));

    response.fold(
      (error) => bloc.add(SubUserSendInviteErrorEvent()),
      (success) => bloc.add(SubUserSendInviteLoadedEvent()),
    );
  }

  Future<void> subUserSendInvite({
    required AccessControlSendInviteEntity body,
    required bool isEdit,
  }) async {
    if (isEdit) {
      editBloc.add(SubUserEditLoadingEvent());
    } else {
      bloc.add(SubUserLoadingEvent());
    }

    final response = await sendInviteUsecase.call(SendInviteParam(body: body));

    return response.fold(
      (error) {
        if (isEdit) {
          editBloc.add(SubUserEditSendInviteErrorEvent());
        } else {
          bloc.add(SubUserSendInviteErrorEvent());
        }
      },
      (success) {
        if (isEdit) {
          editBloc.add(SubUserEditSendInviteSuccessEvent());
        } else {
          bloc.add(SubUserSendInviteLoadedEvent());
        }
      },
    );
  }

  Future<List<SubUser>> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    List<SubUser> contacts = [];

    if (permissionStatus == PermissionStatus.granted) {
      var list = await FlutterContacts.getAll();

      contacts = list
          .where((e) => e.displayName?.isNotEmpty ?? false)
          .map((e) {
        String phone = "";
        if (e.phones.isNotEmpty) {
          phone = e.phones[0].number;
        }

        return SubUser(
          name: e.displayName!,
          phone: phone,
        );
      }).toList();
    }

    return contacts;
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> _shareWhatsapp(String phone, String name) async {
    try {
      final remoteConfigStore =
          ApplicationContainer.instance().resolve<RemoteConfigStore>();
      await remoteConfigStore.remoteConfig.fetch();
      await remoteConfigStore.remoteConfig.fetchAndActivate();
      var appLinkConfig = jsonDecode(remoteConfigStore.remoteConfig
          .getString(CustomFirebaseRemoteConfig.appStoreLink));

      String appLink = appLinkConfig["link"];
      String appLinkName = appLinkConfig["name"];
      var content =
          "Olá $name. Você recebeu um convite de ${sessionBloc.state.session!.me!.name} para acessar o $appLinkName, seu canal direto a tudo relacionado ao seu condomínio. Basta acessar o link e baixar o aplicativo na loja do seu celular. Conta comigo! $appLink";

      await shareText(content);
    } catch (ex) {}
  }

  Future<File?> _convertFile(XFile xFile) async {
    String id = DateFormat("dd_MM_yyyy_HH_mm_ss").format(DateTime.now());
    if (await CheckPermissions.storage()) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final Uint8List bytes = await xFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return null;
      }
      File fileConverted =
          await File("$dir/$id.jpg").writeAsBytes(img.encodeJpg(image));
      return fileConverted;
    }
    return null;
  }

  bool get condoUseFacialBiometric =>
      sessionBloc.state.session?.condominium?.useFacialBiometric ?? false;

  bool get useFacialBiometric =>
      sessionBloc.state.session?.me?.useFacialBiometric ?? false;

  String get biometricImageLink =>
      sessionBloc.state.session?.me?.biometriaImageLink ?? "";

  String getFormattedName({required String? fullName}) {
    if (fullName == null || fullName.isEmpty) {
      return "";
    }

    List<String> names = fullName
        .split(' ')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();

    if (names.isEmpty) {
      return "";
    }

    if (names.length == 1) return names.first;

    String firstName = names.first;
    String lastName = names.last;

    return '$firstName $lastName';
  }

  void updateMe() async {
    await meController.mapSave();
  }

  Future<bool> sendAccessRenewRequest() async {
    final List<SubUser> subUsers = bloc.state is SubUserLoadedState
        ? (bloc.state as SubUserLoadedState).subUsers
        : [];
    final List<PendingRequestEntity> pending = bloc.state is SubUserLoadedState
        ? (bloc.state as SubUserLoadedState).pendingRequests
        : [];
    bloc.add(SubUserLoadingEvent());
    final unitId = sessionBloc.state.session!.unity!.id;
    final response = await sendAccessRenewRequestUseCase.call(unitId ?? '');
    return response.fold((error) {
      bloc.add(SubUserErrorEvent(error: error));
      return false;
    }, (success) {
      bloc.add(
        SubUserLoadedEvent(
          subUsers: subUsers,
          pendingRequests: pending,
        ),
      );
      return true;
    });
  }

  Future<bool> updateAccessRequestStatus(
      UpdateAccessRequestStatusParams params) async {
    bloc.add(UpdateStatusRequestLoadingEvent());
    final response = await updateAccessRequestUseCase.call(params);

    return response.fold(
      (error) {
        bloc.add(UpdateAccessStatusRequestErrorState(error: error));
        return false;
      },
      (success) async {
        bloc.add(
          UpdateAccessStatusRequestSuccessState(status: params.status),
        );
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        getSubUsers();
        return true;
      },
    );
  }

  Future<bool> deleteSubUserByUnitId(String unitId, String cpfCnpj) async {
    editBloc.add(SubUserDeleteLoadingEvent());

    final response = await deleteSubUser.call(
      DeleteSubUserParams(unitId: unitId, cpfCnpj: cpfCnpj),
    );

    return response.fold((error) {
      editBloc.add(SubUserDeleteErrorEvent(error: error));
      throw error;
    }, (success) {
      editBloc.add(
        SubUserDeleteSuccessEvent(
          unitId: unitId,
        ),
      );
      return success;
    });
  }
}
