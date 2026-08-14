import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:shared_features/feature/gdp/payslip/domain/repository/payslip_repository.dart';

class PayslipRepositoryImpl extends PayslipRepository {
  final PayslipRemoteDataSource remoteDataSource;

  PayslipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<Payslip>>> getPayslip(String registrationNumber) async {
    try {
      final result = await remoteDataSource.find(registrationNumber);
      result
          .sort((a, b) => b.processingDate?.compareTo(a.processingDate!) ?? 1);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<PayslipFile>> getPayslipFile(
      String nameFile, String registrationNumber) async {
    try {
      final result =
          await remoteDataSource.getFile(nameFile, registrationNumber);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
