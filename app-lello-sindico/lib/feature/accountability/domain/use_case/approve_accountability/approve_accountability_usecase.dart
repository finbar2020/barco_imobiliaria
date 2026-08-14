import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_approval_repository.dart';

class ApproveAccountabilityUsecase
    extends UseCase<AccountabilityApproval, Accountability> {
  final AccountabilityApprovalRepository repository;

  ApproveAccountabilityUsecase({required this.repository});

  @override
  Future<Try<AccountabilityApproval>> call(Accountability params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    var approval = AccountabilityApproval()..accountability = params;

    return await repository.insert(approval);
  }

  Failure? _validate(Accountability? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
