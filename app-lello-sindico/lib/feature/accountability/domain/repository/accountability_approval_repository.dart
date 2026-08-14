import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';

abstract class AccountabilityApprovalRepository {
  Future<Try<AccountabilityApproval>> insert(AccountabilityApproval approval);
}
