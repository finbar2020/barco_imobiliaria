import 'package:essentials/essentials.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/domain/repository/session_repository.dart';
import 'package:morar/feature/session/domain/use_case/load_session/load_session.dart';

class LoadSessionImpl extends LoadSession {
  final GetMe getMe;
  final SessionRepository repository;

  LoadSessionImpl({required this.getMe, required this.repository});

  @override
  Future<Try<Session>> call(DataOrigin origin) async {
    final meFuture = getMe.call(origin);
    final sessionFuture = repository.select();

    final results =
        await Future.wait([meFuture, sessionFuture], eagerError: true);

    final meResult = results[0];
    final sessionResult = results[1];

    if (origin == DataOrigin.remote && meResult is Rejection) {
      return Rejection(meResult.get());
    }
    Session result = Session();
    result.me = meResult.getOrElse(() => null) as Me?;

    if (sessionResult is Success<SessionModel?>) {
      final session = sessionResult.get()?.toEntity();

      if (result.me?.condominiums?.isNotEmpty != true)
        return Rejection(KnownFailure("condominiums_not_found", null));
      if (result.me?.allUnitsEntity.isNotEmpty != true)
        return Rejection(KnownFailure("units_not_found", null));

      result.condominium = result.me?.condominiums?.firstWhere(
          (it) => it.reference == session?.condominium?.reference,
          orElse: () => result.me!.condominiums!.first);

      result.unity = result.me?.allUnitsEntity.firstWhere(
          (it) => it.id == session?.unity?.id,
          orElse: () => result.me!.allUnitsEntity.first);
    }

    return Success(result);
  }
}
