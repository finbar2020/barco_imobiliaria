import 'package:essentials/essentials.dart';
import 'package:essentials/providers/session_data_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/me/domain/entity/block.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/domain/entity/layout.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';

/// PNG 1x1 transparente em base64 — suficiente para `Me.picture`.
const testPictureBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

Unity testUnity({
  String id = 'u1',
  String title = '101',
  String notificationContext = 'ctx-u1',
  bool rented = false,
  bool compliant = true,
  bool agreement = false,
  bool termHomeToGo = false,
}) =>
    Unity(
      id: id,
      title: title,
      notification_context: notificationContext,
      rented: rented,
      compliant: compliant,
      agreement: agreement,
      term_home_to_go: termHomeToGo,
    );

Block testBlock({
  String id = 'b1',
  String name = 'Bloco A',
  List<Unity>? units,
}) =>
    Block(id: id, name: name, units: units ?? [testUnity()]);

Layout testLayout() => Layout(
      cod: 'L1',
      name: 'Lello',
      reference: 'R1',
      primary: '#FF0000',
      secondary: '#00FF00',
      logoPath: 'logo.png',
    );

Condominium testCondominium({
  String id = 'c1',
  String reference = 'R1',
  String name = 'Edifício Lello',
  List<Block>? blocks,
  bool activeManager = true,
  bool useFacialBiometric = true,
  Layout? layout,
}) =>
    Condominium(
      id: id,
      reference: reference,
      name: name,
      address: 'Rua das Flores, 100',
      regulationUrl: 'http://regulation',
      blocks: blocks ?? [testBlock()],
      active_manager: activeManager,
      useFacialBiometric: useFacialBiometric,
      layout: layout,
    );

Me testMe({
  String id = 'm1',
  String name = 'ana silva',
  String email = 'ana@lello.com',
  String cpf = '12345678901',
  String phone = '11999998888',
  List<Condominium>? condominiums,
  String? picture,
  DateTime? lastUpdatedAt,
}) =>
    Me()
      ..id = id
      ..name = name
      ..email = email
      ..cpf = cpf
      ..phone = phone
      ..picture = picture ?? ''
      ..condominiums = condominiums ?? [testCondominium()]
      ..lastUpdatedAt = lastUpdatedAt ?? DateTime(2026, 1, 1);

Session testSession({Me? me, Condominium? condominium, Unity? unity}) {
  final session = Session()..me = me ?? testMe();
  if (condominium != null) session.condominium = condominium;
  if (unity != null) session.unity = unity;
  return session;
}

/// SessionBloc de mentira: nunca toca Firebase, remote config nem rede.
class FakeSessionBloc extends Fake implements SessionBloc {
  FakeSessionBloc({
    Session? session,
    this.rbacAllowed = true,
    this.configAllowed = true,
    this.personalizationActive = true,
    this.baseUrl = 'http://localhost',
    this.remoteConfigLinks = const {},
    ThemeColorValue? themeColor,
    this.insuranceTable,
    this.hortaConfig,
    this.allowedRbacs,
  })  : session = session ?? testSession(),
        _themeColor = themeColor {
    currentState = SessionLoadedState(this.session);
  }

  Session session;

  /// Quando [allowedRbacs] é informado, só esses rbacs são permitidos;
  /// caso contrário vale [rbacAllowed] para todos.
  bool rbacAllowed;
  Set<String>? allowedRbacs;
  HortaRemoteConfigEntity? hortaConfig;
  final bool configAllowed;
  final bool personalizationActive;
  final String baseUrl;
  final Map<String, FirebaseRemoteConfigLink> remoteConfigLinks;
  ThemeColorValue? _themeColor;
  InsuranceTableModel? insuranceTable;
  late SessionState currentState;

  final rbacChecked = <String>[];
  final configChecked = <String>[];
  final selectedUnits = <Unity>[];
  final updatedMes = <Me?>[];
  final logoutCalls = <Failure?>[];
  int loadCalls = 0;

  @override
  final SessionDataProvider<ThemeColorValue?> sessionDataProvider =
      SessionDataProvider();

  @override
  SessionState get state => currentState;

  @override
  Stream<SessionState> get stream => Stream.value(currentState);

  @override
  bool checkRback(String rbac) {
    rbacChecked.add(rbac);
    final allowed = allowedRbacs;
    if (allowed != null) return allowed.contains(rbac);
    return rbacAllowed;
  }

  @override
  HortaRemoteConfigEntity? getHortaRemoteConfig() => hortaConfig;

  @override
  bool checkConfig(String rbac) {
    configChecked.add(rbac);
    return configAllowed;
  }

  @override
  FirebaseRemoteConfig? get getRemoteConfig => null;

  @override
  FirebaseRemoteConfigLink? getRemoteConfigForLinks(String configKey) =>
      remoteConfigLinks[configKey];

  @override
  String getBaseUrl() => baseUrl;

  @override
  InsuranceTableModel? getInsuranceTable() => insuranceTable;

  @override
  bool get iSPreferencesPersonalizationActive => personalizationActive;

  @override
  /// Controla o retorno de [iSsplashIgnoreBiometricActive].
  bool splashIgnoreBiometric = false;

  @override
  Future<bool> iSsplashIgnoreBiometricActive() async => splashIgnoreBiometric;

  @override
  ThemeColorValue? getThemeColor() => _themeColor;

  @override
  void updateThemeColor(ThemeColorValue? value) {
    _themeColor = value;
    sessionDataProvider.update(value);
  }

  @override
  void selectedUnity(Unity unity) {
    selectedUnits.add(unity);
    session.unity = unity;
  }

  @override
  void selectedCondominium(Unity unity) {
    selectedUnits.add(unity);
  }

  @override
  void updateMe(Me? me) {
    updatedMes.add(me);
    session.me = me;
  }

  @override
  void beginLoadSession({bool onLogin = false}) {
    loadCalls++;
  }

  @override
  void logout({Failure? error, bool? restartApp}) {
    logoutCalls.add(error);
  }

  @override
  Future<void> close() async {}
}
