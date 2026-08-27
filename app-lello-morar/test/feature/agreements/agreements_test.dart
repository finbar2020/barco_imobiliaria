import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/network/api_failure.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/agreements/data/data_source/agreements_api.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_remote_data_source.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_remote_data_sourece_impl.dart';
import 'package:morar/feature/agreements/data/model/agreement_all_info_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_created_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_installment_credit_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_installment_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_payment_method_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_quota_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_rule_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_recommendation_payment_model.dart';
import 'package:morar/feature/agreements/data/repository/agreements_repository_impl.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_rule.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_detail/get_detail.dart';
import 'package:morar/feature/agreements/domain/use_case/get_detail/get_detail_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_installment_credit/get_installment_credit.dart';
import 'package:morar/feature/agreements/domain/use_case/get_installment_credit/get_installment_credit_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_payday/get_payday.dart';
import 'package:morar/feature/agreements/domain/use_case/get_payday/get_payday_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/get_recommendation/get_recommendation.dart';
import 'package:morar/feature/agreements/domain/use_case/get_recommendation/get_recommendation_impl.dart';
import 'package:morar/feature/agreements/domain/use_case/post_agreement/post_agreement.dart';
import 'package:morar/feature/agreements/domain/use_case/post_agreement/post_agreement_impl.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_event.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_application_container.dart';

class MockApi extends Mock implements AgreementsApi {}

AgreementInstallment _installment({String status = 'pending'}) => AgreementInstallment(
      readableLine: 'linha',
      barCode: 'bar',
      installmentId: 'i1',
      recnum: 'r',
      value: 10,
      dueDate: DateTime(2026, 5, 1),
      status: status,
      paymentLink: 'https://pay',
    );

AgreementQuota _quota() => AgreementQuota(
      id: 'q1',
      receipt: 'rec',
      originValue: 100,
      dueDate: DateTime(2026, 1, 10),
      fineValue: 2,
      feeValue: 3,
      honoraryValue: 5,
      overdueMessage: 'atrasado',
    );

Agreement _agreement({String status = 'pending', List<AgreementInstallment>? installments, int quantity = 2}) => Agreement(
      id: 'a1',
      unit: '101',
      unitOwner: 'Ana',
      baseValue: 100,
      fineAndCosts: 20,
      paymentMethod: 'billet',
      expiration: '2026-03-09',
      installmentQuantity: quantity,
      proposaldedDate: '2026-02-01',
      reference: 1,
      status: status,
      statusMessage: '2x',
      installments: installments ?? [_installment()],
      quotes: [_quota()],
    );

AgreementRule _rule() => AgreementRule(installmentQtd: 3, days: [5, 10], paymentMethod: [
      AgreementPaymentMethod(type: AgreementPaymentMethodEnum.billet, enabled: true, text: 't', description: 'd', disabledDescription: 'dd'),
    ]);

class _FakeDataSource extends Fake implements AgreementsRemoteDataSource {
  _FakeDataSource({this.error});
  final Object? error;
  AgreementCreatedModel? posted;

  @override
  Future<AgreementAllInfoModel> getAllInfo(String condoId, String unitTitle, bool onlyQuoteAndRule) async {
    if (error != null) throw error!;
    return AgreementAllInfoModel.fromEntity(AgreementAllInfo(quotes: [_quota()], agreements: [_agreement()], rule: _rule()));
  }

  @override
  Future<List<AgreementRecommendationPaymentModel>> getRecommendation(String condoId) async {
    if (error != null) throw error!;
    return [AgreementRecommendationPaymentModel(installmentQtd: 2, recomendation: true)];
  }

  @override
  Future<List<int>> getPayday(String unitId) async {
    if (error != null) throw error!;
    return [5, 15];
  }

  @override
  Future<List<AgreementInstallmentCreditModel>> getInstallmentsCredit(String condoId, double totalValue) async {
    if (error != null) throw error!;
    return [AgreementInstallmentCreditModel(billetValue: totalValue, installmentQtd: 2, totalValue: totalValue, installmentValue: totalValue / 2)];
  }

  @override
  Future<AgreementModel> postAgreement(String condoId, AgreementCreatedModel body) async {
    if (error != null) throw error!;
    posted = body;
    return AgreementModel.fromEntity(_agreement(status: 'approved_by_manager'));
  }

  @override
  Future<AgreementModel> getAgreementDetail(String condoId, String agreementId) async {
    if (error != null) throw error!;
    return AgreementModel.fromEntity(_agreement());
  }
}

