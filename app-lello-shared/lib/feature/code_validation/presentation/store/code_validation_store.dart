import 'package:essentials/essentials.dart';

import '../../../../shared_features.dart';

class CodeValidationStore {
  final CodeValidationBloc bloc;
  final ValidateCode validateCode;
  final Validate2fa validate2fa;
  final RequestValidationCode requestValidationCode;

  CodeValidationStore({
    required this.bloc,
    required this.validateCode,
    required this.requestValidationCode,
    required this.validate2fa,
  });

  CodeRequest? request;
  String? code;

  Future<void> validate() async {
    if (request != null) {
      bloc.add(CodeValidationLoadingEvent());

      final use2faValidation =
        request?.origin == CodeValidationOrigin.forgotPassword ||
          request?.origin == CodeValidationOrigin.registration ||
          ((request?.id?.isNotEmpty ?? false) &&
            (request?.token.isEmpty ?? false));

      if (use2faValidation) {
        final tokenResult = await validate2fa
            .call(Validate2faParam(id: request!.id!, value: code!));
        if (tokenResult is Success) {
          var token = tokenResult.fold((l) => null, (r) => r);
          bloc.add(CodeValidationSucceededEvent(
              validation: CodeValidation(
                  id: request!.id!, code: code, token: token?.token ?? "")));
          _disposeSMSListener();
        } else {
          bloc.add(
            CodeValidationFailedEvent(error: InvalidCodeValidationFailure()),
          );
        }
        return;
      }

      final validation = CodeValidation(
        id: request?.id,
        code: code,
      );

      //Allow test user use the same token (1234)
      if ((request?.cpf ?? "").replaceAll(RegExp(r'\.|-'), "") ==
              "39604838806" &&
          code == "1234") {
        bloc.add(CodeValidationSucceededEvent(validation: validation));
      } else {
        final validate = await validateCode(validation);
        if (validate is Success) {
          bloc.add(CodeValidationSucceededEvent(validation: validation));
          _disposeSMSListener();
        } else {
          bloc.add(
            CodeValidationFailedEvent(error: InvalidCodeValidationFailure()),
          );
        }
      }
    }
  }

  Future<void> listenSMSTokenCode() async => SmsAutoFill().listenForCode;

  void _disposeSMSListener() => SmsAutoFill().unregisterListener();
}
