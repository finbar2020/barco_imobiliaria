// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:colaborador/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:colaborador/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_event.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  final GetMe getMe;
  final SaveMe saveMe;
  final UpdatePasswordMe updatePasswordMe;
  final SessionBloc sessionBloc;
  final UploadProfilePicture uploadProfilePicture;
  final GetDados2fa getDados2faUseCase;
  final Request2fa request2faUseCase;
  final AuthenticationBloc authenticationBloc;
  final LogMeOut logMeOut;
  final DeleteAccount deleteUser;
  final String baseUrl;
  final DisableFcm disableFcm;
  final AuthenticationStore authenticationStore;
  Me? originalMe;

  MeBloc({
    required this.getMe,
    required this.saveMe,
    required this.sessionBloc,
    required this.authenticationStore,
    required this.getDados2faUseCase,
    required this.request2faUseCase,
    required this.uploadProfilePicture,
    required this.updatePasswordMe,
    required this.authenticationBloc,
    required this.logMeOut,
    required this.deleteUser,
    required this.baseUrl,
    required this.disableFcm,
  }) : super(const MeInitialState()) {
    on<MeLoadEvent>(_mapLoad);
    on<MeBeginEditEvent>((event, emit) => _mapBeginEdit(emit));
    on<MeBeginEditPasswordEvent>((event, emit) => _mapBeginEditPassword(emit));
    on<MeBeginEditSavePasswordEvent>(_mapBeginEditSavePassword);
    on<MeRevertEditEvent>((event, emit) => _mapRevertEdit(emit));
    on<MeSaveEvent>(_mapSave);
    on<MeRequestValidationCodeEvent>(_mapRequestValidationCode);
    on<MeChooseImageEvent>(_mapChooseImageEvent);
    on<MeLogoutEvent>(_mapLogOutEvent);
    on<ResendTokenEvent>((event, emit) => _mapResendToken(emit));
    on<MeDeleteAccountEvent>(_mapDeleteAccount);
    add(const MeLoadEvent());
  }

  void beginEdit() {
    add(const MeBeginEditEvent());
  }

  void beginEditPassword() {
    add(const MeBeginEditPasswordEvent());
  }

  void beginLoad(bool forceUpdate) {
    add(MeLoadEvent(forceUpdate: forceUpdate));
  }

  void beginEditSavePassword(password, originPassword) {
    add(MeBeginEditSavePasswordEvent(
        password: password, originPassword: originPassword));
  }

  void revertEdit() {
    add(const MeRevertEditEvent());
  }

  void resendToken() {
    add(const ResendTokenEvent());
  }

  void beginSave({CodeValidation? codeValidation}) {
    add(MeSaveEvent(codeValidation: codeValidation));
  }

  bool _isPhoneCheck = true;
  bool _isEmailCheck = false;
  void beginCodeRequest(
      {required bool isPhoneCheck, required bool isEmailCheck}) {
    _isPhoneCheck = isPhoneCheck;
    _isEmailCheck = isEmailCheck;
    add(MeRequestValidationCodeEvent(
        isEmailCheck: isEmailCheck, isPhoneCheck: isPhoneCheck));
  }

  Future<void> _mapChooseImageEvent(
    MeChooseImageEvent event,
    Emitter<MeState> emit,
  ) async {
    if (event.source == ImageSource.camera) {
      bool hasPermission = await CheckPermissions.camera();
      if (!hasPermission) {
        Navigator.of(navigatorKey.currentState!.context).pushNamed(
          SharedApplicationRoute.accessSettingsPermissionDenied,
          arguments: AcessSettingsPermissionDeniedPageArgs(
            acessSettingsPermissionsDeniedItem:
                AcessSettingsPermissionsDeniedItem(
              item: AcessSettingsPermissionsDeniedItemEnum.cam,
              isColaboradorApp: true,
            ),
          ),
        );
        return;
      }
    }

    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: event.source);
    if (image != null) {
      CroppedFile? croppedFile = await showGeneralImageCropper(
        image.path,
        maxHeight: 400,
        maxWidth: 400,
        context: navigatorKey.currentState!.context,
      );
      if (croppedFile != null) {
        emit(MeLoadingState(me: state.me));
        final result = await uploadProfilePicture.call(File(croppedFile.path));

        emit(result.fold((err) => MeUploadProfileFailedState(state.me!, err),
            (res) {
          sessionBloc.updateMe(state.me!);
          beginSave();
          return MeUploadProfileSucceededState(
            state.me!,
          );
        }));
      }
    }
  }

  Future<void> _mapLoad(
    MeLoadEvent event,
    Emitter<MeState> emit,
  ) async {
    bool loadedFromCache = false;
    Me? localMe;
    emit(const MeLoadingState());
    if (!event.forceUpdate) {
      final cache = await getMe.call(DataOrigin.local);
      if (cache is Success<Me?>) {
        localMe = cache.get();
        if (localMe != null) {
          loadedFromCache = true;
          originalMe = localMe;
          if (localMe.pictureHash != null) {
            localMe.setPictureLink();
          }
          emit(MeLoadedCacheState(localMe));
        }
      }
    }

    if (!loadedFromCache ||
        localMe?.lastUpdatedAt == null ||
        (loadedFromCache && localMe!.hasToUpdate)) {
      final remote = await getMe.call(DataOrigin.remote);
      final newState = remote.fold((err) {
        if (!loadedFromCache) {
          return MeLoadFailedState(err);
        } else {
          return MeLoadedCacheState(localMe!);
        }
      }, (me) {
        if (me != null) {
          originalMe = me;
          sessionBloc.updateMe(me);
        }
        return MeLoadedState(me);
      });
      emit(newState);
    }
  }

  Future<void> _mapBeginEdit(Emitter<MeState> emit) async {
    emit(MeEditLoadingState(state.me!));
    final copy = Me.clone(state.me!);
    emit(MeEditState(
      copy,
    ));
    EmployeeAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsEmployee.edicaoCadastradoAcessar(),
      referenceValue:
          sessionBloc.getSession?.condominium.reference.toString() ?? "",
    );
  }

  Future<void> _mapBeginEditSavePassword(
    MeBeginEditSavePasswordEvent event,
    Emitter<MeState> emit,
  ) async {
    final copy = Me.clone(state.me!);
    emit(MeEditPasswordLoadingState(
        copy, event.originPassword, event.password));
    final result = await updatePasswordMe.call(UpdatePasswordMeParam(
        originPassword: event.originPassword,
        password: event.password,
        cpf: copy.cpf));

    emit(result.fold(
      (err) => MeEditPasswordFailedState(
          copy, event.originPassword, event.password, err),
      (res) {
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.redefinirSenha(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        return MeEditSucceededState(copy);
      },
    ));
  }

  Future<void> _mapBeginEditPassword(Emitter<MeState> emit) async {
    final copy = Me.clone(state.me!);
    emit(MeEditPasswordState(copy, "", ""));
  }

  Future<void> _mapRevertEdit(Emitter<MeState> emit) async {
    if (originalMe != null) {
      emit(MeLoadedState(originalMe));
    }
  }

  Future<void> _mapResendToken(Emitter<MeState> emit) async {
    final editState = state;
    if (originalMe != null && editState is MeEditState) {
      final me = editState.me;
      emit(MeEditPhoneChangedState(me: me));
      beginCodeRequest(
          isEmailCheck: _isEmailCheck, isPhoneCheck: _isPhoneCheck);
    }
  }

  Future<void> _mapLogOutEvent(
    MeLogoutEvent event,
    Emitter<MeState> emit,
  ) async {
    emit(MeLoadingState(me: state.me));
    await disableFcm.call();
    sessionBloc.logout();
    await authenticationStore.logout();
    final result = await logMeOut();
    if (result is Success) {
      ApplicationContainer.instance().resolve<InactivityCubit>().cancel();
      emit(const MeUnauthenticatedState(null));
    }
  }

  Future<void> _mapRequestValidationCode(
    MeRequestValidationCodeEvent event,
    Emitter<MeState> emit,
  ) async {
    final me = state.me;
    if (me != null) {
      emit(MeEditRequestingCodeState(
        me,
      ));

      final cpf = (me.cpf ?? "").replaceAll(RegExp(r'[^0-9]'), "");
      final result = await getDados2faUseCase.call(
        CodeDataParam(cpf: cpf, idEmpresa: FlavorConfig.config.idEmpresa),
      );

      final flowState = await result.fold(
        (err) async => MeEditRequestCodeFailedState(me, err),
        (res) async {
          final source = event.isPhoneCheck
              ? CodeValidationSource.phone
              : CodeValidationSource.email;
          final contacts =
              event.isPhoneCheck ? res.smsContacts : res.emailContacts;

          if (contacts.isEmpty) {
            return MeEditNoContactAvailableState(me);
          }

          final selectedContact = _getPreferredContact(
            contacts: contacts,
            source: source,
            currentValue: (event.isPhoneCheck ? me.phone : me.email) ?? "",
          );

          final appSignature = await SmsAutoFill().getAppSignature;
          final request2faResult = await request2faUseCase.call(
            Tequest2faParam(
              id: selectedContact.key,
              appSignature: appSignature,
            ),
          );

          return request2faResult.fold(
            (err) => MeEditRequestCodeFailedState(me, err),
            (ok) {
              final request = CodeRequest(
                source: source,
                origin: CodeValidationOrigin.changeNumber,
                value: selectedContact.value,
                token: "",
                cpf: cpf,
                id: selectedContact.key,
              );
              return MeEditValidateCodeState(me, request);
            },
          );
        },
      );

      emit(flowState);
    }
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

  Future<void> _mapSave(
    MeSaveEvent event,
    Emitter<MeState> emit,
  ) async {
    final editState = state;
    if (originalMe != null && editState is MeEditState) {
      final me = editState.me;
      final codeRequest = editState.codeRequest;
      final needsCodeRequestPhone = me!.phone != originalMe!.phone;
      final needsCodeRequestEmail = me.email != originalMe!.email;

      if (needsCodeRequestPhone && codeRequest == null) {
        emit(MeEditPhoneChangedState(me: me, isPhone: true));
      } else if (needsCodeRequestEmail &&
          (codeRequest == null ||
              codeRequest.source == CodeValidationSource.phone)) {
        emit(MeEditPhoneChangedState(me: me, isEmail: true));
      } else {
        await _save(me, codeRequest, event.codeValidation, emit);
      }
    } else if (editState is MeUploadProfileSucceededState) {
      final me = editState.me;
      await _save(me!, null, null, emit);
    }
  }

  Future<void> _save(
    Me me,
    CodeRequest? codeRequest,
    CodeValidation? codeValidation,
    Emitter<MeState> emit,
  ) async {
    emit(MeEditLoadingState(me,
        codeRequest: codeRequest, codeValidation: codeValidation));
    final result = await saveMe.call(SaveMeParam(
        me: me, originalMe: originalMe, codeValidation: codeValidation));
    final newState = result.fold(
      (err) => MeEditFailedState(me, err,
          codeValidation: codeValidation, codeRequest: codeRequest),
      (res) {
        originalMe = res;
        return MeEditSucceededState(res!);
      },
    );
    if (newState is MeEditSucceededState) {
      sessionBloc.updateMe(newState.me!);
    }
    emit(newState);
  }

  Future<void> _mapDeleteAccount(
    MeDeleteAccountEvent event,
    Emitter<MeState> emit,
  ) async {
    emit(MeEditLoadingState(event.me));

    final response = await deleteUser.call();

    final result = response.fold((l) => MeDeleteAccountFailedState(event.me),
        (r) => MeDeleteAccountSuccessState(event.me));
    emit(result);
  }

  void beginPickImage() {
    add(MeChooseImageEvent(ImageSource.gallery));
  }

  void beginTakePhoto() {
    add(MeChooseImageEvent(ImageSource.camera));
  }

  void beginLogOut() {
    add(const MeLogoutEvent());
  }

  void deleteAccount(Me me) {
    add(MeDeleteAccountEvent(me));
  }
}
