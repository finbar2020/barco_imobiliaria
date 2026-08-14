import 'package:essentials/essentials.dart';
import '../../entity/chat/chat_channel_entity.dart';
import '../../repository/chat_repository.dart';

/// Request para criar canal de chat
class CreateChatChannelRequest {
  final String taskId;
  final String? name;

  const CreateChatChannelRequest({
    required this.taskId,
    this.name,
  });
}

/// Use case para criar canal de chat
abstract class CreateChatChannelUseCase {
  Future<Either<Failure, ChatChannelEntity>> call(
    CreateChatChannelRequest request,
  );
}

class CreateChatChannelUseCaseImpl implements CreateChatChannelUseCase {
  final ChatRepository _repository;

  CreateChatChannelUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, ChatChannelEntity>> call(
    CreateChatChannelRequest request,
  ) async {
    return await _repository.createChannel(
      taskId: request.taskId,
      name: request.name,
    );
  }
}
