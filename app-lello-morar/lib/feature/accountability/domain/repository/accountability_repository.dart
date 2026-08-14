import 'package:essentials/essentials.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_periods.dart';

abstract class AccountabilityRepository {
  Future<Try<Accountability>> select(String condominiumId, DateTime period);
  Future<Try<List<AccountabilityPeriods>>> getPeriod(String condominiumId);
}
