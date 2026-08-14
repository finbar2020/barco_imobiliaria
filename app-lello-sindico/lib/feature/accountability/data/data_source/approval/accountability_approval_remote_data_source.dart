import 'package:lello/feature/accountability/data/model/accountability_approval.dart';

abstract class AccountabilityApprovalRemoteDataSource {
  Future<AccountabilityApprovalModel> insert(AccountabilityApprovalModel model);
}
