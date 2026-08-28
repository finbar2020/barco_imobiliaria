import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_bloc.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_state.dart';
import 'package:colaborador/feature/documents/presentation/benefits/page/benefits_page.dart';
import 'package:colaborador/feature/documents/presentation/benefits/widget/benefits_loaded_widget.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_bloc.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_state.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/page/pay_stub_page.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/widget/pay_stub_loaded_widget.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_bloc.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_state.dart';
import 'package:colaborador/feature/documents/presentation/vacation/page/vacation_page.dart';
import 'package:colaborador/feature/documents/presentation/vacation/widget/vacation_loaded_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

DocumentInfo _document() => DocumentInfo(
      name: 'doc.pdf',
      type: DocumentTypeEnum.vacationReceipt,
      documentProcessingDate: DateTime(2026, 3, 5),
    );

class _FakeVacationBloc extends Fake implements VacationBloc {
  _FakeVacationBloc(this._state);

  final VacationState _state;
  final _controller = StreamController<VacationState>.broadcast();
  int reloads = 0;

  @override
  VacationState get state => _state;

  @override
  Stream<VacationState> get stream => _controller.stream;

  @override
  void getDocumentsInfoList({
    required DocumentTypeEnum documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) =>
      reloads++;

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

class _FakeBenefitsBloc extends Fake implements BenefitsBloc {
  _FakeBenefitsBloc(this._state);

  final BenefitsState _state;
  final _controller = StreamController<BenefitsState>.broadcast();

  @override
  BenefitsState get state => _state;

  @override
  Stream<BenefitsState> get stream => _controller.stream;

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

class _FakePayStubBloc extends Fake implements PayStubBloc {
  _FakePayStubBloc(this._state);

  final PayStubState _state;
  final _controller = StreamController<PayStubState>.broadcast();

  @override
  PayStubState get state => _state;

  @override
  Stream<PayStubState> get stream => _controller.stream;

  @override
  Future<void> close() async {}

  Future<void> dispose() => _controller.close();
}

Future<void> _installBase() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
}

Future<void> _pumpPage(WidgetTester tester, Widget page) async {
  await pumpApp(
    tester,
    page,
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    surface: const Size(500, 900),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUp(_installBase);
  tearDown(resetTestApplicationContainer);

  group('VacationPage', () {
    late _FakeVacationBloc bloc;

    Future<void> install(VacationState state) async {
      bloc = _FakeVacationBloc(state);
      addTearDown(bloc.dispose);
      ApplicationContainer.instance()
          .locator
          .registerSingleton<VacationBloc>(bloc);
    }

    testWidgets('buscando recibos mostra o loading', (tester) async {
      await install(const VacationLoadingState());
      await _pumpPage(tester, const VacationPage());

      expect(find.text('vacation_page_app_bar'), findsOneWidget);
      expect(find.text('vacation_page_loading_message'), findsOneWidget);
    });

    testWidgets('recibos carregados montam a lista', (tester) async {
      await install(VacationLoadedState([_document()]));
      await _pumpPage(tester, const VacationPage());

      expect(find.byType(VacationLoadedWidget), findsOneWidget);
    });

    testWidgets('falha permite tentar novamente', (tester) async {
      await install(
        const VacationFailedState(errorCode: '500', errorDescription: 'erro'),
      );
      await _pumpPage(tester, const VacationPage());

      expect(find.text('error_handling_widget_title'), findsOneWidget);

      await tester.tap(find.text('error_handling_widget_button_reTry'));
      await tester.pump();

      expect(bloc.reloads, 1);
    });
  });

  group('BenefitsPage', () {
    late _FakeBenefitsBloc bloc;

    Future<void> install(BenefitsState state) async {
      bloc = _FakeBenefitsBloc(state);
      addTearDown(bloc.dispose);
      ApplicationContainer.instance()
          .locator
          .registerSingleton<BenefitsBloc>(bloc);
    }

    testWidgets('buscando benefícios mostra o loading', (tester) async {
      await install(const BenefitsLoadingState());
      await _pumpPage(tester, const BenefitsPage());

      expect(find.text('benefits_page_app_bar'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('benefícios carregados montam a lista', (tester) async {
      await install(BenefitsLoadedState([_document()]));
      await _pumpPage(tester, const BenefitsPage());

      expect(find.byType(BenefitsLoadedWidget), findsOneWidget);
    });
  });

  group('PayStubPage', () {
    late _FakePayStubBloc bloc;

    Future<void> install(PayStubState state) async {
      bloc = _FakePayStubBloc(state);
      addTearDown(bloc.dispose);
      ApplicationContainer.instance()
          .locator
          .registerSingleton<PayStubBloc>(bloc);
    }

    testWidgets('buscando holerites mostra o loading', (tester) async {
      await install(const PayStubLoadingState());
      await _pumpPage(tester, const PayStubPage());

      expect(find.text('pay_stub_page_app_bar'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('holerites carregados montam a lista', (tester) async {
      await install(PayStubLoadedState([_document()]));
      await _pumpPage(tester, const PayStubPage());

      expect(find.byType(PayStubLoadedWidget), findsOneWidget);
    });
  });
}
