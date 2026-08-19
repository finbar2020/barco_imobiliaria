import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_bloc.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_state.dart';
import 'package:colaborador/feature/documents/presentation/document_file/page/document_file_page.dart';
import 'package:colaborador/feature/documents/presentation/document_file/widget/document_file_failed_body.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeDocumentFileBloc extends Fake implements DocumentFileBloc {
  _FakeDocumentFileBloc(this._state);

  final DocumentFileState _state;
  final _controller = StreamController<DocumentFileState>.broadcast();
  final requestedDocuments = <String>[];

  @override
  DocumentFileState get state => _state;

  @override
  Stream<DocumentFileState> get stream => _controller.stream;

  @override
  void getDocumentFile({required String documentName}) =>
      requestedDocuments.add(documentName);

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

class _PopObserver extends NavigatorObserver {
  int pops = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
    super.didPop(route, previousRoute);
  }
}

late _FakeDocumentFileBloc _bloc;

Future<void> _install(DocumentFileState state) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = _FakeDocumentFileBloc(state);
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<DocumentFileBloc>(_bloc);
}

Future<_PopObserver> _pumpPage(WidgetTester tester) async {
  final observer = _PopObserver();
  await pumpApp(
    tester,
    Navigator(
      observers: [observer],
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: RouteSettings(
          name: settings.name,
          arguments: DocumentFilePageArgs('holerite.pdf'),
        ),
        builder: (_) => const DocumentFilePage(),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(420, 800),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return observer;
}

void main() {
  tearDown(() async {
    await _bloc.dispose();
    await resetTestApplicationContainer();
  });

  group('DocumentFilePage', () {
    testWidgets('pede o documento recebido por argumento', (tester) async {
      await _install(const DocumentFileLoadingState());
      await _pumpPage(tester);

      expect(_bloc.requestedDocuments, ['holerite.pdf']);
      expect(find.text('document_file_page_loading'), findsOneWidget);
    });

    testWidgets('falha exibe o corpo de erro', (tester) async {
      await _install(const DocumentFileFailedState());
      await _pumpPage(tester);

      expect(find.byType(DocumentFileFailedBody), findsOneWidget);
      expect(find.text('document_file_page_error_title'), findsOneWidget);
      expect(
        find.text('document_file_page_error_description'),
        findsOneWidget,
      );
    });

    testWidgets('documento sem arquivo também cai no corpo de erro',
        (tester) async {
      await _install(
        DocumentFileLoadedState(
          DocumentFile(id: '1', name: 'holerite', type: 'pdf', data: ''),
        ),
      );
      await _pumpPage(tester);

      expect(find.byType(DocumentFileFailedBody), findsOneWidget);
    });

    testWidgets('voltar fecha a tela de erro', (tester) async {
      await _install(const DocumentFileFailedState());
      final observer = await _pumpPage(tester);

      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();

      expect(observer.pops, 1);
    });
  });
}
