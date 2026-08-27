// Apoio dos testes de `feature/notifications`: sessão falsa (o
// `NotificationController` recebe `dynamic sessionBloc`), container de teste
// com `AuthenticationStore` falso (para a `CustomCachedNetworkImage`),
// harness com as classes REAIS (API chopper → data source → repositório →
// use cases → controller/bloc) ligadas ao `FakeHttp` e fixtures de JSON.
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/notifications/data/data_source/notifications_api.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/feature/notifications/data/models/notification_resume_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_http.dart';
import '../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Sessão falsa (dinâmica)
// ---------------------------------------------------------------------------

class FakeLayout {
  FakeLayout({this.companyName = 'Condomínio Teste'});
  final String? companyName;
}

class FakeCondominium {
  FakeCondominium({
    this.id = 'C1',
    this.reference = 'R1',
    FakeLayout? layout,
    this.withLayout = true,
  }) : _layout = layout ?? FakeLayout();
  final String id;
  final String? reference;
  final FakeLayout _layout;
  final bool withLayout;
  FakeLayout? get layout => withLayout ? _layout : null;
}

class FakeUnity {
  FakeUnity({this.id = 'U1', this.title = '101'});
  final String id;
  final String? title;
}

class FakeMe {
  FakeMe({this.id = 'ME1'});
  final String id;
}

class FakeSession {
  FakeSession({
    FakeCondominium? condominium,
    FakeCondominium? selectedCondominium,
    FakeUnity? unity,
    FakeMe? me,
    this.withCondominium = true,
    this.withUnity = true,
    this.withMe = true,
  })  : _condominium = condominium ?? FakeCondominium(),
        _selectedCondominium =
            selectedCondominium ?? FakeCondominium(id: 'SC1', reference: 'SR1'),
        _unity = unity ?? FakeUnity(),
        _me = me ?? FakeMe();

  final FakeCondominium _condominium;
  final FakeCondominium _selectedCondominium;
  final FakeUnity _unity;
  final FakeMe _me;
  final bool withCondominium;
  final bool withUnity;
  final bool withMe;

  FakeCondominium? get condominium => withCondominium ? _condominium : null;
  FakeCondominium? get selectedCondominium =>
      withCondominium ? _selectedCondominium : null;
  FakeUnity? get unity => withUnity ? _unity : null;
  FakeMe? get me => withMe ? _me : null;
}

class FakeSessionState {
  FakeSessionState(this.session);

  /// Dinâmico de propósito: `null` simula sessão ausente.
  final dynamic session;
}

/// `sessionBloc` dinâmico do controller/widgets: `state.session` (morador e
/// síndico) e `getSession` (colaborador).
class FakeSessionBloc {
  FakeSessionBloc({dynamic session, bool withSession = true})
      : state = FakeSessionState(withSession ? (session ?? FakeSession()) : null);

  FakeSessionState state;

  /// Colaborador: `sessionBloc.getSession?.condominium.id`.
  dynamic get getSession => state.session;
}

/// Bloc de sessão que não tem `state` — o `getCurrentContext` engole só
/// `Exception`, então um `NoSuchMethodError` (que é `Error`) sobe.
class BrokenSessionBloc {
  dynamic get state => throw Exception('sem sessão');
  dynamic get getSession => throw Exception('sem sessão');
}

// ---------------------------------------------------------------------------
// Fakes de infraestrutura
// ---------------------------------------------------------------------------

/// PNG 1x1 gerado pelo `package:image` (bytes válidos para o codec).
final List<int> pngBytes = img.encodePng(img.Image(width: 1, height: 1));

/// Os ícones `assets/ic_notifications_*.png` de `iconFromModule` são
/// declarados pelos APPS (o pacote não os tem): este bundle entrega um PNG
/// vazio para eles e delega o resto ao `rootBundle`.
class NotificationsAssetBundle extends CachingAssetBundle {
  final loaded = <String>[];

  @override
  Future<ByteData> load(String key) {
    if (key.startsWith('assets/ic_notifications_')) {
      loaded.add(key);
      return Future.value(ByteData.sublistView(Uint8List.fromList(pngBytes)));
    }
    return rootBundle.load(key);
  }
}

/// Envolve [child] com o bundle falso dos ícones de notificação.
Widget withNotificationAssets(Widget child, {NotificationsAssetBundle? bundle}) =>
    DefaultAssetBundle(
        bundle: bundle ?? NotificationsAssetBundle(), child: child);

/// A `CustomCachedNetworkImage` só pede o header ao store; sem header ela
/// cai no SVG local (sem cache manager/IO nos testes).
class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  FakeAuthenticationStore({this.header});
  final Map<String, String>? header;

  @override
  Map<String, String>? getCustomHeader() => header;
}

/// `HomeNavigationPage` exigido pela `NotificationListPage` (só é guardado).
class DummyHomePage extends StatefulWidget {
  const DummyHomePage({Key? key}) : super(key: key);

  @override
  State<DummyHomePage> createState() => _DummyHomePageState();
}

class _DummyHomePageState extends State<DummyHomePage> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ---------------------------------------------------------------------------
// Harness com as classes reais ligadas ao FakeHttp
// ---------------------------------------------------------------------------

