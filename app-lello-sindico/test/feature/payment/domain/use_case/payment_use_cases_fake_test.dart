import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile_impl.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment_history/list_payment_history.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment_history/list_payment_history_impl.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/reigster_payment_failure.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment_impl.dart';

class _FakeRepo extends Fake implements PaymentRepository {
  Object? last;
  bool fail = false;
  final Payment stored = Payment(
    supplierIdentification: '123',
    supplierName: 'Fornecedor',
    documentNumber: 'NF-1',
    totalValue: 10,
  );

  @override
  Future<Try<List<Payment>>> list(
    String condominiumId, {
    String? lastPaymentId,
    PaymentListFilter? filter,
    String? status,
  }) async {
    last = condominiumId;
    if (fail) return Rejection(UnknownFailure('boom'));
    return Success([stored]);
  }

  @override
  Future<Try<Payment?>> findByBarcode(
      String condominiumId, String barcode) async {
    last = barcode;
    return Success(stored);
  }

  @override
  Future<Try<Payment?>> insert(String condominiumId, Payment payment) async {
    last = payment;
    return Success(payment);
  }

  @override
  Future<Try<Payment?>> find(String condominiumId,
      String supplierIdentification, String documentNumber) async {
    last = documentNumber;
    return Success(stored);
  }

  @override
  Future<Try<List<PaymentHistoryItem>>> listPaymentHistory(
      String condominiumId, DateTime? startDate, DateTime? endDate) async {
    last = condominiumId;
    return Success([PaymentHistoryItem(documentId: 1, supplierName: 'A')]);
  }

  @override
  Future<Try<int>> sendPayment(
      String condominiumId, PaymentDataEntity data) async {
    last = condominiumId;
    return Success(99);
  }

  @override
  Future<Try<bool>> checkApprovalProfile(String condominiumId) async {
    last = condominiumId;
    return Success(true);
  }
}

