import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';

import 'get_me.dart';

class GetMeImpl extends GetMe {
  final MeRepository repository;

  GetMeImpl({required this.repository});

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    final error = _validate(origin);
    if (error != null) return Rejection(error);

    final future = origin == DataOrigin.local
        ? repository.selectFromCache()
        : repository.select();
    return await future;
  }

  Failure? _validate(DataOrigin? origin) {
    if (origin == null) return InvalidDataOriginFailure();
    return null;
  }
}
