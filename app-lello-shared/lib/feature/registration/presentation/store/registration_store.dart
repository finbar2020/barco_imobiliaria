import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../shared_features.dart';

class RegistrationStore {
  final RequestValidationCode requestValidationCode;
  final Register registerUsecase;
  final GetMyUser myUser;
  final Authenticate authenticate;
  final RegistrationBloc bloc;
  final sessionBloc;
  final uploadRegistrationPicture;
  final GetDados2fa getDados2faUseCase;
  final Request2fa request2faUseCase;
  final Validate2fa validate2faUseCase;
  final int? idEmpresa;
  late final String appSignature;

  RegistrationStore({
    required this.bloc,
    required this.requestValidationCode,
    required this.registerUsecase,
    required this.myUser,
    required this.authenticate,
    required this.sessionBloc,
    required this.uploadRegistrationPicture,
    required this.getDados2faUseCase,
    required this.request2faUseCase,
    required this.validate2faUseCase,
    this.idEmpresa,
  }) {
    SmsAutoFill().getAppSignature.then((signature) {
      appSignature = signature;
    });
  }

  static final RegExp digitsOnly = RegExp(r'[^0-9]');
  final stepOrder = [
    RegistrationStep.cpf,
    RegistrationStep.me,
    RegistrationStep.password,
    RegistrationStep.picture,
  ];

  RegistrationStep currentStep = RegistrationStep.cpf;

  PageController pageController = PageController();

  // Registration fields
  String? name;
  String? cpf;
  String? email;
  String? phone;
  String? codeValidationId;
  String? token;
  String? password;
  bool? termsAndConditionsCheck;
  File? profilePicture;
  bool? registeredError;
  CodeValidationSource? source;
  CodeDataContact? emailOrPhoneSelected;

  void nextStep() {
    final index = stepOrder.indexOf(currentStep);
    if (index < stepOrder.length - 1) {
      currentStep = stepOrder[index + 1];
    }
  }

  bool previousStep() {
    final index = stepOrder.indexOf(currentStep);
    if (index > 0) {
      currentStep = stepOrder[index - 1];
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return false;
    }
    dispose();
    return true;
  }

  Future<void> chooseImage({ImageSource? source}) async {
    if (source == null) {
      return profilePicture = null;
    }
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: source);

    if (image != null) {
      CroppedFile? croppedFile = await showProfileImageCropper(image.path);
      if (croppedFile != null) {
        profilePicture = File(croppedFile.path);
        this.register();
      }
    }
  }

  Future<void> requestMyUser() async {
    if (cpf == null) {
      return;
    }
    registeredError = false;

    bloc.add(
      RegistrationRequestMyUserLoadingEvent(
        loadingMessage: "registration_lello_user_searching",
        cpf: cpf ?? "",
      ),
    );

    var onlyNum = cpf!.replaceAll(RegExp(r'[^\d ]'), "");

    final result = await getDados2faUseCase.call(
      CodeDataParam(cpf: onlyNum, idEmpresa: idEmpresa ?? FlavorConfig.config.idEmpresa),
    );

    final RegistrationEvent registrationUserEvent = result.fold(
      (err) {
        return RegistrationRequestMyUserFailedEvent(
          error: err,
        );
      },
      (res) {
        if (res.registered == true) {
          registeredError = true;
          return RegistrationRequestMyUserFailedEvent(
            error: RegistrationUserAlreadyRegisteredFailure(),
          );
        }
        if (res.emailContacts.isEmpty && res.smsContacts.isEmpty) {
          return RegistrationRequestMyUserFailedEvent(
            error: RegistrationPhoneAndEmailFoundFailure(),
          );
        }
        this.name = "";
        return RegistrationRequestMyUserSucceededEvent(
          codeData: res,
          selectedValue: "",
          type: null,
        );
      },
    );
    return bloc.add(registrationUserEvent);
  }

  Future<void> requestCode() async {
    if (((phone?.isEmpty ?? false) && (email?.isEmpty ?? false)) ||
        (emailOrPhoneSelected == null)) {
      return;
    }
    bloc.add(
      RegistrationCodeRequestLoadingEvent(
        loadingMessage: "registration_sending_token",
      ),
    );

    final request = CodeRequest(
      source: source!,
      origin: CodeValidationOrigin.registration,
      value: source == CodeValidationSource.phone ? phone! : email!,
      token: "",
      id: emailOrPhoneSelected?.key,
      appSignature: appSignature,
      cpf: cpf?.replaceAll(digitsOnly, ''),
    );

    final result = await request2faUseCase.call(Tequest2faParam(
        id: emailOrPhoneSelected!.key, appSignature: appSignature));

    result.fold(
      (err) {
        bloc.add(
          RegistrationCodeRequestFailedEvent(
            error: err,
          ),
        );
      },
      (res) {
        bloc.add(RegistrationCodeRequestSucceededEvent(codeRequest: request));
      },
    );
  }

  Future<void> register() async {
    bloc.add(
        RegistrationLoadingEvent(loadingMessage: "registration_sending_data"));

    final model = Registration(
      cpf: cpf,
      email: this.email,
      name: name,
      password: password,
      phone: phone,
      profilePicture: profilePicture,
      codeValidationId: codeValidationId,
      registeredError: registeredError,
      termsAndConditionsCheck: termsAndConditionsCheck,
      token: token,
      idEmpresa: idEmpresa ?? FlavorConfig.config.idEmpresa,
    );

    final result = await registerUsecase.call(model);
    result.fold(
      (err) {
        return RegistrationFailedState(error: err);
      },
      (reg) {
        return RegistrationSucceededState();
      },
    );

    if (result is Success<Registration>) {
      final credentials = Credentials(
        username: model.cpf!.replaceAll(RegExp(r'[^0-9]'), ''),
        password: model.password!,
      );
      bloc.add(
        RegistrationLoadingEvent(loadingMessage: "registration_authenticating"),
      );

      final result = await authenticate.call(credentials);
      result.fold((err) {
        return bloc.add(
          RegistrationAuthFailedEvent(
            error: RegistrationAuthFailure(),
          ),
        );
      }, (reg) async {
        if (model.profilePicture != null) {
          bloc.add(
            RegistrationLoadingEvent(
              loadingMessage: "registration_sending_photo",
            ),
          );
          final uploadPicture =
              await uploadRegistrationPicture.call(model.profilePicture);
          if (!(uploadPicture is Success<String>)) {
            //photo upload error but registered
          }
        }
        sessionBloc.beginLoadSession();
        bloc.add(RegistrationSucceededEvent());
      });
    } else {
      var rejection = result as Rejection<Registration>;
      bloc.add(
        RegistrationFailedEvent(error: rejection.get()),
      );
    }
  }

  void dispose() {
    currentStep = RegistrationStep.cpf;
    registeredError = null;
    cpf = null;
    source = null;
    phone = null;
    email = null;
    emailOrPhoneSelected = null;
    bloc.add(RegistrationEmptyEvent());
  }
}
