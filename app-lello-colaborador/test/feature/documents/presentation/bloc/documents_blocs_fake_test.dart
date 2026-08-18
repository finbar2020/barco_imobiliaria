import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_bloc.dart';
import 'package:colaborador/feature/documents/presentation/benefits/bloc/benefits_state.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_bloc.dart';
import 'package:colaborador/feature/documents/presentation/document_file/bloc/document_file_state.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_bloc.dart';
import 'package:colaborador/feature/documents/presentation/income_report/bloc/income_report_state.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_bloc.dart';
import 'package:colaborador/feature/documents/presentation/pay_stub/bloc/pay_stub_state.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_bloc.dart';
import 'package:colaborador/feature/documents/presentation/vacation/bloc/vacation_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeGetDocs extends Fake implements GetDocumentsInfoListUseCase {
  bool fail = false;
  String? lastCondo;

  @override
  Future<Try<List<DocumentInfo>>> call(GetDocumentsInfoListParam params) async {
    lastCondo = params.condoId;
    if (fail) return Rejection(KnownFailure('500', 'erro'));
    return Success([
      DocumentInfo(
        name: 'doc.pdf',
        type: params.documentType,
        documentProcessingDate: DateTime(2026, 1, 10),
      ),
    ]);
  }
}

class _FakeGetFile extends Fake implements GetDocumentFileUseCase {
  bool fail = false;

  @override
  Future<Try<DocumentFile>> call(GetDocumentFileParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(DocumentFile(
      id: '1',
      name: params.documentName,
      type: 'pdf',
      data: 'abc',
    ));
  }
}

void main() {
  group('BenefitsBloc', () {
    test('carrega lista no construtor', () async {
      final useCase = _FakeGetDocs();
      final bloc = BenefitsBloc(
        getDocumentsInfoListUseCase: useCase,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is BenefitsLoadedState || s is BenefitsFailedState,
      );
      expect(state, isA<BenefitsLoadedState>());
      expect(useCase.lastCondo, 'c1');
    });

    test('emite failed quando o use case rejeita', () async {
      final bloc = BenefitsBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is BenefitsLoadedState || s is BenefitsFailedState,
      );
      expect(state, isA<BenefitsFailedState>());
    });
  });

  group('PayStubBloc', () {
    test('carrega holerites', () async {
      final bloc = PayStubBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is PayStubLoadedState || s is PayStubFailedState,
      );
      expect(state, isA<PayStubLoadedState>());
    });

    test('emite failed', () async {
      final bloc = PayStubBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is PayStubLoadedState || s is PayStubFailedState,
      );
      expect(state, isA<PayStubFailedState>());
    });
  });

  group('VacationBloc', () {
    test('carrega férias', () async {
      final bloc = VacationBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is VacationLoadedState || s is VacationFailedState,
      );
      expect(state, isA<VacationLoadedState>());
    });

    test('emite failed', () async {
      final bloc = VacationBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is VacationLoadedState || s is VacationFailedState,
      );
      expect(state, isA<VacationFailedState>());
    });
  });

  group('IncomeReportBloc', () {
    test('carrega informe', () async {
      final bloc = IncomeReportBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is IncomeReportLoadedState || s is IncomeReportFailedState,
      );
      expect(state, isA<IncomeReportLoadedState>());
    });

    test('emite failed', () async {
      final bloc = IncomeReportBloc(
        getDocumentsInfoListUseCase: _FakeGetDocs()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is IncomeReportLoadedState || s is IncomeReportFailedState,
      );
      expect(state, isA<IncomeReportFailedState>());
    });
  });

  group('DocumentFileBloc', () {
    test('carrega arquivo', () async {
      final bloc = DocumentFileBloc(
        getDocumentFileUseCase: _FakeGetFile(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.getDocumentFile(documentName: 'holerite.pdf');
      final state = await bloc.stream.firstWhere(
        (s) => s is DocumentFileLoadedState || s is DocumentFileFailedState,
      );
      expect(state, isA<DocumentFileLoadedState>());
      expect((state as DocumentFileLoadedState).documentFile.name, 'holerite.pdf');
    });

    test('emite failed', () async {
      final bloc = DocumentFileBloc(
        getDocumentFileUseCase: _FakeGetFile()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.getDocumentFile(documentName: 'x.pdf');
      final state = await bloc.stream.firstWhere(
        (s) => s is DocumentFileLoadedState || s is DocumentFileFailedState,
      );
      expect(state, isA<DocumentFileFailedState>());
    });
  });
}
