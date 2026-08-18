import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/entity/billet_periods_availability.dart';
import 'package:lello/feature/income/domain/use_case/get_billet_period_availability/get_billet_period_availability.dart';
import 'package:lello/feature/income/domain/use_case/get_billet_period_availability/get_billet_period_availability_impl.dart';
import 'package:lello/feature/income/domain/use_case/get_billets.dart';
import 'package:lello/feature/income/domain/use_case/get_billets_impl.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/domain/repository/payment_file_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_process_file_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/aws_get_url/aws_get_url.dart';
import 'package:lello/feature/payment/domain/use_case/aws_get_url/aws_get_url_impl.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile_impl.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode_impl.dart';
import 'package:lello/feature/payment/domain/use_case/send_documents/send_documents.dart';
import 'package:lello/feature/payment/domain/use_case/send_documents/send_documents_impl.dart';
import 'package:lello/feature/payment/domain/use_case/upload_documents_aws/upload_documents.dart';
import 'package:lello/feature/payment/domain/use_case/upload_documents_aws/upload_documents_impl.dart';
import 'package:lello/feature/payment/domain/use_case/upload_payment_file/upload_payment_file.dart';
import 'package:lello/feature/payment/domain/use_case/upload_payment_file/upload_payment_file_impl.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_entry_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry_impl.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_attachment_impl.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/upload_new_receipt/upload_new_receipt.dart';
import 'package:lello/feature/resin/domain/use_case/upload_new_receipt/upload_new_receipt_impl.dart';
import 'package:lello/feature/space/domain/repository/space_file_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file_impl.dart';

class _FakeBilletsRepo extends Fake implements BilletsRepository {
  @override
  Future<Try<Billet?>> get(
      String condominiumId, String unitId, DateTime period) async {
    return Success(Billet(id: unitId, value: 10, period: period));
  }

  @override
  Future<Try<BilletPeriodAvailability>> getBilletPeriodAvailability({
    required String condominiumId,
    required int? limit,
    required int? page,
  }) async {
    return Success(BilletPeriodAvailability()..months = ['2026-01']);
  }
}

class _FakePayrollEntryRepo extends Fake implements PayrollEntryRepository {
  @override
  Future<Try<List<PayrollEntry>>> list(
      String condominiumId, DateTime period) async {
    return Success([PayrollEntry()..id = 'e1'..title = 'Salário']);
  }
}

class _FakePaymentRepo extends Fake implements PaymentRepository {
  @override
  Future<Try<Payment?>> findByBarcode(
      String condominiumId, String barcode) async {
    return Success(Payment(documentNumber: barcode));
  }

  @override
  Future<Try<bool>> checkApprovalProfile(String condominiumId) async {
    return Success(true);
  }
}

class _FakeProcessRepo extends Fake implements PaymentProcessFileRepository {
  @override
  Future<Try<UrlUploadS3Model>> getAwsUploadUrl(String condoId) async {
    return Success(UrlUploadS3Model(fileName: 'a.pdf', url: 'https://s3'));
  }

  @override
  Future<Try<String>> uploadFileToAws(File file, String url) async {
    return Success(url);
  }

  @override
  Future<Try<ProcessFilesResponseEntity>> processFiles(
      String condoId, List<String> fileUrls) async {
    return Success(
      ProcessFilesResponseEntity(success: true, status: 'ok'),
    );
  }
}

class _FakePaymentFileRepo extends Fake implements PaymentFileRepository {
  @override
  Future<Try<String>> upload(String condominiumId, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    return Success('file-id');
  }
}

class _FakeSpaceFileRepo extends Fake implements SpaceFileRepository {
  @override
  Future<Try<String>> upload(String condominiumId, String spaceId, File file,
      StreamController<double> progress) async {
    return Success('space-file');
  }
}

class _FakeReportsRepo extends Fake implements ReportsBookRepository {
  @override
  Future<Try<String>> uploadReportAtt(String contentId, File file,
      {Function(String)? onComplete, Function(Exception)? onError}) async {
    return Success(contentId);
  }
}

class _FakeResinRepo extends Fake implements ResinRepository {
  @override
  Future<Try<ResinRefundReceipt>> uploadNewReceipt(String condominiumId,
      String refundId, ResinRefundReceipt receipt) async {
    return Success(receipt..id = refundId);
  }
}

