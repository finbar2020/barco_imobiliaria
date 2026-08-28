import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/network/api_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/documents/data/model/document_file_response_model.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_api.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_remote_data_source.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_remote_data_source_impl.dart';
import 'package:morar/feature/easy_fix/cnd/data/model/unit_profile_model.dart';
import 'package:morar/feature/easy_fix/cnd/data/repository/cdn_repository_impl.dart';
import 'package:morar/feature/easy_fix/cnd/domain/entity/unit_profile_entity.dart';
import 'package:morar/feature/easy_fix/cnd/domain/repository/cnd_repository.dart';
import 'package:morar/feature/easy_fix/cnd/domain/use_case/cnd_pdf_use_case.dart';
import 'package:morar/feature/easy_fix/cnd/domain/use_case/cnd_pdf_use_case_impl.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_bloc.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_event.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_state.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/controller/cnd_controller.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';
import 'package:morar/feature/easy_fix/domain/repository/easy_fix_repository.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_easy_fix_unit_usecase.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/fixtures.dart';

class MockApi extends Mock implements CndApi {}

class _FakeDataSource extends Fake implements CndRemoteDataSource {
  _FakeDataSource({this.error});
  final Object? error;
  UnitProfileModel? model;

  @override
  Future<DocumentFileResponseModel> generateCertificateNoOutstandingDebt(
      {required String condominiumId, required UnitProfileModel model}) async {
    this.model = model;
    if (error != null) throw error!;
    return DocumentFileResponseModel()..data = 'cGRm';
  }
}

class _FakeRepository extends Fake implements CndRepository {
  final calls = <String>[];
  @override
  Future<Try<DocumentFile>> generateCertificateNoOutstandingDebt(
      String condominiumId, UnitProfileEntity unitProfileEntity) async {
    calls.add('$condominiumId:${unitProfileEntity.email}');
    return Success(DocumentFile(data: 'x'));
  }
}

class _FakeEasyFixRepository extends Fake implements EasyFixRepository {
  _FakeEasyFixRepository({this.fail = false, this.email = 'teste@gmail.com'});
  final bool fail;
  final String email;
  @override
  Future<Try<EasyFixUnit>> getEasyFixUnit({required String condominiumId}) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(EasyFixUnit.filled()
        .copyWith(email: email, cellphone: '11998222044', phone: '1132048116'));
  }
}

class _FakeCndUseCase extends Fake implements CndPdfUseCase {
  _FakeCndUseCase({this.failure});
  final Failure? failure;
  CndPdfParams? params;
  @override
  Future<Try<DocumentFile>> call(CndPdfParams p) async {
    params = p;
    if (failure != null) return Rejection(failure!);
    return Success(DocumentFile(data: 'pdf'));
  }
}

