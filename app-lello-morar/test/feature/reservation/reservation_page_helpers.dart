// Helpers locais dos testes de tela da feature de reservas.
//
// Não edite `test/helpers/*`: tudo que a feature precisa a mais fica aqui.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart' show LinkDelegate;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

/// Condomínio/unidade da sessão de teste (`testSession()`).
const condominiumId = 'c1';
const unitId = 'u1';

final _apiDate = DateFormat('dd/MM/yyyy HH:mm:ss');

/// Data no formato que a API devolve para reservas (`dd/MM/yyyy HH:mm:ss`).
String apiDate(DateTime date) => _apiDate.format(date);

/// `dd/MM/yyyy` — formato de `locked_days`/`already_reservated_days`.
String calendarDay(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

DateTime get today => DateTime.now();
DateTime daysFromNow(int days) => DateTime.now().add(Duration(days: days));

/// JSON de um espaço (`SpaceModel`). `limitation` precisa ser um nome do
/// enum `ReservationLimitation` (String): o model quebra com `null`.
Map<String, dynamic> spaceJson({
  String id = 'sp1',
  String name = 'SALAO DE FESTAS',
  String typeId = 'A',
  String typeDescription = 'Area',
  bool chargeable = false,
  double? price,
  double? percentageTax,
  String? paymentMethod,
  int minRange = 0,
  int maxRange = 0,
  bool? blockedForDefaulters = false,
  bool? blockedForSettlers = false,
  String? pictureUrl,
  String? term = 'Termo de uso do espaço',
  String fileUrl = '',
  int capacity = 20,
  int cancellationLimit = 2,
  bool allDay = true,
}) =>
    {
      'id': id,
      'name': name,
      'picture_url': pictureUrl,
      'file_url': fileUrl,
      'type': {'id': typeId, 'description': typeDescription},
      'description': 'desc $id',
      'capacity': capacity,
      'shared_space': null,
      'reservation_rule': {
        'blocked_for_settlers': blockedForSettlers,
        'blocked_for_defaulters': blockedForDefaulters,
        'blockage_article': null,
        'all_day': allDay,
        'open_hour': 8,
        'close_hour': 22,
        'default_duration': 4,
        'time_between_reservations': 0,
        'limitation': 'day',
        'limit': 1,
        'send_email_to_manager': false,
        'send_email_to_resident': false,
        'chargeable': chargeable,
        'price': price,
        'percentage_tax': percentageTax,
        'payment_method': paymentMethod,
        'cancellation_limit': cancellationLimit,
        'expiration_days': 3,
        'reservation_range_minimum': minRange,
        'reservation_range_maximum': maxRange,
      },
      'term': term,
    };

/// JSON de uma reserva agendada (`ReservationScheduledModel`).
Map<String, dynamic> reservationJson({
  int id = 1,
  String areaId = 'sp1',
  String area = 'SALAO DE FESTAS',
  DateTime? start,
  DateTime? end,
  int idStatus = 83,
  String reservationType = 'A',
  String? flagChargingForm,
  String? charginFormDescription,
  double? reservationValue,
  String? flagChargingStatus,
  String? billetCode,
  String? receipt,
  DateTime? billetPeriod,
  DateTime? canCancelUntil,
  int? unitId = 101,
}) {
  final s = start ?? DateTime(daysFromNow(2).year, daysFromNow(2).month, daysFromNow(2).day, 10);
  final e = end ?? s.add(const Duration(hours: 4));
  return {
    'area_id': areaId,
    'id': id,
    'canceling_date': null,
    'inclusion_date': apiDate(today),
    'sended_email_paid_billet_date': null,
    'area': area,
    'flag_utitlity_term': 1,
    'reservation_value': reservationValue,
    'start_reservation_date': apiDate(s),
    'end_reservation_date': apiDate(e),
    'observations': null,
    'unit_id': unitId,
    'unit_name': '101',
    'reservation_type_date': null,
    'receipt': receipt,
    'email_send_date': null,
    'update_date': null,
    'user_alteration': null,
    'reference': 'R1',
    'reservation_type': reservationType,
    'id_status': idStatus,
    'flag_charging_form': flagChargingForm,
    'reservation_type_description': 'Area',
    'chargin_form_description': charginFormDescription,
    'id_status_decription': 'Reservado',
    'flag_charging_status': flagChargingStatus,
    'billet_value': reservationValue,
    'billet_period': billetPeriod?.toIso8601String(),
    'billet_situation': null,
    'billet_invoice': null,
    'billet_code': billetCode,
    'can_cancel_until': canCancelUntil == null ? null : apiDate(canCancelUntil),
  };
}

Map<String, dynamic> hourJson(String from, String until) => {'from': from, 'until': until};

const spacesPath = '/condominiums/$condominiumId/spaces';
const reservationsPath = '/condominiums/$condominiumId/reservations';
String calendarPath(String spaceId) =>
    '/condominiums/$condominiumId/spaces/reservation/calendar/day/$spaceId';
String hoursPath(String spaceId) =>
    '/condominiums/$condominiumId/spaces/reservation/calendar/hours/$spaceId';
String postPath(String spaceId) => '/condominiums/$condominiumId/spaces/$spaceId/reservations';
String deletePath(String id, String type) => '/condominiums/$condominiumId/reservations/$id/$type';

/// Cadastra as respostas padrão da API de reservas no [FakeHttp].
void stubReservationApi(
  FakeHttp http, {
  List<Map<String, dynamic>>? spaces,
  List<Map<String, dynamic>>? reservations,
  Map<String, dynamic>? calendar,
  List<Map<String, dynamic>>? hours,
}) {
  http.on('GET', spacesPath, body: spaces ?? [spaceJson()]);
  http.on('GET', reservationsPath, body: reservations ?? <Map<String, dynamic>>[]);
  http.on(
    'GET',
    '/condominiums/$condominiumId/spaces/reservation/calendar/day/*',
    body: calendar ??
        {
          'locked_days': [calendarDay(daysFromNow(1))],
          'already_reservated_days': [calendarDay(daysFromNow(2))],
          'raffled_days': <String>[],
          'free_to_reserve_days': <String>[],
        },
  );
  http.on(
    'GET',
    '/condominiums/$condominiumId/spaces/reservation/calendar/hours/*',
    body: hours ?? [hourJson('10:00:00', '14:00:00'), hourJson('15:00:00', '19:00:00')],
  );
}

/// Resposta padrão de POST de reserva (reserva criada).
Map<String, dynamic> postedReservationJson({
  String areaId = 'sp1',
  String area = 'Salao de festas',
  String reservationType = 'A',
  String? receipt,
  String? billetCode,
  DateTime? billetPeriod,
}) =>
    reservationJson(
      id: 99,
      areaId: areaId,
      area: area,
      reservationType: reservationType,
      receipt: receipt,
      billetCode: billetCode,
      billetPeriod: billetPeriod,
    );

/// Cria um [ReservationBloc] pelo container e o fixa como singleton, para que
/// a página use exatamente esta instância (no container ele é um factory).
///
/// O construtor do bloc já dispara `GetSpacesEvent`, então cadastre as rotas
/// HTTP antes de chamar.
Future<ReservationBloc> installReservationBloc(PageHarness harness) async {
  final bloc = harness.resolve<ReservationBloc>();
  await harness.override<ReservationBloc>(bloc);
  return bloc;
}

/// Botão que empurra a rota `/reserve` (com [args]) por cima da rota inicial:
/// assim a `ReservationPage` tem AppBar com voltar, `ModalRoute.settings.name`
/// igual ao app real e `ReservationDeletedPage.popUntil` funciona.
class ReservationLauncher extends StatelessWidget {
  const ReservationLauncher({super.key, this.args});
  final ReservationPageArgs? args;

  @override
  Widget build(BuildContext context) => Scaffold(
        key: const Key('launcher'),
        body: Center(
          child: ElevatedButton(
            key: const Key('open-reserve'),
            onPressed: () => Navigator.pushNamed(context, ApplicationRoute.reserve, arguments: args),
            child: const Text('abrir reservas'),
          ),
        ),
      );
}

/// Monta o launcher e abre a `ReservationPage` na rota `/reserve`.
Future<void> pumpReservationPage(
  WidgetTester tester, {
  ReservationPageArgs? args,
  RecordingNavigatorObserver? observer,
  bool settle = true,
  Size surface = const Size(400, 800),
  Map<String, WidgetBuilder> extraRoutes = const {},
}) async {
  await pumpPage(
    tester,
    ReservationLauncher(args: args),
    observer: observer,
    surface: surface,
    routes: {
      ApplicationRoute.reserve: (_) => const ReservationPage(),
      ...extraRoutes,
    },
  );
  await tester.tap(find.byKey(const Key('open-reserve')));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump();
  }
}

