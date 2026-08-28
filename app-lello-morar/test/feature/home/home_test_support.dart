import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/messaging/message_handler.dart' as push;
import 'package:morar/core/stores/remote_config_store.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';

/// SessionBloc falso com um stream de verdade: permite emitir estados
/// (`SessionLoadingState`, `SessionFailedState`, `switchFailed`...) para os
/// `BlocListener`/`BlocBuilder` da home reagirem.
class HomeFakeSessionBloc extends FakeSessionBloc {
  HomeFakeSessionBloc({Session? session}) : super(session: session);

  final _controller = StreamController<SessionState>.broadcast();
  int emptyStateCalls = 0;

  /// Trocar a sessão também atualiza o estado atual (como o bloc real).
  @override
  set session(Session value) {
    super.session = value;
    currentState = SessionLoadedState(value);
  }

  @override
  Session get session => super.session;

  @override
  Stream<SessionState> get stream => _controller.stream;

  void emit(SessionState state) {
    currentState = state;
    _controller.add(state);
  }

  @override
  void emptyState() {
    emptyStateCalls++;
  }

  /// Volta o bloc ao estado padrão (sessão de [testSession]).
  void resetTo({Session? session}) {
    this.session = session ?? testSession();
    rbacAllowed = true;
    allowedRbacs = null;
    hortaConfig = null;
    insuranceTable = null;
    currentState = SessionLoadedState(this.session);
    rbacChecked.clear();
    configChecked.clear();
    selectedUnits.clear();
    updatedMes.clear();
    logoutCalls.clear();
    emptyStateCalls = 0;
  }
}

/// GetToken falso: o real abre um box do Hive (IO de verdade), o que nunca
/// completa dentro do fake async do `testWidgets`.
class FakeGetToken extends Fake implements GetToken {
  FakeGetToken({this.role = 'morar.proprietario', this.fail = false});
  final String? role;
  final bool fail;
  int calls = 0;

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async {
    calls++;
    if (fail) return Rejection(UnknownFailure('token'));
    return Success(AccessToken()
      ..accessToken = 'acc'
      ..refreshToken = 'ref'
      ..selectedRole = role);
  }
}

const localNotificationsChannel =
    MethodChannel('dexterous.com/flutter/local_notifications');
const adjustChannel = MethodChannel('com.adjust.sdk/api');
const urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');
const nativeUrlLauncherChannel = MethodChannel('com.example.app/url_launcher');

/// Canais de plataforma usados pela home (notificações locais, Adjust,
/// url_launcher e clipboard). Devolve a lista de chamadas registradas.
List<MethodCall> mockHomePlatformChannels() {
  final calls = <MethodCall>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  AndroidFlutterLocalNotificationsPlugin.registerWith();
  messenger.setMockMethodCallHandler(localNotificationsChannel, (call) async {
    calls.add(call);
    return call.method == 'initialize' ? true : null;
  });
  messenger.setMockMethodCallHandler(adjustChannel, (call) async {
    calls.add(call);
    return null;
  });
  messenger.setMockMethodCallHandler(urlLauncherChannel, (call) async {
    calls.add(call);
    return true;
  });
  messenger.setMockMethodCallHandler(nativeUrlLauncherChannel, (call) async {
    calls.add(call);
    return true;
  });
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    calls.add(call);
    return null;
  });
  addTearDown(() {
    messenger.setMockMethodCallHandler(localNotificationsChannel, null);
    messenger.setMockMethodCallHandler(adjustChannel, null);
    messenger.setMockMethodCallHandler(urlLauncherChannel, null);
    messenger.setMockMethodCallHandler(nativeUrlLauncherChannel, null);
    messenger.setMockMethodCallHandler(SystemChannels.platform, null);
  });
  return calls;
}

/// Sobe o harness de página com o [sessionBloc] compartilhado do arquivo
/// (o `circuitBreakController` global de `home_item_enum.dart` é resolvido
/// uma única vez por isolate, então o mesmo bloc precisa ser reaproveitado),
/// o `GetToken` falso, o `RemoteConfigStore` inicializado e a permissão de
/// notificação concedida.
Future<PageHarness> installHomeHarness(
  HomeFakeSessionBloc sessionBloc, {
  FakeGetToken? getToken,
  PermissionStatus permission = PermissionStatus.granted,
}) async {
  sessionBloc.resetTo();
  final harness = await installPageHarness(sessionBloc: sessionBloc);
  setFakePermissionHandler(FakePermissionHandler(status: permission));
  await harness.override<GetToken>(getToken ?? FakeGetToken());
  await harness.override<RemoteConfigStore>(
    RemoteConfigStore()..remoteConfig = FirebaseRemoteConfig.instance,
  );
  push.isFirstBuild = true;
  // Onboarding dos cards já visto: sem isso o AvatarGlow anima para sempre e
  // o pumpAndSettle nunca termina.
  SharedPreferences.setMockInitialValues({
    'PREFERENCES_HOME_CARDS_ONBOARDING${sessionBloc.session.me?.cpf}':
        '{"onboarding": true}',
    'device_unique_id': 'dev-1',
  });
  return harness;
}

/// Respostas padrão das APIs consultadas pela home (notificações, banners,
/// fcm, sub-usuários, acordos).
void stubHomeApis(PageHarness harness) {
  harness.http.on('GET', '/dashboard/u1/pendencies/pagination',
      body: {'data': [], 'meta': {'totalItems': 0}});
  harness.http.on('GET', '/dashboard/pendencies/resume',
      body: {'total_read': 0, 'total_ignored': 1, 'total_received': 2});
  harness.http.on('POST', '/dashboard/register_fcm_token', body: {});
  harness.http.on('GET', '/condominiums/c1/banners', body: {'data': []});
  harness.http.on('GET', '/concierge/subUser/u1', body: []);
  harness.http.on('GET', '/condominiums/c1/agreement/allInfoV2',
      status: 500, body: {'message': 'erro'});
}
