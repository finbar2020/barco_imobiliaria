import 'dart:developer' as developer;
import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:lello/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:lello/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:lello/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:lello/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:lello/feature/me/presentation/bloc/me_bloc.dart';
import 'package:lello/feature/me/presentation/bloc/me_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_event.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

class MeController {
  final SessionBloc sessionBloc;
  final MeBloc meBloc;
  final GetMe getMeUseCase;
  final LogMeOut logMeOut;
  final AuthenticationStore authenticationStore;
  final SaveMe saveMeUseCase;
  final UpdatePasswordMe updatePasswordMeUseCase;
  final UploadProfilePicture uploadProfilePictureUseCase;
  final GetDados2fa getDados2faUseCase;
  final Request2fa request2faUseCase;
  final DeleteAccount deleteUserUseCase;
  final DisableFcm disableFcm;
  final ConsultantUseCase getConsultantUseCase;

  MeController({
    required this.getMeUseCase,
    required this.meBloc,
    required this.sessionBloc,
    required this.logMeOut,
    required this.authenticationStore,
    required this.saveMeUseCase,
    required this.getDados2faUseCase,
    required this.request2faUseCase,
    required this.uploadProfilePictureUseCase,
    required this.updatePasswordMeUseCase,
    required this.deleteUserUseCase,
    required this.disableFcm,
    required this.getConsultantUseCase,
  });

  Me? me;
  CodeRequest? codeRequest;
  String? version;
  ConsultantEntity? consultantEntity;

  String name = '';
  String email = '';
  String phone = '';
  String ddd = '';

  bool isChangingPhone = false;
  bool isChangingEmail = false;

  Future<void> pipeline() async {
    await getLastSwitchRolesUpdate();
    await getLastGetMeUpdate();
    await getVersion();
    await getMe(forceUpdate: true);
  }

