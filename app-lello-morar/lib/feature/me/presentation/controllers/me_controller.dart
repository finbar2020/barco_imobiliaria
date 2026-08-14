import 'dart:io';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:morar/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:morar/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:morar/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/bloc/me_event.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

class MeController {
  final MeBloc bloc;
  final GetMe getMe;
  final SaveMe saveMe;
  final UpdatePasswordMe updatePasswordMe;
  final SessionBloc sessionBloc;
  final UploadProfilePicture uploadProfilePicture;
  final GetDados2fa getDados2faUseCase;
  final Request2fa request2faUseCase;
  final AuthenticationBloc authenticationBloc;
  final AuthenticationStore authStore;
  final LogMeOut logMeOut;
  final DeleteAccount deleteAccountUser;
  final DisableFcm disableFcm;
  final baseUrl;

  MeController(
      {required this.bloc,
      required this.getMe,
      required this.saveMe,
      required this.sessionBloc,
      required this.getDados2faUseCase,
      required this.request2faUseCase,
      required this.uploadProfilePicture,
      required this.updatePasswordMe,
      required this.authenticationBloc,
      required this.authStore,
      required this.logMeOut,
      required this.deleteAccountUser,
      required this.disableFcm,
      required this.baseUrl}) {
    //logar no console a troca de estados e eventos
    bloc.stream.listen((event) {
      print("MeEventChange: $event");
    });
  }

  Me? originalMe;

  Future<void> meLoad({bool forceUpdate = false}) async {
    bool loadedFromCache = false;
    Me? localMe;
    bloc.add(MeLoadingEvent(bloc.state.me));
    if (forceUpdate == false) {
      final cache = await getMe.call(DataOrigin.local);
      if (cache is Success<Me?>) {
        localMe = cache.get();
        if (localMe != null) {
          loadedFromCache = true;
          originalMe = localMe;
          bloc.add(MeLoadedCacheEvent(me: localMe));
        }
      }
    }

    if (!loadedFromCache ||
        localMe?.lastUpdatedAt == null ||
        (loadedFromCache && localMe!.hasToUpdate)) {
      final remote = await getMe.call(DataOrigin.remote);
      remote.fold((err) {
        if (!loadedFromCache) {
          bloc.add(MeLoadFailedEvent(bloc.state.me, err));
        } else
          bloc.add(MeLoadedCacheEvent(me: localMe!));
      }, (me) {
        if (me != null) {
          sessionBloc.updateMe(me);
          originalMe = me;
          bloc.add(MeLoadedEvent(me));
        } else {
          bloc.add(MeLoadedEvent(bloc.state.me));
        }
      });
    }
  }