/// url_launcher falso: registra as URLs abertas em [launched].
class FakeUrlLauncher extends UrlLauncherPlatform {
  final launched = <String>[];
  bool canLaunchResult = true;

  @override
  final LinkDelegate? linkDelegate = null;

  @override
  Future<bool> canLaunch(String url) async => canLaunchResult;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    launched.add(url);
    return true;
  }
}

const _inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');

/// `AppReview.call` (fechar o diálogo de sucesso) consulta o in_app_review:
/// responde "indisponível". Devolve a lista de métodos chamados no canal.
List<String> installFakeInAppReview() {
  final calls = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_inAppReviewChannel, (call) async {
    calls.add(call.method);
    return false;
  });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, null);
  });
  return calls;
}

FakeUrlLauncher installFakeUrlLauncher() {
  final fake = FakeUrlLauncher();
  UrlLauncherPlatform.instance = fake;
  return fake;
}

/// path_provider falso apontando para um diretório temporário.
class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;

  @override
  Future<String?> getTemporaryPath() async => dir.path;

  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

Directory installFakePathProvider() {
  final dir = Directory.systemTemp.createTempSync('morar_reservation');
  PathProviderPlatform.instance = FakePathProvider(dir);
  addTearDown(() => dir.deleteSync(recursive: true));
  return dir;
}

/// Faz `Clipboard.setData` (e demais métodos de `SystemChannels.platform`)
/// responderem sem erro; devolve a lista de chamadas.
List<MethodCall> mockPlatformChannel() {
  final calls = <MethodCall>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (call) async {
    calls.add(call);
    return null;
  });
  addTearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, null));
  return calls;
}
