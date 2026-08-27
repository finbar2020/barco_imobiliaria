import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/insurance/data/data_source/insurance_api.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_remote_data_source.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_remote_data_source_impl.dart';
import 'package:morar/feature/insurance/data/model/insurance_data_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_info_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_value_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_rule_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/insurance/data/repository/insurance_repository_impl.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_data.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_info.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_rule.dart';
import 'package:morar/feature/insurance/domain/repository/insurance_repository.dart';
import 'package:morar/feature/insurance/domain/use_case/get_insurance/get_insurance.dart';
import 'package:morar/feature/insurance/domain/use_case/get_insurance/get_insurance_impl.dart';
import 'package:morar/feature/insurance/domain/use_case/post_insurance/post_insurance.dart';
import 'package:morar/feature/insurance/domain/use_case/post_insurance/post_insurance_impl.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_bloc.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_event.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_state.dart';
import 'package:morar/feature/insurance/presentation/controller/insurance_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements InsuranceApi {}

InsuranceTableModel _table() => InsuranceTableModel(
      telefone: '0800',
      assistencia: 'a',
      premio: [
        InsurancePremiumModel(custo: 10, valores: [
          InsurancePremiumValueModel(idTitulo: 't', valor: '1'),
        ]),
        InsurancePremiumModel(custo: 30, valores: const []),
      ],
      titulos: {'t': 'Título'},
    );

Insurance _insurance({double cost = 10, String status = 'hired'}) => Insurance()
  ..insuranceStatus = status
  ..insuranceData = (InsuranceData()
    ..name = 'n'
    ..cost = cost
    ..idUnit = 'u'
    ..idInsurance = 'i'
    ..flagJoin = 'f')
  ..insuranceInfo = (InsuranceInfo()
    ..idProduto = 'p'
    ..idProdutoCompl = 'pc'
    ..saibaMais = 's'
    ..ativo = true
    ..termoDeUso = 't');

class _FakeDataSource extends Fake implements InsuranceRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;

  @override
  Future<InsuranceModel> getInsurance(String unitId) async {
    if (fail) throw Exception('x');
    return InsuranceModel(insuranceStatus: 'proposal');
  }

  @override
  Future<String> postInsurance(String unitId) async {
    if (fail) throw Exception('x');
    return '';
  }
}

class _FakeRepository extends Fake implements InsuranceRepository {
  final calls = <String>[];
  @override
  Future<Try<Insurance>> getInsurance(String unitId) async {
    calls.add('get:$unitId');
    return Success(_insurance());
  }

  @override
  Future<Try<String>> postInsurance(String unitId) async {
    calls.add('post:$unitId');
    return Success('ok');
  }
}

class _FakeGet extends Fake implements GetInsurance {
  _FakeGet({this.fail = false, this.cost = 10});
  final bool fail;
  final double cost;
  @override
  Future<Try<Insurance>> call(GetInsuranceParam p) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(_insurance(cost: cost));
  }
}