class _FakeRepository extends Fake implements AgreementsRepository {
  _FakeRepository({this.failure, this.postStatus = 'approved_by_manager'});
  final Failure? failure;
  final String postStatus;
  final calls = <String>[];

  @override
  Future<Try<AgreementAllInfo>> getAllInfo(String condoId, String unitTitle, bool onlyQuoteAndRule) async {
    calls.add('all:$condoId:$unitTitle:$onlyQuoteAndRule');
    if (failure != null) return Rejection(failure!);
    return Success(AgreementAllInfo(quotes: [_quota()], agreements: [_agreement()], rule: _rule()));
  }

  @override
  Future<Try<List<AgreementRecommendationPayment>>> getRecommendation(String condId) async {
    calls.add('rec:$condId');
    if (failure != null) return Rejection(failure!);
    return Success([AgreementRecommendationPayment(installmentQtd: 1, recomendation: true)]);
  }

  @override
  Future<Try<List<String>>> getPayday(String unitId) async {
    calls.add('payday:$unitId');
    if (failure != null) return Rejection(failure!);
    return Success(['5', '10']);
  }

  @override
  Future<Try<List<AgreementInstallmentCredit>>> getInstallmentCredit(String condoId, double totalValue) async {
    calls.add('credit:$condoId:$totalValue');
    if (failure != null) return Rejection(failure!);
    return Success([AgreementInstallmentCredit(billetValue: totalValue, installmentQtd: 3, totalValue: totalValue, installmentValue: 1)]);
  }

  @override
  Future<Try<Agreement>> postAgreement(String condoId, AgreementCreated body) async {
    calls.add('post:$condoId:${body.unit}:${body.reference}:${body.email}');
    if (failure != null) return Rejection(failure!);
    return Success(_agreement(status: postStatus));
  }

