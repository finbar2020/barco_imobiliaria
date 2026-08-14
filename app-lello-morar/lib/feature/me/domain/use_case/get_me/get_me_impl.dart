import 'package:essentials/essentials.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/repository/me_repository.dart';

import 'get_me.dart';

class GetMeImpl extends GetMe {
  final MeRepository repository;

  GetMeImpl({required this.repository});

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    final future = origin == DataOrigin.local
        ? repository.selectFromCache()
        : repository.select();

    return await future;
  }
}