  Future<void> beginEdit() async {
    bloc.add(MeEditLoadingEvent(me: bloc.state.me));
    final copy = Me.clone(bloc.state.me);
    bloc.add(MeEditLoadedEvent(me: copy));
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.edicaoCadastroAcessar(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
  }

  Future<void> beginEditPassword() async {
    final copy = Me.clone(bloc.state.me);
    bloc.add(MeEditPasswordEvent(copy, "", ""));
  }

  Future<void> beginEditSavePassword(
      String originPassword, String password) async {
    final copy = Me.clone(bloc.state.me);
    print("PASSWORDS => $originPassword - $password");
    bloc.add(
        MeEditPasswordLoadingEvent(bloc.state.me, originPassword, password));
    final result = await updatePasswordMe.call(UpdatePasswordMeParam(
        originPassword: originPassword, password: password, cpf: copy.cpf!));

    result.fold(
      (err) => bloc.add(MeEditPasswordFailedEvent(
          bloc.state.me, originPassword, password, err)),
      (res) {
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.redefinirSenha(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
        bloc.add(MeEditSucceededEvent(me: copy));
      },
    );
  }

  void revertEdit() {
    if (originalMe != null) {
      bloc.add(MeLoadedEvent(originalMe!));
    }
  }

  Future<void> mapSave({CodeValidation? codeValidation}) async {
    final editState = bloc.state;
    if (originalMe != null && editState is MeEditState) {
      final me = editState.me;
      final codeRequest = editState.codeRequest;
      final needsCodeRequestPhone =
          me.phone?.replaceAll(RegExp(r'[^\d]'), '') !=
              originalMe?.phone?.replaceAll(RegExp(r'[^\d]'), '');
      final needsCodeRequestEmail = me.email != originalMe!.email;

      if (needsCodeRequestPhone && codeRequest == null) {
        bloc.add(MeEditPhoneChangedEvent(me));
      } else if (needsCodeRequestEmail &&
          (codeRequest == null ||
              codeRequest.source == CodeValidationSource.phone)) {
        bloc.add(MeEditEmailChangedEvent(me));
      } else {
        _save(me, codeRequest, codeValidation);
      }
    } else if (editState is MeUploadProfileSucceededState) {
      final me = editState.me;
      _save(me, null, null);
    }
  }

  bool _isPhoneCheck = true;
  bool _isEmailCheck = false;

  Future<void> validationCode(
      {required bool isPhoneCheck, required bool isEmailCheck}) async {
    _isPhoneCheck = isPhoneCheck;
    _isEmailCheck = isEmailCheck;
    final newMe = bloc.state.me;
    bloc.add(MeEditRequestingCodeEvent(newMe));

    final cpf = (newMe.cpf ?? "").replaceAll(RegExp(r'[^0-9]'), "");
    final result = await getDados2faUseCase.call(
      CodeDataParam(cpf: cpf, idEmpresa: FlavorConfig.config.idEmpresa),
    );

    await result.fold(
      (err) async => bloc.add(MeEditRequestingCodeFailedEvent(newMe, err)),
      (res) async {
        final source = isPhoneCheck
            ? CodeValidationSource.phone
            : CodeValidationSource.email;
        final contacts = isPhoneCheck ? res.smsContacts : res.emailContacts;

        if (contacts.isEmpty) {
          bloc.add(MeEditNoContactAvailableEvent(newMe));
          return;
        }

        final selectedContact = _getPreferredContact(
          contacts: contacts,
          source: source,
          currentValue: (isPhoneCheck ? newMe.phone : newMe.email) ?? "",
        );

        final appSignature = await SmsAutoFill().getAppSignature;
        final request2faResult = await request2faUseCase.call(
          Tequest2faParam(
            id: selectedContact.key,
            appSignature: appSignature,
          ),
        );

        request2faResult.fold(
          (err) => bloc.add(MeEditRequestingCodeFailedEvent(newMe, err)),
          (ok) {
            final request = CodeRequest(
              source: source,
              origin: CodeValidationOrigin.changeNumber,
              value: selectedContact.value,
              // Neste fluxo, o código é enviado e validado via 2FA em etapa posterior.
              token: "",
              cpf: cpf,
              id: selectedContact.key,
            );
            bloc.add(MeEditValidateCodeSuccessEvent(newMe, request));
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

  Future<void> chooseImageEvent(ImageSource source) async {
    ImagePicker imagePicker = new ImagePicker();
    var image = await imagePicker.pickImage(source: source);
    if (image != null) {
      CroppedFile? croppedFile = await showProfileImageCropper(image.path,
          maxHeight: 400, maxWidth: 400);
      if (croppedFile != null) {
        bloc.add(MeLoadingEvent(bloc.state.me));
        Me me = bloc.state.me;
        final result = await uploadProfilePicture.call(File(croppedFile.path));

        result.fold((err) => bloc.add(MeUploadProfileFailedEvent(me, err)),
            (res) async {
          bloc.add(MeUploadProfileSucceededEvent(me));
          sessionBloc.updateMe(me);
          await Future.delayed(Duration(seconds: 2));
          await mapSave();
        });
      }
    }
  }

  Future<void> logOutEvent() async {
    bloc.add(MeLoadingEvent(bloc.state.me));
    await disableFcm.call();
    sessionBloc.logout();
    await authStore.logout();
    final result = await logMeOut();
    if (result is Success) {
      bloc.add(MeUnauthenticatedEvent(bloc.state.me));
    }
  }

  Future<void> resendToken() async {
    final editState = bloc.state;
    if (originalMe != null && editState is MeEditState) {
      final me = editState.me;
      bloc.add(MeEditPhoneChangedEvent(me));
      validationCode(isPhoneCheck: _isPhoneCheck, isEmailCheck: _isEmailCheck);
    }
  }

  Future<void> deleteMe(Me me) async {
    bloc.add(MeEditLoadingEvent(me: me));

    await disableFcm.call();
    final response = await deleteAccountUser.call();

    response.fold((l) => bloc.add(MeDeleteFailedEvent(me: me)),
        (r) => bloc.add(MeDeleteSuccessEvent(me: me)));
  }

  Future<void> _save(
      Me me, CodeRequest? codeRequest, CodeValidation? codeValidation) async {
    bloc.add(MeEditLoadingEvent(
        me: me, codeRequest: codeRequest, codeValidation: codeValidation));
    final result = await saveMe.call(SaveMeParam(
        me: me, originalMe: originalMe, codeValidation: codeValidation));
    result.fold(
      (err) =>
          bloc.add(MeEditFailedEvent(me, codeRequest, codeValidation, err)),
      (res) {
        originalMe = res;
        bloc.add(MeEditSucceededEvent(me: res!));
        sessionBloc.updateMe(me);
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.edicaoCadastroTelaDeSucesso(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
      },
    );
  }

  bool? phoneRequired, emailRequired;

  void setRequiredFields({bool? phone, bool? email}) {
    phoneRequired = phone;
    emailRequired = email;
  }
}