class _FakePost extends Fake implements PostInsurance {
  _FakePost({this.fail = false});
  final bool fail;
  String? unitId;
  @override
  Future<Try<String>> call(PostInsuranceParam p) async {
    unitId = p.unitId;
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

Future<List<InsuranceState>> _collect(
    InsuranceBloc bloc, Future<void> Function() run) async {
  final states = <InsuranceState>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(Duration.zero);
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('Insurance status getters', () {
    expect(_insurance(status: 'hired').contratado, isTrue);
    expect(_insurance(status: 'proposal').contratar, isTrue);
    expect(_insurance(status: 'cancellation_pending').cancelamentoPendente, isTrue);
    expect(_insurance(status: 'membership_pending').contratacaoPendente, isTrue);
    expect(_insurance(status: 'unavailable').indisponivel, isTrue);
    expect(_insurance(status: 'unavailable').contratado, isFalse);
  });

  group('models', () {
    test('InsuranceModel round trip', () {
      final model = InsuranceModel.fromEntity(_insurance())!;
      final json = jsonDecode(jsonEncode(model.toJson()));
      expect(json['insurance_status'], 'hired');
      expect(json['insurance_data']['id_unit'], 'u');
      expect(json['insurance_info']['termo_de_uso'], 't');
      final entity = InsuranceModel.fromJson(json).toEntity();
      expect(entity.insuranceData!.cost, 10);
      expect(entity.insuranceInfo!.ativo, isTrue);
      expect(InsuranceModel.fromEntity(null), isNull);
      expect(InsuranceDataModel.fromEntity(null), isNull);
      expect(InsuranceInfoModel.fromEntity(null), isNull);
      expect(InsuranceModel().toEntity().insuranceData, isNull);
    });

    test('InsuranceRuleModel', () {
      final rule = InsuranceRuleModel.fromEntity(InsuranceRule()
        ..id = '1'
        ..name = 'n'
        ..description = 'd'
        ..cost = 2
        ..linkTerms = 'l')!;
      final json = rule.toJson();
      expect(json['link_terms'], 'l');
      expect(InsuranceRuleModel.fromJson(json).toEntity().cost, 2);
      expect(InsuranceRuleModel.fromEntity(null), isNull);
    });

    test('tabela de prêmios: json e clone', () {
      final table = _table();
      final json = jsonDecode(jsonEncode(table.toJson())) as Map<String, dynamic>;
      expect(json['premio'], hasLength(2));
      final parsed = InsuranceTableModel.fromJson(json);
      expect(parsed.premio.first.valores.single.idTitulo, 't');
      final clone = InsuranceTableModel.clone(parsed);
      clone.titulos['x'] = 'y';
      expect(parsed.titulos.containsKey('x'), isFalse);
      expect(clone.premio.first.custo, 10);
      final value = InsurancePremiumValueModel.clone(parsed.premio.first.valores.single);
      expect(value.valor, '1');
      expect(InsurancePremiumValueModel.fromJson({'id_titulo': 'a', 'valor': 'b'})
          .toJson(), {'id_titulo': 'a', 'valor': 'b'});
      expect(
        InsurancePremiumModel.fromJson(
                jsonDecode(jsonEncode(parsed.premio.first.toJson())))
            .custo,
        10,
      );
    });
  });

  group('use cases', () {
    test('GetInsurancempl', () async {
      final repo = _FakeRepository();
      final useCase = GetInsurancempl(repository: repo);
      final invalid = await useCase(GetInsuranceParam(unitId: ''));
      expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase(GetInsuranceParam(unitId: 'u'));
      expect(ok.fold((_) => null, (i) => i.contratado), isTrue);
      expect(repo.calls, ['get:u']);
    });

    test('PostInsurancempl', () async {
      final repo = _FakeRepository();
      final useCase = PostInsurancempl(repository: repo);
      final invalid = await useCase(PostInsuranceParam(unitId: ''));
      expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase(PostInsuranceParam(unitId: 'u'));
      expect(ok.fold((_) => null, (s) => s), 'ok');
      expect(repo.calls, ['post:u']);
    });
  });

  group('repository', () {
    test('sucesso', () async {
      final repo = InsuranceRepositoryImpl(remoteDataSource: _FakeDataSource());
      expect((await repo.getInsurance('u')).fold((_) => null, (i) => i.contratar),
          isTrue);
      expect((await repo.postInsurance('u')).fold((_) => null, (s) => s), '');
    });

    test('falha', () async {
      final repo =
          InsuranceRepositoryImpl(remoteDataSource: _FakeDataSource(fail: true));
      expect((await repo.getInsurance('u')).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
      expect((await repo.postInsurance('u')).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    final ds = InsuranceRemoteDataSourceImpl(api: api);
    when(() => api.getInsurance('u')).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode({'insurance_status': 'hired'}), 200),
        null,
      ),
    );
    when(() => api.postInsurance('u')).thenAnswer(
      (_) async => Response<dynamic>(http.Response('', 200), null),
    );
    when(() => api.postInsurance('e')).thenAnswer(
      (_) async => Response<dynamic>(http.Response('', 500), null, error: 'err'),
    );
    expect((await ds.getInsurance('u')).insuranceStatus, 'hired');
    expect(await ds.postInsurance('u'), '');
    expect(() => ds.postInsurance('e'), throwsA('err'));
  });

  test('bloc', () async {
    final bloc = InsuranceBloc();
    expect(bloc.state, const LoadingInsuranceState());
    final states = <InsuranceState>[];
    final sub = bloc.stream.listen(states.add);
    final table = _table();
    bloc
      ..add(InsuranceLoadedEvent(
        model: null,
        selectedPremium: table.premio.first,
        insuranceData: table,
        isCancel: true,
      ))
      ..add(const InsuranceFailedEvent())
      ..add(const InsuranceLoadingEvent());
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    await bloc.close();
    expect(states, [
      LoadedInsuranceState(
        selectedPremium: table.premio.first,
        insuranceData: table,
        isCancel: true,
      ),
      const FailedInsuranceState(),
      const LoadingInsuranceState(),
    ]);
    expect(
      InsuranceLoadedEvent(selectedPremium: table.premio.first, insuranceData: table)
          .props,
      [null, table.premio.first, table, false, false],
    );
  });

  group('controller', () {
    late InsuranceBloc bloc;
    setUp(() => bloc = InsuranceBloc());
    tearDown(() => bloc.close());

    InsuranceController build({
      _FakeGet? get,
      _FakePost? post,
      InsuranceTableModel? table,
    }) =>
        InsuranceController(
          bloc: bloc,
          insuranceUseCase: get ?? _FakeGet(),
          postUseCase: post ?? _FakePost(),
          sessionBloc: FakeSessionBloc(insuranceTable: table),
        );

    test('getInsurance carrega prêmio selecionado', () async {
      final controller = build(table: _table());
      fakeAnalytics.reset();
      final states = await _collect(bloc, controller.getInsurance);
      expect(states.first, const LoadingInsuranceState());
      final loaded = states.last as LoadedInsuranceState;
      expect(loaded.selectedPremium.custo, 10);
      expect(loaded.model!.contratado, isTrue);
      expect(controller.minCost, 10);
      expect(controller.maxCost, 30);
      expect(fakeAnalytics.eventNames,
          contains('comodidades_parceiro_seguros_acessar'));
    });

    test('getInsurance falha sem tabela, sem prêmio compatível ou erro',
        () async {
      var states = await _collect(bloc, build().getInsurance);
      expect(states.last, const FailedInsuranceState());

      states = await _collect(
          bloc, build(table: _table(), get: _FakeGet(cost: 99)).getInsurance);
      expect(states.last, const FailedInsuranceState());

      states = await _collect(
          bloc, build(table: _table(), get: _FakeGet(fail: true)).getInsurance);
      expect(states.last, const FailedInsuranceState());
    });

    test('postInsurance exige dados carregados', () async {
      final states = await _collect(bloc, () => build().postInsurance(false));
      expect(states, [const FailedInsuranceState()]);
    });

    test('postInsurance contrata e cancela', () async {
      final post = _FakePost();
      final controller = build(table: _table(), post: post);
      await controller.getInsurance();

      fakeAnalytics.reset();
      var states = await _collect(bloc, () => controller.postInsurance(false));
      var loaded = states.last as LoadedInsuranceState;
      expect(loaded.isPost, isTrue);
      expect(loaded.isCancel, isFalse);
      expect(post.unitId, 'u1');
      expect(fakeAnalytics.eventNames,
          contains('comodidades_parceiro_seguros_contratar'));

      fakeAnalytics.reset();
      states = await _collect(bloc, () => controller.postInsurance(true));
      loaded = states.last as LoadedInsuranceState;
      expect(loaded.isCancel, isTrue);
      expect(fakeAnalytics.eventNames,
          contains('comodidades_parceiro_seguros_cancelar'));
    });

    test('postInsurance com erro', () async {
      final controller = build(table: _table(), post: _FakePost(fail: true));
      await controller.getInsurance();
      final states = await _collect(bloc, () => controller.postInsurance(false));
      expect(states.last, const FailedInsuranceState());
    });
  });
}
