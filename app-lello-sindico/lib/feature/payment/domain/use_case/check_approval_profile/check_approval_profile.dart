import 'package:essentials/base/use_case.dart';

abstract class CheckApprovalProfile
    extends UseCase<bool, CheckApprovalProfileParam> {}

class CheckApprovalProfileParam {
  final String condominiumId;

  CheckApprovalProfileParam({
    required this.condominiumId,
  });
}
