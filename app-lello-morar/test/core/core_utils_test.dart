import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/navigation/navigation_failure.dart';
import 'package:morar/core/stores/remote_config_store.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/core/widgets/expire_cache.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/core/presentation/failure_message.dart';
import 'package:shared_features/shared_features.dart' hide FailureMessage;

import '../helpers/firebase_mocks.dart';
import '../helpers/pump_app.dart';

void main() {
  test('HexColor aceita com e sem #', () {
    expect(HexColor('#FF0000').value, const Color(0xFFFF0000).value);
    expect(HexColor('00ff00').value, const Color(0xFF00FF00).value);
    expect(HexColor('80000000').value, const Color(0x80000000).value);
  });

  test('ExpireCache', () {
    expect(ExpireCache.banners(null), isTrue);
    expect(ExpireCache.banners(DateTime.now()), isFalse);
    expect(ExpireCache.banners(DateTime.now().subtract(const Duration(hours: 2))), isTrue);
    expect(ExpireCache.bannersHomolog(null), isTrue);
    expect(ExpireCache.bannersHomolog(DateTime.now()), isFalse);
    expect(ExpireCache.bannersHomolog(DateTime.now().subtract(const Duration(minutes: 2))), isTrue);
  });

  test('InvalidRouteFailure', () {
    final failure = InvalidRouteFailure();
    expect(failure.code, 'INVALID_ROUTE_FAILURE');
    expect(failure.error, isNull);
    expect(failure, isA<NavigationFailure>());
    expect(failure == InvalidRouteFailure(), isTrue);
  });

  test('rotas e rbacs são únicos', () {
    expect(ApplicationRoute.billets, '/billets');
    expect(ApplicationRoute.iaBella, '/ia_bella');
    expect(ApplicationRbac.morarBoletos, 'morar.boletos');
    expect(ApplicationRbac.morarIaBella, 'morar.bella');
  });

  test('HortaRemoteConfigEntity', () async {
    await initializeDateFormatting('pt_BR');
    final entity = HortaRemoteConfigEntity.fromRemote({
      'dataAte': '31/12/2099',
      'link': 'https://horta',
      'cupom': 'CUPOM',
    });
    expect(entity.link, 'https://horta');
    expect(entity.cupom, 'CUPOM');
    expect(entity.limitDate, isNotNull);
    expect(entity.limitDate!.year, 2099);
    expect(HortaRemoteConfigEntity().limitDate, isNull);
    expect(HortaRemoteConfigEntity(dataAte: '').limitDate, isNull);
  });

  test('RemoteConfigStore usa o FirebaseRemoteConfig', () async {
    final platform = await setUpFakeFirebase(remoteConfigValues: {'k': 'v'});
    final store = RemoteConfigStore();
    expect(await store.initFirebaseRemoteConfig(), isTrue);
    expect(platform.fetches, 1);
    expect(platform.activations, 1);
    expect(store.remoteConfig.getString('k'), 'v');
    expect(await store.getAll(), isEmpty);
    expect((await store.getValue(key: 'k')), isA<RemoteConfigValue>());
    await store.setConfigSettings(
      settings: RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 2),
      ),
    );
    expect(platform.configSettings!.minimumFetchInterval, const Duration(seconds: 2));
  });

  testWidgets('FailureMessage traduz cada falha', (tester) async {
    await pumpApp(tester, const Text('x'), localized: true);
    final context = tester.element(find.text('x'));
    expect(FailureMessage.get(context, UnknownFailure('x')), 'error_unknown');
    expect(FailureMessage.get(context, ServerConnectionFailure()), 'error_server_connection');
    expect(FailureMessage.get(context, InvalidCredentialsFailure('c', 'e')), 'error_invalid_credentials');
    expect(FailureMessage.get(context, InvalidCodeValidationFailure()), 'error_invalid_code');
    expect(FailureMessage.get(context, ValidateCodeMaxAttemptsExceededFailure()),
        'error_validation_code_max_attempts_exceeded');
    expect(FailureMessage.get(context, RequestCodeAlreadyValidatedFailure()), 'error_invalid_code');
    expect(FailureMessage.get(context, RegistrationUserNotFoundFailure()),
        'error_registration_user_not_found');
    expect(FailureMessage.get(context, RegistrationUserAlreadyRegisteredFailure()),
        'error_registration_user_already_registered');
    expect(FailureMessage.get(context, InvalidParamFailure()), 'error_unknown');
  });
}
