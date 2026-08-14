import 'package:morar/feature/accountability/data/model/accountability_model.dart';
import 'package:morar/feature/accountability/data/model/accountability_period_model.dart';

abstract class AccountabilityRemoteDataSource {
  Future<List<AccountabilityPeriodModel>> getPeriod(String condominiumId);
  Future<AccountabilityModel> select(String condominiumId, DateTime period);
}
