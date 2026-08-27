import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_state.dart';
import 'package:morar/feature/change_ownership/presentation/controller/ownership_controller.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_page.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_resume_page.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_sucess_page.dart';
import 'package:morar/feature/change_ownership/presentation/widget/cant_change_dialog.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_document_input.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_dropdown.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_generic_input.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'change_ownership_page_helpers.dart';

// Fallback nativo do UrlLauncherNative: sem plugin ele precisa responder com
// PlatformException.
const _nativeUrlChannel = MethodChannel('com.example.app/url_launcher');

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late FakePickers pickers;
  late FakeUrlLauncherPlatform launcher;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    pickers = installFakePickers();
    launcher = installFakeUrlLauncher();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_nativeUrlChannel,
            (call) async => throw PlatformException(code: 'sem-plugin'));
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_nativeUrlChannel, null);
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.changeOwnership: (_) => const ChangeOwnership(),
    ApplicationRoute.changeOwnershipResume: (_) =>
        const ChangeOwnershipResumePage(),
  };

  OwnershipController controller() => harness.resolve<OwnershipController>();

  // Corrigido: a linha de opções de anexo e os botões do diálogo usam
  // Flexible, então as chaves cruas (mais longas que o texto real) cabem em
  // 400px sem overflow.
  const loc = <String, String>{};

  void mockCanChange({bool canChange = true, String? message}) =>
      harness.http.on('GET', canChangePath,
          body: canChangeJson(canChange: canChange, message: message));

  Finder dropdowns() => find.byType(DropdownButtonFormField<String>);

  /// SvgPicture de um asset (ícones de galeria/câmera/anexo/documento).
  Finder svg(String asset) => find.byWidgetPredicate(
      (w) => w is SvgPicture && (w.bytesLoader as SvgAssetLoader).assetName == asset,
      description: asset);
  Finder galleryIcon() => svg('assets/ic_photo_bold.svg');
  Finder cameraIcon() => svg('assets/ic_camera_bold.svg');
  Finder fileIcon() => svg('assets/ic_attachment_bold.svg');
  Finder inputs() => find.byType(TextFormField);

  /// Seleciona [item] no [index]-ésimo dropdown do formulário
  /// (0 = tipo de pessoa, 1 = sexo, 2 = nacionalidade, 3 = estado civil).
  Future<void> pick(WidgetTester tester, int index, String item) async {
    await tester.ensureVisible(dropdowns().at(index));
    await tester.tap(dropdowns().at(index));
    await tester.pumpAndSettle();
    await tester.tap(find.text(item).last);
    await tester.pumpAndSettle();
  }

  /// Preenche o [index]-ésimo campo de texto (0 = CPF/CNPJ, 1 = matrícula,
  /// 2 = nome, 3 = RG, 4 = data, 5 = e-mail, 6 = profissão, 7 = telefone,
  /// 8 = celular).
  Future<void> type(WidgetTester tester, int index, String text) async {
    await tester.ensureVisible(inputs().at(index));
    await tester.enterText(inputs().at(index), text);
    await tester.pump();
  }

  Future<void> fillIndividual(WidgetTester tester) async {
    await pick(tester, 0, 'Pessoa Física');
    await type(tester, 0, '52998224725');
    await type(tester, 1, '12345');
    await type(tester, 2, 'Maria da Silva');
    await pick(tester, 1, 'Feminino');
    await type(tester, 3, '123456789');
    await type(tester, 4, '01011990');
    await type(tester, 5, 'maria@lello.com');
    await pick(tester, 2, 'Brasileiro');
    await type(tester, 6, 'Engenheira');
    await pick(tester, 3, 'Casado');
    await type(tester, 7, '1133334444');
    await type(tester, 8, '11999998888');
  }

  Future<void> tapNext(WidgetTester tester) async {
    await tester.ensureVisible(find.text('next'));
    await tester.tap(find.text('next'));
    await tester.pumpAndSettle();
  }

  group('ChangeOwnership', () {
    testWidgets('carrega a permissão e mostra o formulário desabilitado',
        (tester) async {
      mockCanChange();

      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          surface: const Size(400, 1600));

      expect(harness.http.requests.single.url.path, canChangePath);
      expect(controller().bloc.state, isA<ChangeOwnershipLoadedState>());
      expect(find.byType(CantChangeDialog), findsNothing);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('change_ownership_title'), findsOneWidget);
      expect(find.byType(ChangeOwnershipDropdown), findsNWidgets(4));
      expect(find.byType(ChangeOwnershipGenericInput), findsNWidgets(8));
      expect(find.byType(ChangeOwnershipDocumentInput), findsOneWidget);
      // Sem tipo de pessoa o documento aparece genérico e tudo fica opaco.
      expect(find.text('change_ownership_cpf_or_cnpj*'), findsOneWidget);
      expect(
          tester
              .widgetList<Opacity>(find.byType(Opacity))
              .where((o) => o.opacity == 0.3)
              .length,
          greaterThan(10));
      final next = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(next.onPressed, isNull);
      await expectLater(
        find.byType(ChangeOwnership),
        matchesGoldenFile('goldens/change_ownership_page.png'),
      );
    });

    testWidgets('quando não pode alterar abre o aviso e "depois" fecha a tela',
        (tester) async {
      mockCanChange(canChange: false, message: 'Já existe uma solicitação.');

      await pumpPage(tester, locOverrides: loc,
        RouteLauncher(route: ApplicationRoute.changeOwnership),
        routes: routes,
        observer: observer,
      );

      expect(find.byType(CantChangeDialog), findsOneWidget);
      expect(find.text('Atenção!'), findsOneWidget);
      expect(find.text('Já existe uma solicitação.'), findsOneWidget);
      expect(
          find.textContaining(FlavorConfig.config.supportMoradorWhatsAppNumber,
              findRichText: true),
          findsOneWidget);
      await expectLater(
        find.byType(CantChangeDialog),
        matchesGoldenFile('goldens/cant_change_dialog.png'),
      );

      // Barreira não fecha (barrierDismissible: false) nem o voltar do sistema.
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(CantChangeDialog), findsOneWidget);

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();

      expect(find.byType(CantChangeDialog), findsNothing);
      expect(find.byType(ChangeOwnership), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('no aviso, o botão do WhatsApp abre a conversa e fecha a tela',
        (tester) async {
      mockCanChange(canChange: false, message: 'Bloqueado');

      await pumpPage(tester, locOverrides: loc,
        RouteLauncher(route: ApplicationRoute.changeOwnership),
        routes: routes,
        observer: observer,
      );

      await tester.tap(find.text('REGISTRATION_LELLO_WARNING_NO_DATA_BTN'));
      await tester.pumpAndSettle();

      expect(launcher.launched, hasLength(1));
      expect(launcher.launched.single,
          contains(FlavorConfig.config.supportMoradorWhatsAppNumber));
      expect(find.byType(CantChangeDialog), findsNothing);
      expect(find.byType(ChangeOwnership), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('erro mostra o widget de erro com retry e voltar',
        (tester) async {
      harness.http.failAll();

      await pumpPage(tester, locOverrides: loc,
        RouteLauncher(route: ApplicationRoute.changeOwnership),
        routes: routes,
        observer: observer,
      );
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(find.text('back'), findsOneWidget);

      mockCanChange();
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(ErrorHandlingWidget), findsNothing);
      expect(find.text('change_ownership_title'), findsOneWidget);
    });

    testWidgets('voltar do erro fecha a tela', (tester) async {
      harness.http.failAll();

      await pumpPage(tester, locOverrides: loc,
        RouteLauncher(route: ApplicationRoute.changeOwnership),
        routes: routes,
        observer: observer,
      );

      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();

      expect(find.byType(ChangeOwnership), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('loading mostra o indicador', (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership());

      await emitState(
          tester, controller().bloc, const ChangeOwnershipLoadingState(),
          settle: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('pessoa física: validação bloqueia o avanço até preencher tudo',
        (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));

      await pick(tester, 0, 'Pessoa Física');
      expect(find.text('cpf*'), findsOneWidget);
      expect(find.text('change_ownership_sex*'), findsOneWidget);
      expect(find.text('change_ownership_rg*'), findsOneWidget);
      expect(find.text('change_ownership_date*'), findsOneWidget);
      expect(find.text('change_ownership_nationality*'), findsOneWidget);
      expect(find.text('change_ownership_profession*'), findsOneWidget);
      expect(find.text('change_ownership_marital_status*'), findsOneWidget);

      await type(tester, 5, 'email-invalido');
      await type(tester, 4, '99999999');
      await tapNext(tester);

      expect(find.text('validation_required'), findsWidgets);
      expect(find.text('validation_invalid_landline'), findsOneWidget);
      expect(find.text('validation_invalid_phone'), findsOneWidget);
      expect(find.text('validation_invalid_email'), findsOneWidget);
      expect(find.text('validation_invalid_date'), findsOneWidget);
      expect(observer.pushedNames, isNot(contains(ApplicationRoute.changeOwnershipResume)));

      // CPF inválido e RG curto continuam bloqueando.
      await type(tester, 0, '11111111111');
      await type(tester, 3, '123');
      await tapNext(tester);
      expect(find.text('validation_invalid_cpf'), findsOneWidget);
      expect(find.textContaining('12'), findsWidgets);
      expect(observer.pushedNames, isNot(contains(ApplicationRoute.changeOwnershipResume)));
    });

    testWidgets('sem anexo o avanço mostra o aviso', (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));

      await fillIndividual(tester);
      expect(find.text('529.982.247-25'), findsOneWidget);
      expect(find.text('12.345.678-9'), findsOneWidget);
      expect(find.text('01/01/1990'), findsOneWidget);
      expect(find.text('(11) 3333-4444'), findsOneWidget);
      expect(find.text('(11) 99999-8888'), findsOneWidget);

      await tapNext(tester);

      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Obrigatório anexar um documento'), findsOneWidget);
      expect(observer.pushedNames, isNot(contains(ApplicationRoute.changeOwnershipResume)));
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    });

    testWidgets('foto da galeria vira anexo, pode ser removida e o fluxo avança',
        (tester) async {
      mockCanChange();
      final image = tempImage();
      pickers.image.path = image.path;
      pickers.cropper.path = image.path;
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));

      await fillIndividual(tester);
      await tester.ensureVisible(galleryIcon());
      await tester.tap(galleryIcon());
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();

      expect(pickers.image.sources, [ImageSource.gallery]);
      expect(pickers.cropper.cropped, [image.path]);
      expect(controller().entity.attachment?.path, image.path);
      expect(controller().entity.attachmentType, 'image');
      expect(find.text('reports_request_pick_image_from_gallery'), findsNothing);
      expect(find.byType(FileImage), findsNothing);
      expect(find.byType(IconButton), findsWidgets);

      // Remover o anexo volta para as três opções.
      final removeButton = find.byWidgetPredicate(
          (w) => w is IconButton && w.icon is SvgPicture,
          description: 'remover anexo');
      await tester.ensureVisible(removeButton);
      await tester.tap(removeButton);
      await tester.pumpAndSettle();
      expect(controller().entity.attachment, isNull);
      expect(find.text('reports_request_pick_image_from_gallery'), findsOneWidget);

      // Anexa de novo pela câmera e avança para o resumo.
      await tester.ensureVisible(cameraIcon());
      await tester.tap(cameraIcon());
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();
      expect(pickers.image.sources.last, ImageSource.camera);
      expect(controller().entity.attachment, isNotNull);

      await tapNext(tester);

      expect(observer.pushedNames.last, ApplicationRoute.changeOwnershipResume);
      expect(find.byType(ChangeOwnershipResumePage), findsOneWidget);
      final entity = controller().entity;
      expect(entity.personType, 'FISICA');
      expect(entity.document, '529.982.247-25');
      expect(entity.registration, '12345');
      expect(entity.name, 'Maria da Silva');
      expect(entity.sex, 'FEMININO');
      expect(entity.rg, '12.345.678-9');
      expect(entity.date, '01/01/1990');
      expect(entity.email, 'maria@lello.com');
      expect(entity.nationality, 'BRASILEIRO');
      expect(entity.profession, 'Engenheira');
      expect(entity.maritalStatus, 'CASADO');
      expect(entity.phone, '(11) 3333-4444');
      expect(entity.cellphone, '(11) 99999-8888');
    });

    testWidgets('cancelar a galeria ou o recorte não anexa nada',
        (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));
      await pick(tester, 0, 'Pessoa Física');
      await tester.ensureVisible(cameraIcon());

      // Usuário cancela o seletor.
      pickers.image.path = null;
      await tester.tap(galleryIcon());
      await tester.pumpAndSettle();
      expect(controller().entity.attachment, isNull);

      // Usuário cancela o recorte.
      final image = tempImage();
      pickers.image.path = image.path;
      pickers.cropper.path = null;
      await tester.tap(cameraIcon());
      await tester.pumpAndSettle();
      expect(pickers.cropper.cropped, [image.path]);
      expect(controller().entity.attachment, isNull);
    });

    testWidgets('arquivo PDF vira anexo com o ícone de documento',
        (tester) async {
      mockCanChange();
      final file = tempFile();
      pickers.file.file = file;
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));
      await pick(tester, 0, 'Pessoa Física');
      await tester.ensureVisible(fileIcon());

      await tester.tap(fileIcon());
      await tester.pumpAndSettle();

      expect(pickers.file.picks, 1);
      expect(controller().entity.attachment?.path, file.path);
      expect(controller().entity.attachmentType, 'application/pdf');
      expect(find.text('reports_create_attachment'), findsNothing);
      expect(svg('assets/ic_documents.svg'), findsOneWidget);
    });

    testWidgets('arquivo cancelado ou acima do tamanho não é anexado',
        (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));
      await pick(tester, 0, 'Pessoa Física');
      await tester.ensureVisible(fileIcon());

      pickers.file.file = null;
      await tester.tap(fileIcon());
      await tester.pumpAndSettle();
      expect(pickers.file.picks, 1);
      expect(controller().entity.attachment, isNull);

      // Limite de tamanho vindo do remote config (1 byte).
      harness.remoteConfig.values = {'file_max_size_permitted': '1'};
      pickers.file.file = tempFile(size: 2);
      await tester.tap(fileIcon());
      await tester.pumpAndSettle();
      expect(pickers.file.picks, 2);
      expect(controller().entity.attachment, isNull);
      expect(controller().entity.attachmentType, isNull);
      expect(find.text('reports_create_attachment'), findsOneWidget);
    });

    testWidgets('pessoa jurídica: só os campos básicos são obrigatórios',
        (tester) async {
      mockCanChange();
      final image = tempImage();
      pickers.image.path = image.path;
      pickers.cropper.path = image.path;
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          observer: observer, routes: routes, surface: const Size(400, 1800));

      await pick(tester, 0, 'Pessoa Jurídica');
      expect(find.text('cnpj*'), findsOneWidget);
      expect(find.text('change_ownership_sex'), findsOneWidget);
      expect(find.text('change_ownership_rg'), findsOneWidget);
      expect(find.text('change_ownership_date'), findsOneWidget);
      expect(find.text('change_ownership_profession'), findsOneWidget);

      await type(tester, 0, '11222333000181');
      expect(find.text('11.222.333/0001-81'), findsOneWidget);
      await type(tester, 1, '777');
      await type(tester, 2, 'Empresa LTDA');
      await type(tester, 5, 'empresa@lello.com');
      await type(tester, 7, '1133334444');
      await type(tester, 8, '11999998888');
      await tester.ensureVisible(galleryIcon());
      await tester.tap(galleryIcon());
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pumpAndSettle();

      await tapNext(tester);

      expect(observer.pushedNames.last, ApplicationRoute.changeOwnershipResume);
      final entity = controller().entity;
      expect(entity.personType, 'JURIDICA');
      expect(entity.document, '11.222.333/0001-81');
      expect(entity.sex, isNull);
      expect(entity.rg, isNull);
      expect(entity.date, isNull);
      expect(entity.profession, isNull);
      expect(entity.nationality, isNull);
      expect(entity.maritalStatus, isNull);
      // O resumo mostra "-" para o que não foi informado.
      expect(find.text('-'), findsNWidgets(4));
    });

    testWidgets('trocar o tipo de pessoa limpa o formulário', (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          surface: const Size(400, 1800));

      await pick(tester, 0, 'Pessoa Física');
      await type(tester, 2, 'Maria');
      await tapNext(tester);
      expect(find.text('validation_required'), findsWidgets);

      await pick(tester, 0, 'Pessoa Jurídica');
      await tester.pumpAndSettle();
      expect(find.text('validation_required'), findsNothing);
      expect(find.text('cnpj*'), findsOneWidget);

      // Selecionar o mesmo tipo de novo não faz nada.
      await pick(tester, 0, 'Pessoa Jurídica');
      expect(find.text('cnpj*'), findsOneWidget);
    });

    testWidgets('o calendário preenche a data de nascimento', (tester) async {
      mockCanChange();
      await pumpPage(tester, locOverrides: loc, const ChangeOwnership(),
          surface: const Size(400, 1800));
      await pick(tester, 0, 'Pessoa Física');

      await tester.ensureVisible(find.byIcon(Icons.calendar_month));
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final today = DateFormat.yMd('pt_BR').format(DateTime.now());
      expect(find.byType(DatePickerDialog), findsNothing);
      expect(find.text(today), findsOneWidget);
    });
  });

  group('ChangeOwnershipResumePage', () {
    Future<OwnershipController> prepare(WidgetTester tester,
        {FakeUploader? uploader, String? attachmentType}) async {
      await harness.override<Uploader>(uploader ?? FakeUploader());
      final c = controller();
      c.entity
        ..personType = 'FISICA'
        ..document = '529.982.247-25'
        ..registration = '12345'
        ..name = 'Maria da Silva'
        ..sex = 'FEMININO'
        ..rg = '12.345.678-9'
        ..date = '01/01/1990'
        ..email = 'maria@lello.com'
        ..nationality = 'BRASILEIRO'
        ..profession = 'Engenheira'
        ..maritalStatus = 'CASADO'
        ..phone = '(11) 3333-4444'
        ..cellphone = '(11) 99999-8888';
      if (attachmentType == 'image') {
        c.entity
          ..attachment = tempImage()
          ..attachmentType = 'image';
      } else if (attachmentType != null) {
        c.entity
          ..attachment = tempFile()
          ..attachmentType = attachmentType;
      }
      // A tela de resumo recebe o controller já carregado pela tela anterior.
      mockCanChange();
      c.getCanChange();
      await tester.pump();
      return c;
    }

    testWidgets('mostra os dados informados e o anexo em imagem',
        (tester) async {
      final c = await prepare(tester, attachmentType: 'image');

      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
        surface: const Size(400, 1600),
      );

      expect(find.text('change_ownership_resume_title'), findsOneWidget);
      expect(find.text('Maria da Silva'), findsOneWidget);
      expect(find.text('529.982.247-25'), findsOneWidget);
      expect(find.text('FEMININO'), findsNothing); // sexo não aparece no resumo
      expect(find.text('BRASILEIRO'), findsOneWidget);
      expect(find.text('CASADO'), findsOneWidget);
      expect(find.text('reports_attached_file'), findsOneWidget);
      expect(find.text('send'), findsOneWidget);
      expect(find.text('Voltar para edição'), findsOneWidget);
      expect(
          find.byWidgetPredicate((w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).image?.image is FileImage),
          findsOneWidget);
      await expectLater(
        find.byType(ChangeOwnershipResumePage),
        matchesGoldenFile('goldens/change_ownership_resume_page.png'),
      );
    });

    testWidgets('anexo em PDF mostra o ícone de documento; sem anexo, nada',
        (tester) async {
      final c = await prepare(tester, attachmentType: 'application/pdf');

      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
        surface: const Size(400, 1600),
      );
      expect(svg('assets/ic_documents.svg'), findsOneWidget);

      c.entity.attachment = null;
      // Zera a árvore: um novo MaterialApp reaproveitaria a rota anterior.
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
        surface: const Size(400, 1600),
      );
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('"voltar para edição" fecha o resumo', (tester) async {
      final c = await prepare(tester, attachmentType: 'image');

      await pumpPage(tester, locOverrides: loc,
        RouteLauncher(
            route: ApplicationRoute.changeOwnershipResume,
            arguments: ChangeOwnershipResumePageArgs(controller: c)),
        routes: routes,
        observer: observer,
        surface: const Size(400, 1600),
      );

      await tester.ensureVisible(find.text('Voltar para edição'));
      await tester.tap(find.text('Voltar para edição'));
      await tester.pumpAndSettle();

      expect(find.byType(ChangeOwnershipResumePage), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('enviar pede confirmação; "voltar" só fecha o diálogo',
        (tester) async {
      final c = await prepare(tester, attachmentType: 'image');

      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
        surface: const Size(400, 1600),
      );

      await tester.ensureVisible(find.text('send'));
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Alteração de Titularidade'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsNWidgets(2));
      expect(find.text('CONFIRMAR'), findsOneWidget);

      await tester.tap(find.text('BACK'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
      expect(harness.http.requests.map((r) => r.url.path),
          isNot(contains(postChangePath)));
    });

    testWidgets('confirmar envia o anexo e a solicitação e abre o sucesso',
        (tester) async {
      final uploader = FakeUploader();
      final c = await prepare(tester, uploader: uploader, attachmentType: 'image');
      harness.http.on('GET', awsPayloadPath, body: awsPayloadJson());
      harness.http.on('POST', postChangePath, body: {'ok': true});

      await pumpPage(tester, locOverrides: loc,
        RouteLauncher(
            route: ApplicationRoute.changeOwnershipResume,
            arguments: ChangeOwnershipResumePageArgs(controller: c)),
        routes: routes,
        observer: observer,
        surface: const Size(400, 1600),
      );

      await tester.ensureVisible(find.text('send'));
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR'));
      await tester.pumpAndSettle();

      expect(uploader.uploaded, ['https://s3.local/anexo-s3.png']);
      final post = harness.http.requests.lastWhere((r) => r.method == 'POST');
      expect(post.url.path, postChangePath);
      expect(post.body, contains('"person_type":"FISICA"'));
      expect(post.body, contains('"document":"52998224725"'));
      expect(post.body, contains('"cellphone":"11999998888"'));
      expect(post.body, contains('"archives":["anexo-s3.png"]'));
      expect(c.bloc.state, isA<ChangeOwnershipSuccessState>());
      expect(find.byType(ChangeOwnershipSuccessPage), findsOneWidget);
      expect(find.text('change_ownership_success_title'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      await expectLater(
        find.byType(ChangeOwnershipSuccessPage),
        matchesGoldenFile('goldens/change_ownership_success_page.png'),
      );

      // Concluir volta para a home.
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(find.byType(ChangeOwnershipSuccessPage), findsNothing);
      expect(find.byType(ChangeOwnershipResumePage), findsNothing);
      expect(findRoute(SharedApplicationRoute.home), findsOneWidget);
    });

    testWidgets('falha no upload mostra o erro; retry reenvia e voltar restaura',
        (tester) async {
      final uploader = FakeUploader(fail: true);
      final c = await prepare(tester, uploader: uploader, attachmentType: 'image');
      harness.http.on('GET', awsPayloadPath, body: awsPayloadJson());
      harness.http.on('POST', postChangePath, body: {'ok': true});

      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
        surface: const Size(400, 1600),
      );

      await tester.ensureVisible(find.text('send'));
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR'));
      await tester.pumpAndSettle();

      expect(c.bloc.state, isA<ChangeOwnershipFailureState>());
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(find.byType(ChangeOwnershipSuccessPage), findsNothing);

      // Retry reenvia (agora com upload ok) e chega ao sucesso.
      uploader.fail = false;
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(uploader.uploaded, hasLength(2));
      expect(find.byType(ChangeOwnershipSuccessPage), findsOneWidget);
    });

    testWidgets('falha na API e "voltar" do erro restaura o resumo',
        (tester) async {
      final c = await prepare(tester, attachmentType: 'application/pdf');
      harness.http.on('GET', awsPayloadPath, body: awsPayloadJson());
      harness.http.on('POST', postChangePath, status: 500, body: {'message': 'x'});

      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
        surface: const Size(400, 1600),
      );

      await tester.ensureVisible(find.text('send'));
      await tester.tap(find.text('send'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONFIRMAR'));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();

      expect(c.bloc.state, const ChangeOwnershipLoadedState(canChange: true));
      expect(find.byType(ErrorHandlingWidget), findsNothing);
      expect(find.text('send'), findsOneWidget);
    });

    testWidgets('loading mostra o indicador', (tester) async {
      final c = await prepare(tester);

      await pumpPage(tester, locOverrides: loc,
        const ChangeOwnershipResumePage(),
        arguments: ChangeOwnershipResumePageArgs(controller: c),
      );
      await emitState(tester, c.bloc, const ChangeOwnershipLoadingState(),
          settle: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('widgets', () {
    testWidgets('ChangeOwnershipGenericInput com limpar, calendário e leitura',
        (tester) async {
      final ctrl = TextEditingController(text: 'abc');
      var cleared = 0;
      var dates = 0;
      await pumpApp(
        tester,
        ChangeOwnershipGenericInput(
          title: 'Campo',
          controller: ctrl,
          selectTypePerson: 'Pessoa Física',
          isRequired: false,
          hint: 'dica',
          borderColor: Colors.red,
          readyOnly: true,
          clear: () => cleared++,
          selectDate: () => dates++,
        ),
        localized: true,
      );

      expect(find.text('Campo'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.tap(find.byIcon(Icons.calendar_month));
      expect(cleared, 1);
      expect(dates, 1);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.readOnly, isTrue);
      expect(field.decoration?.hintText, 'dica');
    });

    testWidgets('ChangeOwnershipDropdown sem tipo de pessoa fica desabilitado',
        (tester) async {
      String? changed;
      await pumpApp(
        tester,
        ChangeOwnershipDropdown(
          title: 'Sexo',
          items: const ['Feminino', 'Masculino'],
          onChanged: (v) => changed = v,
          selectTypePerson: null,
          isRequired: false,
        ),
        localized: true,
      );

      expect(find.text('Sexo'), findsOneWidget);
      expect(find.text('gdp_timesheet_select'), findsOneWidget);
      final ignore = tester.widget<IgnorePointer>(find
          .descendant(
              of: find.byType(ChangeOwnershipDropdown),
              matching: find.byType(IgnorePointer))
          .first);
      expect(ignore.ignoring, isTrue);
      await tester.tap(find.byType(DropdownButtonFormField<String>),
          warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Masculino'), findsNothing);
      expect(changed, isNull);
    });

    testWidgets('ChangeOwnershipDocumentInput alterna entre CPF e CNPJ',
        (tester) async {
      final ctrl = TextEditingController();
      final changes = <String>[];
      await pumpApp(
        tester,
        ChangeOwnershipDocumentInput(
          documentController: ctrl,
          selectType: 'Pessoa Jurídica',
          types: const ['Pessoa Física', 'Pessoa Jurídica'],
          onChanged: changes.add,
          isIndividuals: false,
        ),
        localized: true,
      );

      expect(find.text('cnpj*'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.hintText, '00.000.000/0000-00');
      await tester.enterText(find.byType(TextField), '11222333000181');
      expect(ctrl.text, '11.222.333/0001-81');
      expect(changes, isNotEmpty);
    });
  });
}