void main() {
  test('Boletos e disponibilidade de períodos', () async {
    final repo = _FakeBilletsRepo();
    expect(
      await GetBilletsImpl(repository: repo)(
        GetBilletsParam(
          condominiumId: '',
          unitId: 'u1',
          period: DateTime(2026, 1),
        ),
      ),
      isA<Rejection<Billet?>>(),
    );
    expect(
      await GetBilletsImpl(repository: repo)(
        GetBilletsParam(
          condominiumId: 'c1',
          unitId: 'u1',
          period: DateTime(2026, 1),
        ),
      ),
      isA<Success<Billet?>>(),
    );
    expect(
      await GetBilletPeriodAvailabilityUseCaseImpl(repository: repo)(
        GetBilletPeriodAvailabilityParam(
          condominiumId: '',
          limit: 12,
          page: 1,
        ),
      ),
      isA<Rejection<BilletPeriodAvailability?>>(),
    );
    expect(
      await GetBilletPeriodAvailabilityUseCaseImpl(repository: repo)(
        GetBilletPeriodAvailabilityParam(
          condominiumId: 'c1',
          limit: 12,
          page: 1,
        ),
      ),
      isA<Success<BilletPeriodAvailability?>>(),
    );
  });

  test('ListPayrollEntryImpl rejeita condomínio vazio', () async {
    final repo = _FakePayrollEntryRepo();
    expect(
      await ListPayrollEntryImpl(repository: repo)(
        ListPayrollEntryParam(condominiumId: '', period: DateTime(2026, 1)),
      ),
      isA<Rejection<List<PayrollEntry>>>(),
    );
    expect(
      await ListPayrollEntryImpl(repository: repo)(
        ListPayrollEntryParam(condominiumId: 'c1', period: DateTime(2026, 1)),
      ),
      isA<Success<List<PayrollEntry>>>(),
    );
  });

  test('Pagamento: barcode, perfil, AWS e documentos', () async {
    final payments = _FakePaymentRepo();
    expect(
      await FindPaymentByBarcodeImpl(repository: payments)(
        FindPaymentByBarcodeParam(condominiumId: 'c1', barcode: ''),
      ),
      isA<Rejection<Payment?>>(),
    );
    expect(
      await FindPaymentByBarcodeImpl(repository: payments)(
        FindPaymentByBarcodeParam(condominiumId: 'c1', barcode: '123'),
      ),
      isA<Success<Payment?>>(),
    );
    expect(
      await CheckApprovalProfileImpl(repository: payments)(
        CheckApprovalProfileParam(condominiumId: 'c1'),
      ),
      isA<Success<bool>>(),
    );

    final process = _FakeProcessRepo();
    expect(
      await AwsGetUrlImpl(repository: process)(AwsGetUrlParams(condoId: '')),
      isA<Rejection<UrlUploadS3Model>>(),
    );
    expect(
      await AwsGetUrlImpl(repository: process)(AwsGetUrlParams(condoId: 'c1')),
      isA<Success<UrlUploadS3Model>>(),
    );
    expect(
      await UploadDocumentsImpl(repository: process)(
        UploadDocumentsParams(url: '', file: File('a.pdf')),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await UploadDocumentsImpl(repository: process)(
        UploadDocumentsParams(url: 'https://s3', file: File('a.pdf')),
      ),
      isA<Success<String>>(),
    );
    expect(
      await SendDocumentsImpl(repository: process)(
        SendDocumentsParams(condoId: 'c1', fileUrls: const []),
      ),
      isA<Rejection<ProcessFilesResponseEntity>>(),
    );
    expect(
      await SendDocumentsImpl(repository: process)(
        SendDocumentsParams(condoId: 'c1', fileUrls: const ['https://s3/a']),
      ),
      isA<Success<ProcessFilesResponseEntity>>(),
    );

    expect(
      await UploadPaymentFileImpl(uploader: _FakePaymentFileRepo())(
        UploadPaymentFileParams(condominiumId: 'c1', file: File('nf.pdf')),
      ),
      isA<Success<String>>(),
    );
  });

  test('Upload de arquivo de espaço, anexo e recibo resin', () async {
    expect(
      await UploadSpaceFileImpl(repository: _FakeSpaceFileRepo())(
        UploadSpaceFileParam(
          condominiumId: '',
          spaceId: 's1',
          file: File('foto.jpg'),
          progress: StreamController<double>(),
        ),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await UploadSpaceFileImpl(repository: _FakeSpaceFileRepo())(
        UploadSpaceFileParam(
          condominiumId: 'c1',
          spaceId: 's1',
          file: File('foto.jpg'),
          progress: StreamController<double>(),
        ),
      ),
      isA<Success<String>>(),
    );

    expect(
      await PutReportAttachmentUseCaseImpl(repository: _FakeReportsRepo())(
        PutReportAttachmentParams(contentId: '', file: File('a.pdf')),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await PutReportAttachmentUseCaseImpl(repository: _FakeReportsRepo())(
        PutReportAttachmentParams(contentId: 'c1', file: File('a.pdf')),
      ),
      isA<Success<String>>(),
    );

    final receipt = ResinRefundReceipt(
      receiptValue: 10,
      receiptType: ResinRefundReceiptType.receipt,
      sendDate: DateTime(2026, 1, 10, 8),
    );
    expect(receipt.sendDateFormatted().contains('10'), isTrue);
    expect(receipt.valueFormatted().contains('10'), isTrue);
    expect(receipt.receiptTypeKey.isNotEmpty, isTrue);
    expect(
      await UploadNewReceiptImpl(repository: _FakeResinRepo())(
        UploadNewReceiptParams(
          condominiumId: 'c1',
          refundId: 'rf1',
          receipt: receipt,
        ),
      ),
      isA<Success<ResinRefundReceipt>>(),
    );
  });
}
