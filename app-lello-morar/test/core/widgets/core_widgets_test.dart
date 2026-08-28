import 'package:essentials/essentials.dart' hide isNull, isNotNull, CustomRadioListTile, PhoneFormField;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/app_version_widget.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/custom_radio_list_tile.dart';
import 'package:morar/core/widgets/error_message_widget.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/page_view_indicator.dart';
import 'package:morar/core/widgets/permission_notification_page.dart';
import 'package:morar/core/widgets/phone_form_field.dart';
import 'package:morar/core/widgets/rate_dialog.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_application_container.dart';

void main() {
  setUpAll(() async {
    await installTestEnvironment();
    ApplicationContainer.instance().locator.registerFactory<Validator>(() => ValidatorImpl());
    PackageInfo.setMockInitialValues(
      appName: 'morar',
      packageName: 'app.lello.morar',
      version: '1.2.3',
      buildNumber: '45',
      buildSignature: '',
    );
  });

  testWidgets('LoadingWidget mostra progresso e texto', (tester) async {
    await pumpApp(tester, const LoadingWidget(), localized: true, settle: false);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('please_wait'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/loading_widget.png'));
  });

  testWidgets('ErrorMessageWidget centraliza a mensagem', (tester) async {
    await pumpApp(tester, const ErrorMessageWidget(message: 'Algo deu errado'),
        shrinkWrap: false, surface: const Size(400, 300));
    expect(find.text('Algo deu errado'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/error_message_widget.png'));
  });

  testWidgets('PageViewIndicator acompanha a página', (tester) async {
    final notifier = ValueNotifier<int>(0);
    await pumpApp(tester, PageViewIndicator(itemCount: 3, pageNotifier: notifier));
    expect(find.byType(Container), findsNWidgets(3));
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/page_view_indicator_0.png'));
    notifier.value = 2;
    await tester.pumpAndSettle();
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/page_view_indicator_2.png'));
  });

  testWidgets('CustomRadioListTile chama onChanged ao tocar', (tester) async {
    final changes = <String?>[];
    await pumpApp(
      tester,
      Column(
        children: [
          CustomRadioListTile<String>(
            title: 'Opção A',
            groupValue: 'a',
            value: 'a',
            onChanged: changes.add,
          ),
          CustomRadioListTile<String>.custom(
            titleWidget: const Text('Opção B'),
            groupValue: 'a',
            value: 'b',
            onChanged: changes.add,
          ),
        ],
      ),
    );
    await tester.tap(find.text('Opção A'));
    expect(changes, isEmpty, reason: 'valor já selecionado não dispara');
    await tester.tap(find.text('Opção B'));
    expect(changes, ['b']);
    await tester.tap(find.byType(Radio<String>).last);
    expect(changes, ['b', 'b']);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/custom_radio_list_tile.png'));
  });

  testWidgets('WhiteAppBar e CustomAppBar', (tester) async {
    var whitePressed = 0;
    await pumpApp(
      tester,
      Scaffold(
        appBar: WhiteAppBar(title: 'my_preferences', isGetString: true, onPressed: () => whitePressed++),
        body: const SizedBox(),
      ),
      localized: true,
      wrapInScaffold: false,
    );
    expect(find.text('my_preferences'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    expect(whitePressed, 1);
    await tester.pump();
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/white_app_bar.png'));

    await pumpApp(
      tester,
      Scaffold(appBar: const WhiteAppBar(title: 'Título fixo'), body: const SizedBox()),
      wrapInScaffold: false,
    );
    expect(find.text('Título fixo'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios), findsNothing);

    var customPressed = 0;
    await pumpApp(
      tester,
      Scaffold(
        appBar: CustomAppBar(
          title: 'Auto',
          useGetString: false,
          autoSizeTitle: true,
          onPressed: () => customPressed++,
          actions: const [Icon(Icons.info)],
        ),
        body: const SizedBox(),
      ),
      wrapInScaffold: false,
    );
    expect(find.text('Auto'), findsOneWidget);
    expect(find.byIcon(Icons.info), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(customPressed, 1);
    expect(const CustomAppBar(title: 'x').preferredSize.height, 60);
    expect(const WhiteAppBar(title: 'x').preferredSize.height, 60);
    await tester.pump();
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/custom_app_bar.png'));
  });

  testWidgets('CustomAppBar volta por padrão', (tester) async {
    final observer = RecordingNavigatorObserver();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const Scaffold(
              appBar: CustomAppBar(title: 'billets'),
              body: SizedBox(),
            ),
          )),
          child: const Text('abrir'),
        ),
      ),
      localized: true,
      navigatorObserver: observer,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('billets'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
    expect(find.text('abrir'), findsOneWidget);
  });

  testWidgets('RateDialog fecha pelo segundo botão', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(context: context, builder: (_) => const RateDialog()),
          child: const Text('abrir'),
        ),
      ),
      localized: true,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('rate_dialog_title'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNWidgets(5));
    await expectLater(find.byType(RateDialog), matchesGoldenFile('goldens/rate_dialog.png'));
    await tester.tap(find.text('rate_dialog_button'));
    await tester.pump();
    expect(find.byType(RateDialog), findsOneWidget);
    await tester.tap(find.text('rate_dialog_second_button'));
    await tester.pumpAndSettle();
    expect(find.byType(RateDialog), findsNothing);
  });

  testWidgets('AppVersionWidget mostra versão e ambiente', (tester) async {
    await pumpApp(tester, const AppVersionWidget(), localized: true);
    expect(find.text('version'), findsOneWidget);
    expect(find.text('V1.2.3'), findsOneWidget);
    expect(find.text('test'), findsOneWidget);
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/app_version_widget.png'));
  });

  testWidgets('PhoneFormField compõe DDD e número', (tester) async {
    final formKey = GlobalKey<FormState>();
    String? saved;
    await pumpApp(
      tester,
      Form(
        key: formKey,
        child: PhoneFormField(
          focusNode: FocusNode(),
          onSaved: (v) => saved = v,
          initialValue: '(11) 999998888',
        ),
      ),
      localized: true,
    );
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.first, '21');
    await tester.enterText(fields.last, '988887777');
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);
    formKey.currentState!.save();
    expect(saved, '(21)988887777');
    await expectLater(findGoldenSurface(), matchesGoldenFile('goldens/phone_form_field.png'));

    await tester.enterText(fields.last, '');
    await tester.pump();
    await tester.enterText(fields.first, '');
    await tester.pump();
    expect(formKey.currentState!.validate(), isFalse);
  });

  testWidgets('PhoneFormField interpreta valores iniciais sem parênteses', (tester) async {
    await pumpApp(
      tester,
      PhoneFormField(focusNode: FocusNode(), initialValue: '11999998888'),
      localized: true,
    );
    expect(find.text('11'), findsOneWidget);
    expect(find.text('999998888'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await pumpApp(
      tester,
      PhoneFormField(focusNode: FocusNode(), initialValue: '9999', enabled: false),
      localized: true,
    );
    expect(find.text('9999'), findsOneWidget);
  });

  group('PermissionNotificationPage', () {
    late FakePermissionHandler permission;
    late FakeSessionBloc sessionBloc;

    setUp(() {
      permission = FakePermissionHandler();
      setFakePermissionHandler(permission);
      sessionBloc = FakeSessionBloc();
    });

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.runAsync(() async {});
      await tester.pumpWidget(
        BlocProvider<SessionBloc>.value(
          value: sessionBloc,
          child: MaterialApp(
            localizationsDelegates: const [
              TestLocDelegateForPage(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR')],
            routes: {
              SharedApplicationRoute.home: (_) => const Scaffold(body: Text('home')),
            },
            onGenerateRoute: (settings) => MaterialPageRoute(
              settings: RouteSettings(
                name: settings.name,
                arguments: PermissionNotificationPageArgs(isGeneric: false),
              ),
              builder: (_) => const PermissionNotificationPage(),
            ),
            initialRoute: '/permission',
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('aceitar pede a permissão e vai para a home', (tester) async {
      await pumpPage(tester);
      expect(find.text('notification_permission_title'), findsOneWidget);
      await tester.tap(find.text('notification_permission_btn_accept'));
      await tester.pumpAndSettle();
      expect(permission.requestCount, 1);
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('recusar vai direto para a home', (tester) async {
      await pumpPage(tester);
      await tester.tap(find.text('notification_permission_btn_recused'));
      await tester.pumpAndSettle();
      expect(permission.requestCount, 0);
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('permanentemente negado oferece as configurações', (tester) async {
      permission.status = PermissionStatus.permanentlyDenied;
      await pumpPage(tester);
      await tester.tap(find.text('notification_permission_br_configurations'));
      await tester.pumpAndSettle();
      expect(permission.settingsOpened, isTrue);
      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });
  });
}

/// Delegate mínimo para páginas que usam `getString` fora do `pumpApp`.
class TestLocDelegateForPage extends LocalizationsDelegate<AppLocalization> {
  const TestLocDelegateForPage();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalization> load(Locale locale) async => _KeyLoc();

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) => false;
}

class _KeyLoc extends AppLocalization {
  _KeyLoc() : super(const Locale('pt', 'BR'));

  @override
  String? translate(String key) => key;
}
