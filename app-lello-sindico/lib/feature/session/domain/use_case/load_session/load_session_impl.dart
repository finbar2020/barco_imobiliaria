import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:lello/feature/session/data/model/session_model.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session.dart';

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
    result.me = meResult.getOrElse(() => Me()) as Me?;

    if (sessionResult is Success<SessionModel?>) {
      final sessionModel = sessionResult.get();

      if (result.me?.condominiums?.isNotEmpty != true)
        return Rejection(KnownFailure("condominiums_not_found", null));

      result.selectedCondominium = result.me?.condominiums?.firstWhere(
          (it) => it.reference == sessionModel?.selectedCondominium,
          orElse: () => result.me!.condominiums!.first);
    }

    return Success(result);
  }
}