void main() {
  late _FakeRepo repo;

  setUp(() => repo = _FakeRepo());

  group('ListPaymentImpl', () {
    test('rejeita condominiumId vazio', () async {
      final result = await ListPaymentImpl(repository: repo)(
        ListPaymentParam(condominiumId: ''),
      );
      expect(result, isA<Rejection<List<Payment>>>());
    });

    test('lista quando o repositório responde', () async {
      final result = await ListPaymentImpl(repository: repo)(
        ListPaymentParam(condominiumId: 'c1', status: 'Aprovado'),
      );
      expect(result, isA<Success<List<Payment>>>());
      expect(repo.last, 'c1');
    });

    test('propaga Rejection', () async {
      repo.fail = true;
      final result = await ListPaymentImpl(repository: repo)(
        ListPaymentParam(condominiumId: 'c1'),
      );
      expect(result, isA<Rejection<List<Payment>>>());
    });
  });

  group('FindPaymentByBarcodeImpl', () {
    test('rejeita barcode vazio', () async {
      final result = await FindPaymentByBarcodeImpl(repository: repo)(
        FindPaymentByBarcodeParam(condominiumId: 'c1', barcode: ''),
      );
      expect(result, isA<Rejection<Payment?>>());
    });

    test('encaminha barcode válido', () async {
      final result = await FindPaymentByBarcodeImpl(repository: repo)(
        FindPaymentByBarcodeParam(condominiumId: 'c1', barcode: '789'),
      );
      expect(result, isA<Success<Payment?>>());
      expect(repo.last, '789');
    });
  });

  group('RegisterPaymentImpl', () {
    test('rejeita fornecedor inválido', () async {
      final result = await RegisterPaymentImpl(repository: repo)(
        RegisterPaymentParams(
          condominiumId: 'c1',
          payment: Payment(totalValue: 10),
        ),
      );
      expect(result, isA<Rejection<Payment?>>());
      expect(
        (result as Rejection<Payment?>).get(),
        isA<RegisterPaymentInvalidSupplierFailure>(),
      );
    });

    test('rejeita valor <= 0', () async {
      final result = await RegisterPaymentImpl(repository: repo)(
        RegisterPaymentParams(
          condominiumId: 'c1',
          payment: Payment(
            supplierIdentification: '1',
            supplierName: 'A',
            documentNumber: 'NF',
            totalValue: 0,
          ),
        ),
      );
      expect(
        (result as Rejection<Payment?>).get(),
        isA<RegisterPaymentInvalidValueFailure>(),
      );
    });

    test('insere pagamento válido', () async {
      final payment = Payment(
        supplierIdentification: '1',
        supplierName: 'A',
        documentNumber: 'NF',
        totalValue: 99,
      );
      final result = await RegisterPaymentImpl(repository: repo)(
        RegisterPaymentParams(condominiumId: 'c1', payment: payment),
      );
      expect(result, isA<Success<Payment?>>());
    });

    test('validate cobre params nulos, documento e parcelas', () {
      final usecase = RegisterPaymentImpl(repository: repo);
      expect(usecase.validate(null), isA<InvalidParamFailure>());
      expect(
        usecase.validate(RegisterPaymentParams(
          condominiumId: '',
          payment: Payment(totalValue: 10),
        )),
        isA<InvalidParamFailure>(),
      );
      expect(
        usecase.validate(RegisterPaymentParams(
          condominiumId: 'c1',
          payment: Payment(
            supplierIdentification: '1',
            supplierName: 'A',
            totalValue: 10,
          ),
        )),
        isA<RegisterPaymentInvalidDocumentFailure>(),
      );
      expect(
        usecase.validate(RegisterPaymentParams(
          condominiumId: 'c1',
          payment: Payment(
            supplierIdentification: '1',
            supplierName: 'A',
            documentNumber: 'NF',
            totalValue: 10,
            hasInstallments: true,
            equalInstallments: false,
            installments: const [],
          ),
        )),
        isA<RegisterPaymentInvalidInstallmentsFailure>(),
      );
    });
  });

  group('GetPaymentImpl', () {
    test('rejeita campos vazios', () async {
      final result = await GetPaymentImpl(repository: repo)(
        GetPaymentParam(
          condominiumId: '',
          supplierIdentification: '1',
          documentNumber: 'NF',
        ),
      );
      expect(result, isA<Rejection<Payment?>>());
    });

    test('encaminha documento válido', () async {
      final result = await GetPaymentImpl(repository: repo)(
        GetPaymentParam(
          condominiumId: 'c1',
          supplierIdentification: '1',
          documentNumber: 'NF-9',
        ),
      );
      expect(result, isA<Success<Payment?>>());
      expect(repo.last, 'NF-9');
    });
  });

  group('ListPaymentHistoryImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await ListPaymentHistoryImpl(repository: repo)(
        ListPaymentHistoryParam(condominiumId: ''),
      );
      expect(result, isA<Rejection<List<PaymentHistoryItem>>>());
    });

    test('lista o histórico', () async {
      final result = await ListPaymentHistoryImpl(repository: repo)(
        ListPaymentHistoryParam(condominiumId: 'c1'),
      );
      expect(result, isA<Success<List<PaymentHistoryItem>>>());
      expect(repo.last, 'c1');
    });
  });

  group('SendPaymentImpl', () {
    test('rejeita condoId vazio', () async {
      final result = await SendPaymentImpl(repository: repo)(
        SendPaymentParams(condoId: '', data: PaymentDataEntity()),
      );
      expect(result, isA<Rejection<int?>>());
    });

    test('envia pagamento válido', () async {
      final result = await SendPaymentImpl(repository: repo)(
        SendPaymentParams(condoId: 'c1', data: PaymentDataEntity()),
      );
      expect(result, isA<Success<int?>>());
    });
  });

  group('CheckApprovalProfileImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await CheckApprovalProfileImpl(repository: repo)(
        CheckApprovalProfileParam(condominiumId: ''),
      );
      expect(result, isA<Rejection<bool>>());
    });

    test('consulta o perfil', () async {
      final result = await CheckApprovalProfileImpl(repository: repo)(
        CheckApprovalProfileParam(condominiumId: 'c1'),
      );
      expect(result, isA<Success<bool>>());
      expect(repo.last, 'c1');
    });
  });
}
