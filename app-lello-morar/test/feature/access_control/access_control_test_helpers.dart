import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_itens.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_recurrence.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_stauts_biometric_enum.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

/// Caminho da listagem de visitantes da unidade `u1` (sessão de teste).
const listPath = '/concierge/accesscontrol/u1';

/// Chave de SharedPreferences do onboarding para o condomínio `R1`.
String onboardingKey([String reference = 'R1']) =>
    SharedPreferencesKeys.accessControlOnboarding.replaceAll('#ref', reference);

/// Marca o onboarding como já fechado para que `getLists` carregue as listas.
/// Deve ser chamado DEPOIS de `installPageHarness` e ANTES de `pumpPage`.
void closeOnboardingPrefs({String reference = 'R1'}) {
  SharedPreferences.setMockInitialValues({
    onboardingKey(reference):
        jsonEncode({'reference': reference, 'onboarding': false}),
  });
}

String isoDate(DateTime d) =>
    DateTime(d.year, d.month, d.day).toIso8601String();

DateTime get today {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// JSON de uma autorização (agendamento) no formato do
/// `AccessControlAuthorizationsModel`.
Map<String, dynamic> authJson({
  String id = 'a1',
  String type = 'PHONE',
  DateTime? start,
  DateTime? end,
  bool facial = false,
  List<int>? days,
}) {
  final s = start ?? today;
  final e = end ?? s;
  return {
    'id': id,
    'id_unit': 'u1',
    'id_gest': 'g1',
    'start': isoDate(s),
    'end': isoDate(e),
    'autorization_type': type,
    'use_facial_biometric': facial,
    if (days != null)
      'recurrence': {
        'id_recurrence': 'r1',
        'recurrence_type': 'WEEKLY',
        'interval': 1,
        'itens': [
          for (final d in days)
            {
              'recurrence_value': d,
              'start': {'hour': 0, 'minute': 0, 'aecond': 0, 'nano': 0},
              'end': {'hour': 0, 'minute': 0, 'aecond': 0, 'nano': 0},
            }
        ],
      },
  };
}

/// JSON de um visitante/prestador no formato do `AccessControlModel`.
Map<String, dynamic> visitantJson({
  String id = 'g1',
  String name = 'Carlos Souza',
  String? document = '12345678909',
  String type = 'GEST',
  String? business,
  String? phone = '11999998888',
  String? statusBiometric,
  String? notificationParameter,
  List<Map<String, dynamic>>? authorizations,
  String gestUnitType = 'PHONE',
}) =>
    {
      'id_gest': id,
      'name': name,
      'document': document,
      'business': business,
      'type': type,
      'phone': phone,
      'status_biometric': statusBiometric,
      'notification_parameter': notificationParameter,
      'gest_units': [
        {
          'id_gest_unit': 'gu-$id',
          'unit': {
            'id': 'u1',
            'title': '101',
            'notification_context': 'ctx',
            'rented': false,
            'compliant': true,
            'agreement': false,
            'term_home_to_go': false,
          },
          'relation': 'x',
          'autorization_type': gestUnitType,
          'observation': 'obs',
          'authorizations': authorizations ?? [authJson()],
        }
      ],
    };

/// Entidade de visitante pronta para os estados do bloc.
AccessControl gest({
  String? id = 'g1',
  String type = 'GEST',
  String? name = 'Carlos Souza',
  String? document = '12345678909',
  String? typeDocument,
  String? foreignDocument,
  String? business,
  String? phone = '(11)999998888',
  StatusBiometric? statusBiometric,
  List<AccessControlAuthorizations>? authorizations,
  String? gestUnitType,
  bool withUnit = true,
}) =>
    AccessControl(
      idGest: id,
      name: name,
      document: document,
      typeDocument: typeDocument,
      foreignDocument: foreignDocument,
      business: business,
      phone: phone,
      type: type,
      statusBiometric: statusBiometric,
      gestUnits: [
        AccessControlGestUnits(
          idGestUnit: withUnit ? 'gu' : null,
          unit: withUnit ? testUnity() : null,
          autorizationType: gestUnitType,
          autorizationTypeInt: 1,
          authorizations: authorizations ?? [],
        ),
      ],
    );

AccessControlAuthorizations auth({
  String? id = 'a1',
  String type = 'PHONE',
  DateTime? start,
  DateTime? end,
  bool? facial,
  List<int>? days,
  AccessControl? accessControl,
}) {
  final s = start ?? today;
  return AccessControlAuthorizations(
    id: id,
    start: isoDate(s),
    end: isoDate(end ?? s),
    autorizationType: type,
    useFacialBiometric: facial,
    accessControl: accessControl,
    recurrence: days == null
        ? null
        : AccessControlRecurrence(
            idRecurrence: 'r1',
            recurrenceType: 'WEEKLY',
            interval: 1,
            itens: [
              for (final d in days) AccessControlItens(recurrenceValue: d)
            ],
          ),
  );
}

/// Coloca o bloc da store direto em [EditVisitantState] (síncrono).
EditVisitantState setEditState(
  AccessControlStore store, {
  required AccessControl visitant,
  AccessControlAuthorizations? model,
  List<AccessControl> visitants = const [],
  List<AccessControl> providers = const [],
}) {
  final state = EditVisitantState(
    visitant: visitant,
    model: model ?? AccessControlAuthorizations(accessControl: visitant),
    visitants: visitants,
    providers: providers,
  );
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  store.bloc.emit(state);
  return state;
}

/// Coloca o bloc da store em [AccessControlLoadedState] (síncrono) e
/// preenche as listas da store.
void setLoadedState(
  AccessControlStore store, {
  List<AccessControl> visitants = const [],
  List<AccessControl> providers = const [],
}) {
  store.visitants = List.of(visitants);
  store.providers = List.of(providers);
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  store.bloc.emit(AccessControlLoadedState(
      visitants: store.visitants, providers: store.providers));
}

/// Chave da tela lançadora usada por [pumpPushed].
const launcherKey = Key('launcher');

/// Monta uma tela lançadora como rota inicial e empurra [page] por cima,
/// para que `Navigator.pop` da página sob teste tenha para onde voltar.
Future<void> pumpPushed(
  WidgetTester tester,
  Widget page, {
  Object? arguments,
  RecordingNavigatorObserver? observer,
  Size surface = const Size(400, 800),
  bool settle = true,
}) async {
  await pumpPage(
    tester,
    Builder(
      builder: (context) => Scaffold(
        key: launcherKey,
        body: TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: 'pushed', arguments: arguments),
            builder: (_) => page,
          )),
          child: const Text('abrir'),
        ),
      ),
    ),
    observer: observer,
    surface: surface,
  );
  await tester.tap(find.text('abrir'));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }
}

/// Desmonta a árvore atual. Necessário antes de um segundo `pumpPage` no
/// mesmo teste: senão o `MaterialApp`/`Navigator` são reaproveitados e a
/// página não é recriada.
Future<void> resetApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

/// Emite [state] no bloc e dá dois frames (o stream do bloc entrega em
/// microtask, então um único `pump` não basta) sem `pumpAndSettle` — útil
/// para estados com animação infinita (loading).
Future<void> emitAndPump(WidgetTester tester, Bloc bloc, Object state) async {
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  bloc.emit(state);
  await tester.pump();
  await tester.pump();
}

/// Dispara o botão "voltar" do sistema (WillPopScope).
Future<void> systemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

/// Atalho para o `SessionBloc` do contexto em widgets isolados.
Widget withSession(FakeSessionBloc bloc, Widget child) =>
    BlocProvider<SessionBloc>.value(value: bloc, child: child);
