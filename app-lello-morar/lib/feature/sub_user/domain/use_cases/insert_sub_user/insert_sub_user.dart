import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';

abstract class InsertSubUser
    extends UseCase<List<SubUser>, InsertSubUserParam> {}

class InsertSubUserParam {
  final SubUser subUser;

  InsertSubUserParam({required this.subUser}) : super();
}
