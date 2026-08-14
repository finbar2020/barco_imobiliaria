import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';

abstract class SubUserUseCase extends UseCase<List<SubUser>, GetSubUserParams> {
}

class GetSubUserParams {
  final String unityId;

  GetSubUserParams({required this.unityId});
}