  Future<void> getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = "v${packageInfo.version}";
  }

  Future<void> getMe({required bool forceUpdate}) async {
    meBloc.add(
      MeLoadingEvent(),
    );
    if (!forceUpdate) {
      final cache = await getMeUseCase(DataOrigin.local);
      if (cache is Success<Me?>) {
        final Me? localMe = cache.get();
        if (localMe != null) {
          meBloc.add(
            MeLoadedCacheEvent(me: localMe),
          );
        }
      }
    }

    final remote = await getMeUseCase(DataOrigin.remote);

    remote.fold(
      (error) => meBloc.add(MeLoadFailedEvent(failure: error)),
      (response) {
        sessionBloc.updateMe(response);
        me = response;
        ddd = (response?.phone?.isEmpty ?? false)
            ? response?.phone ?? ""
            : response?.phone?.substring(0, 2) ?? "";
        phone = (response?.phone?.isEmpty ?? false)
            ? response?.phone ?? ""
            : response?.phone?.substring(2) ?? "";

        email = response?.email ?? "";
        name = response?.name ?? "";
        meBloc.add(MeLoadedEvent(me: response));
      },
    );

    String reference =
        sessionBloc.state.session!.selectedCondominium?.reference.toString() ??
            "";
    ManagerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.homePerfilAcessar(),
        referenceValue: reference);
  }

  Future<void> getConsultant({required bool forceUpdate}) async {

    final remote = await getConsultantUseCase(ConsultantParms(condominiumId: '1'));

    remote.fold(
          (error) => sessionBloc.add(SessionFailureEvent(error)),
          (response) {
        consultantEntity = response;
        sessionBloc.getConsultor(response);
      },
    );
  }

  Future<void> accountLogout() async {
    final result = await logMeOut();
    if (result is Success) {
      meBloc.add(LogMeOutEvent());
    }
  }

  //Delete
  Future<void> deleteUserAccount({required Me me}) async {
    meBloc.add(MeDeleteLoadingEvent());
    await disableFcm.call();
    final response = await deleteUserUseCase.call();

    response.fold(
      (error) => meBloc.add(MeDeleteAccountFailedEvent(failure: error)),
      (result) => meBloc.add(
        MeDeleteAccountSuccessEvent(),
      ),
    );
  }

  //Edit

  Future<void> beginEdit() async {
    final copy = Me.clone(me!);
    meBloc.add(
      MeEditEvent(me: copy),
    );
  }

  Future<void> beginEditSavePassword(
      {required String? password, required String? originPassword}) async {
    final copy = Me.clone(me!);
    meBloc.add(
      MeEditPasswordLoadingEvent(),
    );

    final result = await updatePasswordMeUseCase.call(UpdatePasswordMeParam(
        originPassword: originPassword!,
        password: password!,
        cpf: copy.cpf ?? ""));

    result.fold(
      (err) => meBloc.add(
        MeEditPasswordFailedEvent(failure: err),
      ),
      (res) => meBloc.add(
        MeEditSucceededEvent(),
      ),
    );
  }

  Future<void> resendToken() async {
    meBloc.add(MeEditPhoneChangedEvent(
        isChangingEmail: _isChangingEmail, isChangingPhone: _isChangingPhone));
  }

  void cancelValidation() {
    isChangingPhone = false;
    isChangingEmail = false;
  }

  Future<void> saveAccount({
    required CodeValidation? codeValidation,
  }) async {
    developer.log("saveAccount called with codeValidation: $codeValidation");
    if (changePhone && !isChangingPhone) {
      isChangingPhone = true;
      meBloc.add(MeEditPhoneChangedEvent(isChangingPhone: true));
    } else if (changeEmail && !isChangingEmail) {
      isChangingEmail = true;
      meBloc.add(MeEditPhoneChangedEvent(isChangingEmail: true));
    } else {
      isChangingPhone = false;
      isChangingEmail = false;
      if (codeValidation != null) {
        developer.log("Saving account with new phone: $completePhone");
        await save(
          me: me!.copyWith(
            name: name,
            email: email,
            phone: completePhone,
          ),
          codeValidation: codeValidation,
          codeRequest: codeRequest,
        );
      }
    }
  }

  Future<void> save({
    required Me me,
    CodeRequest? codeRequest,
    CodeValidation? codeValidation,
    bool isChangingPhoto = false,
  }) async {
    print("save called with me: ${me.phone}");
    if (isChangingPhoto) {
      meBloc.add(MeLoadingEvent());
    } else {
      meBloc.add(MeEditLoadingEvent());
    }

    final result = await saveMeUseCase.call(
      SaveMeParam(
        me: me,
        originalMe: me,
        codeValidation: codeValidation,
      ),
    );

    result.fold(
      (err) {
        print("Save failed with error: $err");
        cancelValidation();
        meBloc.add(MeEditFailedEvent(failure: err));
      },
      (res) {
        print("Save succeeded");
        String reference = sessionBloc
                .state.session!.selectedCondominium?.reference
                .toString() ??
            "";
        ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.homePerfilEditarFinalizado(),
          referenceValue: reference,
        );

        meBloc.add(MeEditSucceededEvent());
      },
    );

    sessionBloc.updateMe(me);
  }

  bool _isChangingPhone = false;
  bool _isChangingEmail = false;
  Future<void> requestValidationCode(
      {bool? isChangingPhone, bool? isChangingEmail}) async {
    if (isChangingPhone != null) {
      _isChangingPhone = isChangingPhone;
    }
    if (isChangingEmail != null) {
      _isChangingEmail = isChangingEmail;
    }
    meBloc.add(
      MeEditRequestingCodeEvent(),
    );

    final cpf = (me?.cpf ?? "").replaceAll(RegExp(r'[^0-9]'), "");
    final result = await getDados2faUseCase.call(
      CodeDataParam(cpf: cpf, idEmpresa: FlavorConfig.config.idEmpresa),
    );

    await result.fold(
      (err) async {
        meBloc.add(MeEditRequestCodeFailedEvent(failure: err));
      },
      (res) async {
        final source = _isChangingPhone
            ? CodeValidationSource.phone
            : CodeValidationSource.email;
        final contacts =
            _isChangingPhone ? res.smsContacts : res.emailContacts;

        if (contacts.isEmpty) {
          meBloc.add(MeEditNoContactAvailableEvent());
          return;
        }

        final selectedContact = _getPreferredContact(
          contacts: contacts,
          source: source,
          currentValue: _isChangingPhone ? completePhone : email,
        );

        final appSignature = await SmsAutoFill().getAppSignature;
        final request2faResult = await request2faUseCase.call(
          Tequest2faParam(
            id: selectedContact.key,
            appSignature: appSignature,
          ),
        );

        request2faResult.fold(
          (err) {
            meBloc.add(MeEditRequestCodeFailedEvent(failure: err));
          },
          (res) {
            codeRequest = CodeRequest(
              origin: CodeValidationOrigin.changeNumber,
              source: source,
              value: selectedContact.value,
              // Neste fluxo, o código é enviado e validado via 2FA em etapa posterior.
              token: "",
              cpf: cpf,
              id: selectedContact.key,
            );
            meBloc.add(MeEditValidateCodeEvent());
          },
        );
      },
    );
  }

  CodeDataContact _getPreferredContact({
    required List<CodeDataContact> contacts,
    required CodeValidationSource source,
    required String currentValue,
  }) {
    if (contacts.length == 1) {
      return contacts.first;
    }

    final normalizedCurrent = _normalize(currentValue, source);

    for (final contact in contacts) {
      final normalizedContact = _normalize(contact.value, source);
      if (normalizedCurrent.isNotEmpty &&
          normalizedCurrent == normalizedContact) {
        return contact;
      }
    }

    if (source == CodeValidationSource.phone) {
      final currentDigits = normalizedCurrent;
      if (currentDigits.length >= 4) {
        final currentSuffix = currentDigits.substring(currentDigits.length - 4);
        for (final contact in contacts) {
          final contactDigits = _normalize(contact.value, source);
          if (contactDigits.endsWith(currentSuffix)) {
            return contact;
          }
        }
      }
    }

    return contacts.first;
  }

  String _normalize(String value, CodeValidationSource source) {
    if (source == CodeValidationSource.phone) {
      return value.replaceAll(RegExp(r'[^0-9]'), '');
    }
    return value.trim().toLowerCase();
  }

  Future<void> choosePhoto({required ImageSource imageSource}) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      CroppedFile? croppedFile = await showProfileImageCropper(image.path,
          maxHeight: 400, maxWidth: 400);
      if (croppedFile != null) {
        me = me?.copyWith(pictureFile: File(croppedFile.path));
        meBloc.add(
          MeLoadingEvent(),
        );
        final result =
            await uploadProfilePictureUseCase.call(File(croppedFile.path));

        result.fold(
          (err) => meBloc.add(MeUploadProfileFailedEvent(failure: err)),
          (res) async {
            await save(
              me: me!,
              isChangingPhoto: true,
            );
            await getMe(forceUpdate: true);
          },
        );
      }
    }
  }

  String lastSwitchRolesUpdateDifference = "";
  String lastGetMeUpdateDifference = "";

  Future<void> getLastSwitchRolesUpdate() async {
    var preferences = await SharedPreferences.getInstance();
    final String? lastSwitchRolesString =
        preferences.getString(SharedPreferencesKeys.lastSwitchRoles);
    if (lastSwitchRolesString != null) {
      DateTime lastSwitchRoles = DateTime.parse(lastSwitchRolesString);

      lastSwitchRolesUpdateDifference =
          "-${DateTime.now().difference(lastSwitchRoles).inSeconds.toString()}";
    }
  }

  Future<void> getLastGetMeUpdate() async {
    DateFormat dateFormat = DateFormat("MMdd");
    String nowString = dateFormat.format(DateTime.now());
    var preferences = await SharedPreferences.getInstance();
    final String? lastGetMeString =
        preferences.getString(SharedPreferencesKeys.managerLastGetMe);
    if (lastGetMeString != null) {
      DateTime lastGetMeUpdate = DateTime.parse(lastGetMeString);
      Duration diference = DateTime.now().difference(lastGetMeUpdate);
      lastGetMeUpdateDifference =
          "$nowString-${diference.inSeconds.toString()}";

      lastGetMeUpdateDifference =
          "$nowString-${diference.inSeconds.toString()}";
    }
  }

  Future<void> logout() async {
    meBloc.add(MeLoadingEvent());
    if (authenticationStore.bloc.state is AuthenticatedState) {
      await disableFcm.call();
    }
    final result = await logMeOut();

    result.fold(
      (failure) => failure,
      (success) {
        sessionBloc.logout();
        authenticationStore.logout();
        meBloc.add(
          MeUnauthenticatedEvent(),
        );
      },
    );
  }

  void dispose() {
    meBloc.add(MeEmptyEvent());
  }

  bool get mustSave {
    if ((name != me!.name) ||
        (email != me!.email) ||
        (completePhone != me!.phone!)) {
      return true;
    }
    return false;
  }

  bool get changePhone => completePhone != me?.phone;
  bool get changeEmail => email != me?.email;

  String get completePhone => "$ddd$phone";

  String get requestPhone => "($ddd)$phone";
}