Future<List<dynamic>> _collect(Bloc bloc, Future<void> Function() run) async {
  final states = <dynamic>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('UnitProfileEntity e model', () {
    final entity = UnitProfileEntity(email: 'e', mobilePhone: 'm', phone: 'p');
    expect(entity.copyWith(celular: 'x').mobilePhone, 'x');
    expect(entity.copyWith(telefone: 'y', email: 'z').phone, 'y');
    expect(UnitProfileEntity().email, '');
    final model = UnitProfileModel.fromEntity(entity);
    expect(model.toJson(), {'email': 'e', 'mobile_phone': 'm', 'phone': 'p'});
    expect(UnitProfileModel.fromJson(model.toJson()).toEntity().phone, 'p');
  });

  test('use case valida o condomínio', () async {
    final repo = _FakeRepository();
    final useCase = CndPdfUseCaseImpl(repository: repo);
    expect(
      (await useCase(CndPdfParams(condominiumId: '', unitProfileEntity: UnitProfileEntity())))
          .fold((f) => f, (_) => null),
      isA<InvalidParamFailure>(),
    );
    final ok = await useCase(CndPdfParams(
      condominiumId: 'c',
      unitProfileEntity: UnitProfileEntity(email: 'e'),
    ));
    expect(ok.fold((_) => null, (d) => d.data), 'x');
    expect(repo.calls, ['c:e']);
  });

  group('CndRepositoryImpl', () {
    test('sucesso', () async {
      final ds = _FakeDataSource();
      final result = await CndRepositoryImpl(dataSource: ds)
          .generateCertificateNoOutstandingDebt('c', UnitProfileEntity(email: 'e'));
      expect(result.fold((_) => null, (d) => d.data), 'cGRm');
      expect(ds.model!.email, 'e');
    });

    test('409 vira KnownFailure com o detalhe', () async {
      final failure409 = ApiFailure.fromJson({'status': 409, 'detail': 'tem débito'});
      final result = await CndRepositoryImpl(dataSource: _FakeDataSource(error: failure409))
          .generateCertificateNoOutstandingDebt('c', UnitProfileEntity());
      final failure = result.fold((f) => f, (_) => null) as KnownFailure;
      expect(failure.code, 'tem débito');

      final semDetalhe = ApiFailure.fromJson({'status': 409});
      final result2 = await CndRepositoryImpl(dataSource: _FakeDataSource(error: semDetalhe))
          .generateCertificateNoOutstandingDebt('c', UnitProfileEntity());
      expect((result2.fold((f) => f, (_) => null) as KnownFailure).code,
          'easy_fix_has_outstanding_debt');
    });

    test('outros erros viram UnknownFailure', () async {
      final api500 = ApiFailure.fromJson({'status': 500});
      expect(
        (await CndRepositoryImpl(dataSource: _FakeDataSource(error: api500))
                .generateCertificateNoOutstandingDebt('c', UnitProfileEntity()))
            .fold((f) => f, (_) => null),
        isA<UnknownFailure>(),
      );
      expect(
        (await CndRepositoryImpl(dataSource: _FakeDataSource(error: Exception('x')))
                .generateCertificateNoOutstandingDebt('c', UnitProfileEntity()))
            .fold((f) => f, (_) => null),
        isA<UnknownFailure>(),
      );
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(UnitProfileModel(email: '', mobilePhone: '', phone: ''));
    final ds = CndRemoteDataSourceImpl(api: api);
    when(() => api.generateCertificateNoOutstandingDebt('ok', any())).thenAnswer(
      (_) async => Response<dynamic>(http.Response.bytes([1, 2, 3], 200), null),
    );
    when(() => api.generateCertificateNoOutstandingDebt('409', any())).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode({'status': 409, 'detail': 'd'}), 409),
        null,
      ),
    );
    when(() => api.generateCertificateNoOutstandingDebt('500', any())).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode({'status': 500}), 500), null),
    );
    final model = UnitProfileModel(email: 'e', mobilePhone: 'm', phone: 'p');
    final ok = await ds.generateCertificateNoOutstandingDebt(condominiumId: 'ok', model: model);
    expect(ok.data, base64Encode([1, 2, 3]));
    expect(
      () => ds.generateCertificateNoOutstandingDebt(condominiumId: '409', model: model),
      throwsA(isA<ApiFailure>()),
    );
    expect(
      () => ds.generateCertificateNoOutstandingDebt(condominiumId: '500', model: model),
      throwsA(isA<Exception>()),
    );
  });

  test('bloc', () async {
    final bloc = CertificateNoOutstandingDebtBloc();
    expect(bloc.state, const CertificateNoOutstandingDebtInitialState());
    final unit = EasyFixUnit.filled();
    final states = await _collect(bloc, () async {
      bloc
        ..add(const UnitProfileLoadingEvent())
        ..add(UnitProfileLoadedEvent(unit: unit))
        ..add(UnitProfileFailureEvent(failure: UnknownFailure('e')))
        ..add(const CertificateNoOutstandingDebtLoadingEvent())
        ..add(CertificateNoOutstandingDebtFailureEvent(failure: UnknownFailure('e')))
        ..add(const HasOutstandingDebtEvent())
        ..add(const CertificateNoOutstandingDebtSucessEvent(pdf: 'p'));
    });
    await bloc.close();
    expect(states, [
      const UnitProfileLoadingState(),
      UnitProfileLoadedState(unit: unit),
      UnitProfileFailureState(failure: UnknownFailure('e')),
      const CertificateNoOutstandingDebtLoadingState(),
      CertificateNoOutstandingDebtFailureState(failure: UnknownFailure('e')),
      const HasOutstandingDebtState(),
      const CertificateNoOutstandingDebtSucessState(pdf: 'p'),
    ]);
    expect(const CertificateNoOutstandingDebtEmptyEvent().props, isEmpty);
    expect(UnitProfileLoadedEvent(unit: unit).props, [unit]);
  });

  group('CertificateNoOutstandingDebtController', () {
    late CertificateNoOutstandingDebtBloc bloc;
    setUp(() => bloc = CertificateNoOutstandingDebtBloc());
    tearDown(() => bloc.close());

    CertificateNoOutstandingDebtController build({
      _FakeCndUseCase? cnd,
      bool failUnit = false,
      String email = 'teste@gmail.com',
    }) =>
        CertificateNoOutstandingDebtController(
          sessionBloc: FakeSessionBloc(),
          bloc: bloc,
          cndPdfUseCase: cnd ?? _FakeCndUseCase(),
          getEasyFixUnitUsecase: GetEasyFixUnitUsecase(
            repository: _FakeEasyFixRepository(fail: failUnit, email: email),
          ),
        );

    test('getEasyFixUnit preenche os campos e gera a certidão', () async {
      final cnd = _FakeCndUseCase();
      final controller = build(cnd: cnd);
      final states = await _collect(bloc, controller.getEasyFixUnit);
      expect(states.first, const UnitProfileLoadingState());
      expect(states.last, const CertificateNoOutstandingDebtSucessState(pdf: 'pdf'));
      expect(controller.email, 'teste@gmail.com');
      expect(controller.mobilePhone, '11998222044');
      expect(cnd.params!.condominiumId, 'c1');
      expect(cnd.params!.unitProfileEntity.phone, '1132048116');
      expect(controller.landlineFormatted('1132048116'), '(11) 3204-8116');
      expect(controller.landlineFormatted(''), isNull);
      expect(controller.mobilePhoneFormatted('11998222044'), '(11) 99822-2044');
      expect(controller.mobilePhoneFormatted(''), isNull);
      expect(controller.requestCertificateNoOutstandingDebt.mobilePhone, '11998222044');
    });

    test('getEasyFixUnit com cadastro incompleto emite o formulário', () async {
      final cnd = _FakeCndUseCase();
      final controller = build(cnd: cnd, email: '');
      final states = await _collect(bloc, controller.getEasyFixUnit);
      expect(states.first, const UnitProfileLoadingState());
      expect(states.last, isA<UnitProfileLoadedState>());
      expect((states.last as UnitProfileLoadedState).unit.email, '');
      // Não tenta gerar a certidão sem os dados.
      expect(cnd.params, isNull);
      expect(controller.email, '');
    });

    test('falha ao buscar a unidade', () async {
      final states = await _collect(bloc, build(failUnit: true).getEasyFixUnit);
      expect(states.last, isA<UnitProfileFailureState>());
    });

    test('débito pendente e falha genérica', () async {
      var states = await _collect(
        bloc,
        () => build(cnd: _FakeCndUseCase(failure: KnownFailure('debt', null)))
            .generateCertificateNoOutstandingDebt(unitProfile: UnitProfileEntity())!,
      );
      expect(states.last, const HasOutstandingDebtState());

      states = await _collect(
        bloc,
        () => build(cnd: _FakeCndUseCase(failure: UnknownFailure('x')))
            .generateCertificateNoOutstandingDebt(unitProfile: UnitProfileEntity())!,
      );
      expect(states.last, isA<CertificateNoOutstandingDebtFailureState>());
    });
  });
}
