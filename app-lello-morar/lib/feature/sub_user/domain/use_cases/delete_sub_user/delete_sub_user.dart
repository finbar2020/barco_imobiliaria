import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';

abstract class DeleteSubUser extends UseCase<bool, DeleteSubUserParams> {}

class DeleteSubUserParams {
  final String unitId;
  final String cpfCnpj;

  DeleteSubUserParams({
    required this.unitId,
    required this.cpfCnpj,
  });
}
