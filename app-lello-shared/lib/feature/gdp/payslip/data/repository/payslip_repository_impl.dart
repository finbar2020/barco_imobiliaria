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
      // Mais recentes primeiro; sem data de processamento vai para o fim.
      result.sort((a, b) {
        final dateA = a.processingDate;
        final dateB = b.processingDate;
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });
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
