import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';

abstract class UpdateSubUser
    extends UseCase<List<SubUser>, UpdateSubUserParams> {}

class UpdateSubUserParams {
  final SubUser subUser;

  UpdateSubUserParams({required this.subUser});
}
