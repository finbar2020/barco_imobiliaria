import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/data/data_source/remote/nonpayments_remote_data_source.dart';
import 'package:lello/feature/nonpayment/data/repository/nonpayments_repository.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';

class NonPaymentsRepositoryImpl extends NonPaymentsRepository {
  final NonPaymentsRemoteDataSource remoteDataSource;

  NonPaymentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<NonPayment>> get(String condominiumId, String period) async {
    try {
      final result = await remoteDataSource.get(condominiumId, period);
      return Success(result.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
