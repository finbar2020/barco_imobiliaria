import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_remote_data_source.dart';
import 'package:lello/feature/accountability/data/model/accountability_approval.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_approval_repository.dart';

class AccountabilityApprovalRepositoryImpl
    extends AccountabilityApprovalRepository {
  final AccountabilityApprovalRemoteDataSource dataSource;

  AccountabilityApprovalRepositoryImpl({required this.dataSource});

  @override
  Future<Try<AccountabilityApproval>> insert(
      AccountabilityApproval approval) async {
    try {
      final result = await dataSource
          .insert(AccountabilityApprovalModel.fromEntity(approval)!);
      return Success(result.toEntity());
    } catch (ex) {
      //todo: handle http errors
      return Rejection(UnknownFailure(ex));
    }
  }
}
