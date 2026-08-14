import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_api.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_remote_data_source.dart';
import 'package:lello/feature/accountability/data/model/accountability_approval.dart';

class AccountabilityApprovalRemoteDataSourceImpl
    extends AccountabilityApprovalRemoteDataSource {
  final AccountabilityApprovalApi api;

  AccountabilityApprovalRemoteDataSourceImpl({required this.api});

  @override
  Future<AccountabilityApprovalModel> insert(
      AccountabilityApprovalModel model) async {
    final dateFormat = DateFormat("yyyy-MM");
    final response = await api.post(model.accountability!.condominiumId!,
        dateFormat.format(model.accountability!.period!));
    return ApiMapper.map(
        response, (json) => AccountabilityApprovalModel.fromJson(json));
  }
}
