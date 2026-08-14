import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:lello/feature/payment/data/data_source/approval/payment_approval_remote_data_source.dart';
import 'package:lello/feature/payment/data/model/payment_approval_model.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/repository/payment_approval_repository.dart';

class PaymentApprovalRepositoryImpl extends PaymentApprovalRepository {
  final PaymentApprovalRemoteDataSource dataSource;

  PaymentApprovalRepositoryImpl({required this.dataSource});
  @override
  Future<Try<PaymentApproval>> insert(
      String condominiumId, PaymentApproval approval) async {
    try {
      final model = PaymentApprovalModel.fromEntity(approval)!;
      final result = await dataSource.insert(condominiumId, model);
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      if (e is ApiFailure) {
        switch (e.status) {
          case 400:
            return Rejection(KnownFailure(e.title?.toString() ?? "", e));
          default:
            FirebaseCrashlytics.instance.recordError(
              e,
              stacktrace,
              reason:
                  'condominiumId: $condominiumId - paymentId: ${approval.paymentId} - error: ${e.title?.toString() ?? ""}',
            );
            return Rejection(UnknownFailure(e));
        }
      }
      //todo: handle http failures
      return Rejection(UnknownFailure(e));
    }
  }
}
