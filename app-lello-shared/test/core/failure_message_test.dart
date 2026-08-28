import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart'
    hide isNull, isNotNull, FailureMessage;
import 'package:shared_features/shared_features.dart' as shared
    show FailureMessage;

import '../helpers/pump_app.dart';

void main() {
  late BuildContext context;

  Future<void> pump(WidgetTester tester) => pumpApp(
        tester,
        Builder(builder: (c) {
          context = c;
          return const SizedBox();
        }),
      );

  testWidgets('cada falha conhecida tem a sua chave de mensagem',
      (tester) async {
    await pump(tester);

    // Lista de pares (e não Map): o `==` de `Failure` é por valor, então
    // falhas sem `code`/`error` colapsariam como a mesma chave.
    final casos = <(Failure, String)>[
      (UnknownFailure('x'), 'error_unknown'),
      (ServerConnectionFailure(), 'error_server_connection'),
      (InvalidCredentialsFailure('401', 'x'), 'error_invalid_credentials'),
      (UnknowCredentialsFailure('401', 'x'),
          'error_invalid_credentials_unknow'),
      (NotRegisteredCredentialsFailure('401', 'x'),
          'error_invalid_credentials_not_registered'),
      (NoRoleForCredentialsFailure('401', 'x'),
          'error_invalid_credentials_no_role'),
      (InvalidValue2faFailure(), 'error_invalid_code'),
      (RegistrationUserNotFoundFailure(), 'error_registration_user_not_found'),
      (RegistrationUserAlreadyRegisteredFailure(),
          'error_registration_user_already_registered'),
    ];

    for (final (failure, chave) in casos) {
      expect(shared.FailureMessage.get(context, failure), chave,
          reason: '${failure.runtimeType}');
    }
  });

  testWidgets('falha desconhecida cai na mensagem genérica', (tester) async {
    await pump(tester);

    expect(shared.FailureMessage.get(context, InvalidRegistrationFailure()),
        'error_unknown');
  });
}
