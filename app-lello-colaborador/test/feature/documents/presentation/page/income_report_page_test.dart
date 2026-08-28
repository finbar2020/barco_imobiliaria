import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_bloc.dart';
import 'package:colaborador/feature/documents/presentation/income_report/page/income_report_page.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';
import '../../../../helpers/test_localization.dart';

class _FakeGetDocuments extends Fake implements GetDocumentsInfoListUseCase {
  _FakeGetDocuments({
    this.fail = false,
    this.documents = const [],
    this.delay,
  });

  final bool fail;
  final List<DocumentInfo> documents;
  final Duration? delay;

  @override
  Future<Try<List<DocumentInfo>>> call(GetDocumentsInfoListParam params) async {
    if (delay != null) await Future<void>.delayed(delay!);
    if (fail) return Rejection(UnknownFailure('documents'));
    return Success(documents);
  }
}

DocumentInfo _document(int year) => DocumentInfo(
      name: 'informe-$year.pdf',
      type: DocumentTypeEnum.incomeReport,
      documentProcessingDate: DateTime(year, 3, 10),
    );

Future<void> _installContainer(_FakeGetDocuments useCase) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  final sessionBloc = FakeSessionBloc();
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(sessionBloc);
  locator.registerSingleton<IncomeReportBloc>(
    IncomeReportBloc(
      getDocumentsInfoListUseCase: useCase,
      sessionBloc: sessionBloc,
    ),
  );
}

Future<void> _pumpPage(WidgetTester tester, {bool flush = true}) async {
  await pumpApp(
    tester,
    const IncomeReportPage(),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(400, 800),
  );
  if (flush) {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }
}

void main() {
  tearDown(resetTestApplicationContainer);

  group('IncomeReportPage', () {
    testWidgets('lista os informes disponíveis por ano', (tester) async {
      await _installContainer(
        _FakeGetDocuments(documents: [_document(2025), _document(2024)]),
      );
      await _pumpPage(tester);

      expect(find.text('income_report_description'), findsOneWidget);
      expect(find.text('income_report_list_tile_name 2025'), findsOneWidget);
      expect(find.text('income_report_list_tile_name 2024'), findsOneWidget);
      expect(find.text('income_report_empty'), findsNothing);
    });

    testWidgets('exibe mensagem quando não há informes', (tester) async {
      await _installContainer(_FakeGetDocuments());
      await _pumpPage(tester);

      expect(find.text('income_report_empty'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
    });

    testWidgets('exibe loading enquanto busca os informes', (tester) async {
      await _installContainer(
        _FakeGetDocuments(delay: const Duration(milliseconds: 200)),
      );
      await _pumpPage(tester, flush: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('income_report_loading_message'), findsOneWidget);

      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    });

    testWidgets('exibe erro com opção de tentar novamente', (tester) async {
      await _installContainer(_FakeGetDocuments(fail: true));
      await _pumpPage(tester);

      expect(find.text('error_handling_widget_title'), findsOneWidget);
      expect(find.text('error_handling_widget_button_reTry'), findsOneWidget);
    });

    testWidgets('abre o arquivo do informe selecionado', (tester) async {
      await _installContainer(_FakeGetDocuments(documents: [_document(2025)]));

      final routes = <String>[];
      final arguments = <Object?>[];
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: const [
            TestLocDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: (settings) {
            routes.add(settings.name ?? '');
            arguments.add(settings.arguments);
            return MaterialPageRoute(
              builder: (_) => settings.name == ApplicationRoute.documentFilePage
                  ? const SizedBox()
                  : const IncomeReportPage(),
            );
          },
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.tap(find.text('income_report_list_tile_name 2025'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(routes, contains(ApplicationRoute.documentFilePage));
    });
  });
}
