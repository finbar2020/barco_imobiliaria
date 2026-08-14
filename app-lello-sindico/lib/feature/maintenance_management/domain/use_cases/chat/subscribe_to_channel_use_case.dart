import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../../repository/chat_repository.dart';

/// Request para inscrever em um canal
class SubscribeToChannelRequest {
  final String channelId;
  final String jwtToken;

  const SubscribeToChannelRequest({
    required this.channelId,
    required this.jwtToken,
  });
}

/// Use case para inscrever em um canal
abstract class SubscribeToChannelUseCase {
  Future<Either<Failure, void>> call(SubscribeToChannelRequest request);
}

class SubscribeToChannelUseCaseImpl implements SubscribeToChannelUseCase {
  final ChatRepository _repository;

  SubscribeToChannelUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(SubscribeToChannelRequest request) async {
    return await _repository.subscribeToChannel(
      channelId: request.channelId,
      jwtToken: request.jwtToken,
    );
  }
}