class NotificationsHarness {
  NotificationsHarness({
    this.origin = AppOriginEnum.owner,
    dynamic sessionBloc,
  }) : sessionBloc = sessionBloc ?? FakeSessionBloc() {
    api = NotificationsApi.create(buildChopperClient(http));
    dataSource = NotificationsRemoteDataSourceImpl(api: api);
    repository = NotificationsRepositoryImpl(remoteDataSource: dataSource);
    container.register<AuthenticationStore>(FakeAuthenticationStore());
  }

  final AppOriginEnum origin;
  final dynamic sessionBloc;
  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  late final NotificationsApi api;
  late final NotificationsRemoteDataSourceImpl dataSource;
  late final NotificationsRepositoryImpl repository;

  /// Último controller construído.
  NotificationController? controller;

  NotificationController buildController({NotificationListBloc? bloc}) {
    final c = NotificationController(
      bloc: bloc ?? NotificationListBloc(),
      sessionBloc: sessionBloc,
      getNotifications: GetNotificationsImpl(repository: repository),
      readNotifications: ReadNotificationsImpl(repository: repository),
      markAllReadNotificationUseCase:
          MarkAllReadNotificationImpl(repository: repository),
      deleteAllReadNotificationUseCase:
          DeleteAllReadNotificationImpl(repository: repository),
      deleteNotificationUseCase: DeleteNotificationImpl(repository: repository),
      notificationResumeUseCase: NotificationResumeImpl(repository: repository),
      appOriginEnum: origin,
    );
    controller = c;
    return c;
  }

  /// Caminho da paginação para a referência da sessão do [origin].
  String get listPath {
    final ref = origin == AppOriginEnum.owner
        ? 'U1'
        : origin == AppOriginEnum.employee
            ? 'C1'
            : 'SC1';
    return '/dashboard/$ref/pendencies/pagination';
  }

  /// Cadastra a listagem (página 1) e o resumo.
  void stubList(List<Map<String, dynamic>> items,
      {int totalItems = 0, Map<String, dynamic>? resume}) {
    http.on('GET', listPath,
        body: paginatorJson(items, totalItems: totalItems));
    http.on('GET', '/dashboard/pendencies/resume',
        body: resume ?? resumeJson());
  }

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

/// Emite [state] direto no [bloc] e espera a tela reagir.
Future<void> emitState(
  WidgetTester tester,
  Bloc bloc,
  Object state, {
  bool settle = true,
}) async {
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  bloc.emit(state);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump();
  }
}

/// `DateFormat` com `pt_BR` exige os símbolos carregados.
Future<void> initDates() => initializeDateFormatting('pt_BR');

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> notificationJson({
  String id = 'n1',
  String? title = 'Título 1',
  String? message = 'Mensagem 1',
  String? module = 'BOLETOS',
  bool markRead = false,
  String? reference = 'U1',
  String? redirectPath = 'BOLETOS',
  String? typeRedirect = 'FEATURE',
  String? redirectId = 'b1',
  String? hash,
  String? bigMessage,
  String? senderId,
  String? uuidGroup,
  DateTime? date,
  String? type = 'PUSH',
}) =>
    {
      'id': id,
      'date': (date ?? DateTime(2026, 1, 10, 9, 30)).toIso8601String(),
      'title': title,
      'message': message,
      'visualized_at': null,
      'status': 'ATIVO',
      'reference': reference,
      'identifier': 'ident-$id',
      'module': module,
      'type': type,
      'mark_read': markRead,
      'in_app': true,
      'type_redirect': typeRedirect,
      'redirect_path': redirectPath,
      'redirect_id': redirectId,
      'callback': 'cb',
      'hash': hash,
      'big_message': bigMessage,
      'sender_id': senderId,
      'uuid_group': uuidGroup,
    };

Map<String, dynamic> paginatorJson(List<Map<String, dynamic>> data,
        {int totalItems = 0}) =>
    {
      'meta': {
        'currentPage': 1,
        'totalPages': 1,
        'itemCount': data.length,
        'itemPerPage': 10,
        'totalItems': totalItems == 0 ? data.length : totalItems,
      },
      'data': data,
    };

Map<String, dynamic> resumeJson({
  int totalRead = 3,
  int totalIgnored = 1,
  int totalExcluded = 0,
  int totalReceived = 2,
}) =>
    {
      'total_read': totalRead,
      'total_ignored': totalIgnored,
      'total_excluded': totalExcluded,
      'total_received': totalReceived,
    };

SingleNotification buildNotification({
  String id = 'n1',
  String? title = 'Título 1',
  String? message = 'Mensagem 1',
  String? module = 'BOLETOS',
  bool? markRead = false,
  String? reference = 'U1',
  String? redirectPath = 'BOLETOS',
  String? typeRedirect = 'FEATURE',
  String? redirectId = 'b1',
  String? hash,
  String? bigMessage,
  String? senderId,
  String? uuidGroup,
  DateTime? date,
  int page = 1,
}) =>
    NotificationModel.fromJson(notificationJson(
      id: id,
      title: title,
      message: message,
      module: module,
      markRead: markRead ?? false,
      reference: reference,
      redirectPath: redirectPath,
      typeRedirect: typeRedirect,
      redirectId: redirectId,
      hash: hash,
      bigMessage: bigMessage,
      senderId: senderId,
      uuidGroup: uuidGroup,
      date: date,
    )).toEntity(page: page)
      ..markRead = markRead;

NotificationResumeModel buildResumeModel() => NotificationResumeModel(
      totalRead: 3,
      totalIgnored: 1,
      totalExcluded: 0,
      totalReceived: 2,
    );
