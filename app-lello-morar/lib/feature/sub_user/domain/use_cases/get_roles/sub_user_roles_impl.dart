import 'package:essentials/essentials.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_roles/sub_user_roles.dart';

class SubUserRoleCaseImpl extends SubUserRoleCase {
  final SubUserRepository repository;

  SubUserRoleCaseImpl({required this.repository});

  @override
  Future<Try<List<SubUserRole>>> call(Session params) async {
    return await repository.getRoles();
  }
}
