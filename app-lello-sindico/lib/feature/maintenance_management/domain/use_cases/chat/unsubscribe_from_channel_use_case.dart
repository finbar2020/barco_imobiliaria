import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../../repository/chat_repository.dart';

/// Request para cancelar inscrição de um canal
class UnsubscribeFromChannelRequest {
  final String channelId;

  const UnsubscribeFromChannelRequest({
    required this.channelId,
  });
}

/// Use case para cancelar inscrição de um canal
abstract class UnsubscribeFromChannelUseCase {
  Future<Either<Failure, void>> call(UnsubscribeFromChannelRequest request);
}

class UnsubscribeFromChannelUseCaseImpl implements UnsubscribeFromChannelUseCase {
  final ChatRepository _repository;

  UnsubscribeFromChannelUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(UnsubscribeFromChannelRequest request) async {
    return await _repository.unsubscribeFromChannel(
      channelId: request.channelId,
    );
  }
}