  @override
  Future<Try<Agreement>> getAgreementDetail(String condoId, String agreementId) async {
    calls.add('detail:$condoId:$agreementId');
    if (failure != null) return Rejection(failure!);
    return Success(_agreement());
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('entidades', () {
    testWidgets('Agreement', (tester) async {
      await pumpApp(tester, const Text('x'), localized: true);
      final context = tester.element(find.text('x'));
      final theme = LelloTheme.light;
      final pallete = LelloTheme.palleteOf(theme);
      final agreement = _agreement();
      expect(agreement.date, '09/03/2026');
      expect(agreement.base, NumberFormat.currency(symbol: 'R\$').format(100));
      expect(agreement.fine, NumberFormat.currency(symbol: 'R\$').format(20));
      expect(agreement.total, NumberFormat.currency(symbol: 'R\$').format(120));
      expect(agreement.isPending, isTrue);
      expect(agreement.isReleased, isFalse);
      expect(agreement.isRejected, isFalse);
      expect(agreement.getBarCode, 'linha');
      expect(agreement.installmentId, 'i1');
      expect(agreement.getPaymentLink, Uri.parse('https://pay'));
      expect(agreement.getInstallments, '2x');
      expect(agreement.newValue, '[2X] ${NumberFormat.currency(symbol: 'R\$').format(60)}');
      expect(_agreement(quantity: 0).newValue, startsWith('[1X]'));
      expect(agreement.newExpiration, '01/02/2026');
      expect((_agreement()..installments.clear()).getPaymentLink, isNull);
      expect(_agreement(installments: [_installment(status: 'paid')]).getBarCode, '');
      expect(_agreement(installments: [_installment(status: 'paid')]).installmentId, '');
      expect(_agreement(installments: [_installment(status: 'paid')]).getPaymentLink, isNull);
      expect(agreement.method(context), 'income_billet_detail_billet');
      expect(agreement.highlight, isFalse);

      final expectations = {
        'pending': (pallete.warning(), 'agreement_pending_status', false, true, false),
        'approved_by_manager': (pallete.success(), 'agreement_payment_released', true, false, false),
        'approved_automatically': (pallete.success(), 'agreement_payment_released', true, false, false),
        'completed': (pallete.success(), 'agreement_end', false, false, false),
        'rejected': (pallete.textOpaque(), 'income_billet_detail_situation_canceled', false, false, true),
        'canceled_automatically': (pallete.textOpaque(), 'income_billet_detail_situation_canceled', false, false, true),
        'cancelled': (pallete.textOpaque(), 'income_billet_detail_situation_canceled', false, false, false),
        'outro': (theme.primaryColor, '', false, false, false),
      };
      expectations.forEach((status, e) {
        final a = _agreement(status: status);
        expect(a.getStatusColor(theme), e.$1, reason: status);
        expect(a.getStatusInfo(context), e.$2, reason: status);
        expect(a.isReleased, e.$3, reason: status);
        expect(a.isPending, e.$4, reason: status);
        expect(a.isRejected, e.$5, reason: status);
      });

      final installment = _installment();
      expect(installment.getStatusColor(theme), pallete.warning());
      expect(installment.getStatusInfo(context), 'space_reserved_waiting');
      expect(_installment(status: 'paid').getStatusColor(theme), pallete.success());
      expect(_installment(status: 'paid').getStatusInfo(context), 'income_billet_detail_situation_paid_out');
      expect(_installment(status: 'calceled').getStatusColor(theme), pallete.textOpaque());
      expect(_installment(status: 'calceled').getStatusInfo(context), 'income_billet_detail_situation_canceled');
      expect(_installment(status: 'x').getStatusColor(theme), theme.primaryColor);
      expect(_installment(status: 'x').getStatusInfo(context), '');
    });

    test('demais entidades', () {
      final quota = _quota();
      expect(quota.date, '10/01/2026');
      expect(quota.origin, NumberFormat.currency(symbol: 'R\$').format(100));
      expect(quota.fee, NumberFormat.currency(symbol: 'R\$').format(10));
      expect(quota.total, NumberFormat.currency(symbol: 'R\$').format(110));
      expect(quota.valorTotal, 110);
      expect(int.parse(quota.daysRemanining), greaterThan(0));

      final credit = AgreementInstallmentCredit(billetValue: 200, installmentQtd: 3, totalValue: 210, installmentValue: 70, tax: 5);
      expect(credit.installment, '3');
      expect(credit.taxValue, NumberFormat.currency(symbol: 'R\$').format(10));
      expect(AgreementInstallmentCredit(billetValue: 200, installmentQtd: 1, totalValue: 200, installmentValue: 200).taxValue,
          NumberFormat.currency(symbol: 'R\$').format(2));

      final method = AgreementPaymentMethod(type: AgreementPaymentMethodEnum.credit, enabled: true, text: 't', description: 'd', disabledDescription: 'dd');
      expect(method.getIcon(), 'assets/ic_agreement_credit.svg');
      expect(method.getTitle(), 'agreements_credit');
      method.type = AgreementPaymentMethodEnum.billet;
      expect(method.getIcon(), 'assets/ic_agreement_billet.svg');
      expect(method.getTitle(), 'income_billet_detail_billet');
      method.type = AgreementPaymentMethodEnum.undef;
      expect(method.getIcon(), 'assets/ic_agreement_billet.svg');
      expect(method.getTitle(), 'income_billet_detail_billet');

      expect(AgreementCreated(paymentMethod: AgreementPaymentMethodEnum.billet.index).chosenPaymentMethod, 'income_billet_detail_billet');
      expect(AgreementCreated(paymentMethod: AgreementPaymentMethodEnum.credit.index).chosenPaymentMethod, 'agreements_creditcard_bank');
      expect(AgreementRecommendationPayment(installmentQtd: 1, recomendation: false).paymentMethod, 'billet');
    });
  });

  test('models round trip', () {
    final info = AgreementAllInfoModel.fromEntity(AgreementAllInfo(quotes: [_quota()], agreements: [_agreement()], rule: _rule()));
    final json = jsonDecode(jsonEncode(info.toJson())) as Map<String, dynamic>;
    expect(json['rule']['installment_qtd'], 3);
    expect(json['agreements'][0]['installments'][0]['readable_line'], 'linha');
    expect(json['rule']['payment_method'][0]['type'], 'billet');
    final back = AgreementAllInfoModel.fromJson(json).toEntity();
    expect(back.quotes.single.overdueMessage, 'atrasado');
    expect(back.agreements.single.installments.single.dueDate, DateTime(2026, 5, 1));
    expect(back.rule.paymentMethod.single.type, AgreementPaymentMethodEnum.billet);
    expect(back.rule.days, [5, 10]);

    final created = AgreementCreatedModel.fromEntity(AgreementCreated(unit: '1', paymentMethod: 1, installmentQuantity: 2, dueDate: 5, reference: 7, receiptList: ['r'], email: null, phone: null));
    expect(created.email, '');
    expect(AgreementCreatedModel.fromJson(created.toJson()).toEntity().reference, 7);

    final credit = AgreementInstallmentCreditModel.fromEntity(AgreementInstallmentCredit(billetValue: 1, installmentQtd: 2, totalValue: 3, installmentValue: 4, cetMonth: 'm'));
    expect(AgreementInstallmentCreditModel.fromJson(credit.toJson()).toEntity().cetMonth, 'm');
    final installment = AgreementInstallmentModel.fromEntity(_installment());
    expect(AgreementInstallmentModel.fromJson(jsonDecode(jsonEncode(installment.toJson()))).toEntity().paymentLink, 'https://pay');
    final method = AgreementPaymentMethodModel.fromEntity(_rule().paymentMethod.single);
    expect(AgreementPaymentMethodModel.fromJson(method.toJson()).toEntity().text, 't');
    final quota = AgreementQuotaModel.fromEntity(_quota());
    expect(AgreementQuotaModel.fromJson(jsonDecode(jsonEncode(quota.toJson()))).toEntity().id, 'q1');
    final rule = AgreementRuleModel.fromEntity(_rule());
    expect(AgreementRuleModel.fromJson(jsonDecode(jsonEncode(rule.toJson()))).toEntity().installmentQtd, 3);
    final rec = AgreementRecommendationPaymentModel.fromEntity(AgreementRecommendationPayment(installmentQtd: 4, recomendation: true, dueDay: 9))!;
    expect(AgreementRecommendationPaymentModel.fromJson(rec.toJson()).toEntity().dueDay, 9);
    expect(AgreementRecommendationPaymentModel.fromEntity(null), isNull);
    final agreement = AgreementModel.fromEntity(_agreement()..notificationParameter = 'np');
    expect(AgreementModel.fromJson(jsonDecode(jsonEncode(agreement.toJson()))).toEntity().notificationParameter, 'np');
  });

  test('use cases delegam', () async {
    final repo = _FakeRepository();
    await GetAvailableUseCaseImpl(repository: repo)(GetAvailableParams(condoId: 'c', unitTitle: '101', onlyQuoteAndRule: true));
    await GetAgreementDetailImplUseCase(repository: repo)(GetAgreementDetailParams(condoId: 'c', agreementId: 'a'));
    await GetInstallmentCreditUseCaseImpl(repository: repo)(GetInstallmentParams(condoId: 'c', totalValue: 9.5));
    await GetPaydayUseCaseImpl(repository: repo)(GetPaydayParams(condoId: 'c'));
    await GetRecommendationUseCaseImpl(repository: repo)(GetRecommendationParams(condoId: 'c'));
    await PostAgreementImplUseCase(repository: repo)(PostAgreementParams(condoId: 'c', body: AgreementCreated(unit: 'u', reference: 2, email: 'e')));
    expect(repo.calls, ['all:c:101:true', 'detail:c:a', 'credit:c:9.5', 'payday:c', 'rec:c', 'post:c:u:2:e']);
  });

  group('AgreementsRepositoryImpl', () {
    test('sucesso', () async {
      final ds = _FakeDataSource();
      final repo = AgreementsRepositoryImpl(remoteDataSource: ds);
      expect((await repo.getAllInfo('c', '1', false)).fold((_) => null, (i) => i.rule.days), [5, 10]);
      expect((await repo.getRecommendation('c')).fold((_) => null, (l) => l.single.installmentQtd), 2);
      expect((await repo.getPayday('c')).fold((_) => null, (l) => l), ['5', '15']);
      expect((await repo.getInstallmentCredit('c', 100)).fold((_) => null, (l) => l.single.installmentValue), 50);
      final posted = await repo.postAgreement('c', AgreementCreated(unit: 'u', email: null));
      expect(posted.fold((_) => null, (a) => a.status), 'approved_by_manager');
      expect(ds.posted!.email, '');
      expect((await repo.getAgreementDetail('c', 'a')).fold((_) => null, (a) => a.id), 'a1');
    });

    test('falhas', () async {
      final api406 = ApiFailure.fromJson({'status': 406, 'failure': 'sem_cotas'});
      final repo406 = AgreementsRepositoryImpl(remoteDataSource: _FakeDataSource(error: api406));
      expect(((await repo406.getAllInfo('c', '1', false)).fold((f) => f, (_) => null) as KnownFailure).code, 'sem_cotas');
      final repo500 = AgreementsRepositoryImpl(remoteDataSource: _FakeDataSource(error: ApiFailure.fromJson({'status': 500})));
      expect((await repo500.getAllInfo('c', '1', false)).fold((f) => f, (_) => null), isA<UnknownFailure>());
      final repo = AgreementsRepositoryImpl(remoteDataSource: _FakeDataSource(error: Exception('x')));
      expect((await repo.getAllInfo('c', '1', false)).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getRecommendation('c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getPayday('c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getInstallmentCredit('c', 1)).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.postAgreement('c', AgreementCreated())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getAgreementDetail('c', 'a')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(AgreementCreatedModel());
    final ds = AgreementsRemoteDataSourceImpl(api: api);
    final agreementJson = jsonDecode(jsonEncode(AgreementModel.fromEntity(_agreement()).toJson()));
    Response<dynamic> ok(Object body) => Response<dynamic>(http.Response(jsonEncode(body), 200), null);
    when(() => api.getAllInfo('c', '101', false)).thenAnswer((_) async => ok({
          'quotes': [],
          'agreements': [agreementJson],
          'rule': {'installment_qtd': 1, 'days': [1], 'payment_method': []},
        }));
    when(() => api.getRecommendation('c')).thenAnswer((_) async => ok([{'installment_qtd': 2, 'recomendation': true}]));
    when(() => api.getPayday('c')).thenAnswer((_) async => ok({'installment_qtd': 1, 'days': [7, 8], 'payment_method': []}));
    when(() => api.getInstallmentsCredit('c', 10.0)).thenAnswer((_) async => ok([{'billet_value': 10.0, 'installment_qtd': 1.0, 'total_value': 10.0, 'installment_value': 10.0}]));
    when(() => api.postAgreement('c', any())).thenAnswer((_) async => ok(agreementJson));
    when(() => api.getAgreementDetails('c', 'a1')).thenAnswer((_) async => ok(agreementJson));
    expect((await ds.getAllInfo('c', '101', false)).agreements.single.id, 'a1');
    expect((await ds.getRecommendation('c')).single.installmentQtd, 2);
    expect(await ds.getPayday('c'), [7, 8]);
    expect((await ds.getInstallmentsCredit('c', 10)).single.totalValue, 10);
    expect((await ds.postAgreement('c', AgreementCreatedModel())).id, 'a1');
    expect((await ds.getAgreementDetail('c', 'a1')).unitOwner, 'Ana');
  });

  group('AgreementsBloc', () {
    late FakeSessionBloc sessionBloc;
    setUp(() => sessionBloc = FakeSessionBloc());

    AgreementsBloc build({Failure? failure, String postStatus = 'approved_by_manager'}) {
      final repo = _FakeRepository(failure: failure, postStatus: postStatus);
      final bloc = AgreementsBloc(
        sessionBloc: sessionBloc,
        getAvailableUseCase: GetAvailableUseCaseImpl(repository: repo),
        getRecommendationUseCase: GetRecommendationUseCaseImpl(repository: repo),
        getPaydayUseCase: GetPaydayUseCaseImpl(repository: repo),
        getInstallmentCreditUseCase: GetInstallmentCreditUseCaseImpl(repository: repo),
        postAgreementUseCase: PostAgreementImplUseCase(repository: repo),
        getAgreementDetailUseCase: GetAgreementDetailImplUseCase(repository: repo),
        baseUrl: 'http://base',
      );
      addTearDown(bloc.close);
      return bloc;
    }

    test('carrega cotas ao iniciar e navega entre estados', () async {
      final bloc = build();
      await waitFor(() => bloc.state is AgreementsQuotaAvailableLoadedState);
      var loaded = bloc.state as AgreementsQuotaAvailableLoadedState;
      expect(loaded.checkList, [false]);
      expect(loaded.agreements.single.baseUrl, 'http://base');
      expect(bloc.agreementPaymentMethod, hasLength(1));

      bloc.getChoicePayment();
      await waitFor(() => bloc.state is AgreementsChoiceLoadedState);
      bloc.getRecommendation();
      await waitFor(() => bloc.state is AgreementsRecommendationLoadedState);
      expect(bloc.agreementRecommendation, hasLength(1));
      bloc.getPayday();
      await waitFor(() => bloc.state is AgreementsPaydayLoadedState);
      expect((bloc.state as AgreementsPaydayLoadedState).checkList, [false, false]);
      bloc.getInstallments(50);
      await waitFor(() => bloc.state is AgreementsInstallmentLoadedState);
      expect(bloc.installments.single.billetValue, 50);
      bloc.goToRecommendation();
      await waitFor(() => bloc.state is AgreementsRecommendationLoadedState);
      bloc.goToInstallments();
      await waitFor(() => bloc.state is AgreementsInstallmentLoadedState);
      final created = AgreementCreated(totalValue: 9);
      bloc.goToAgreements(created, reload: false);
      await waitFor(() => bloc.state is AgreementsQuotaAvailableLoadedState);
      expect(created.totalValue, 0);
      fakeAnalytics.reset();
      bloc.getDetails(agreementId: 'a1');
      await waitFor(() => bloc.state is AgreementDetailLoadedState);
      expect(fakeAnalytics.events['acordos_acessar_acordos_em_andamento']!['id_acordo'], 'a1');
      bloc.goToAgreements(created);
      await waitFor(() => bloc.state is AgreementsQuotaLoadingState || bloc.state is AgreementsQuotaAvailableLoadedState);
      bloc.getQuotaAvailable();
      await waitFor(() => bloc.state is AgreementsQuotaAvailableLoadedState);
    });

    test('cotas vindas por parâmetro não consultam a API', () async {
      sessionBloc.currentState = const SessionInitialState();
      final bloc = build();
      bloc.quotasFromParam = [_quota(), _quota()];
      bloc.ruleFromParam = _rule();
      bloc.getQuotaAvailable();
      await waitFor(() => bloc.state is AgreementsQuotaAvailableLoadedState);
      final loaded = bloc.state as AgreementsQuotaAvailableLoadedState;
      expect(loaded.checkList, [false, false]);
      expect(loaded.agreements, isEmpty);
      expect(bloc.quotasFromParam, isNull);
    });

    test('postAgreement preenche a sessão e loga analytics', () async {
      final bloc = build();
      await waitFor(() => bloc.state is AgreementsQuotaAvailableLoadedState);
      fakeAnalytics.reset();
      sessionBloc.session.condominium!.reference = '77';
      final created = AgreementCreated(paymentMethod: 1, installmentQuantity: 3);
      bloc.postAgreement(created, false, true);
      await waitFor(() => bloc.state is PostAgreementLoadedState);
      expect((bloc.state as PostAgreementLoadedState).creditCard, isTrue);
      expect(created.unit, '101');
      expect(created.reference, 77);
      expect(created.email, 'ana@lello.com');
      expect(fakeAnalytics.events['acordos_finalizar_acordo_sucesso']!['parcelas'], '3');

      final pending = build(postStatus: 'pending');
      await waitFor(() => pending.state is AgreementsQuotaAvailableLoadedState);
      pending.postAgreement(AgreementCreated(), true, false);
      await waitFor(() => pending.state is PostPendingProposalLoadedState);
    });

    test('falhas viram estados de erro', () async {
      // Corrigido: o bloc faz `int.tryParse(reference)` com fallback, então
      // uma referência com letras não derruba o post.
      sessionBloc.session.condominium!.reference = 'A77';
      final bloc = build(failure: KnownFailure('sem_cotas', null));
      await waitFor(() => bloc.state is AgreementsQuotaErrorState);
      expect((bloc.state as AgreementsQuotaErrorState).errorMessageKey, 'sem_cotas');
      bloc.getRecommendation();
      await waitFor(() => bloc.state is AgreementsErrorState);
      bloc.getPayday();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, isA<AgreementsErrorState>());
      bloc.getInstallments(1);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, isA<AgreementsErrorState>());
      bloc.postAgreement(AgreementCreated(), false, false);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, isA<AgreementsErrorState>());
      bloc.getDetails(agreementId: 'a');
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, isA<AgreementsErrorState>());

      final unknown = build(failure: UnknownFailure('x'));
      await waitFor(() => unknown.state is AgreementsQuotaErrorState);
      expect((unknown.state as AgreementsQuotaErrorState).errorMessageKey, 'request_fine_error_message');
    });

    test('eventos e estados', () {
      expect(const AgreementsGetInstallmentEvent(totalValue: 1).props, [1.0]);
      expect(const AgreementsDetailsEvent(agreementId: 'a').props, ['a']);
      expect(const GetAgreementBilletEvent(installmentId: 'i').props, ['i']);
      expect(PostAgreementEvent(agreement: AgreementCreated(), pendingProposal: true, creditCard: false).props.length, 3);
      expect(const AgreementsQuotaInitialState(), const AgreementsQuotaInitialState());
      expect(const AgreementsErrorState(errorMessageKey: 'e').props, ['e']);
    });
  });
}
