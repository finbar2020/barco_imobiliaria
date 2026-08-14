import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../../entity/chat/chat_message_entity.dart';
import '../../entity/chat/chat_messages_response_entity.dart';
import '../../repository/chat_repository.dart';

/// Request para buscar mensagens do chat
class GetChatMessagesRequest {
  final String channelId;
  final String? before;
  final String? after;
  final int? limit;

  const GetChatMessagesRequest({
    required this.channelId,
    this.before,
    this.after,
    this.limit,
  });
}

/// Use case para buscar mensagens do chat
abstract class GetChatMessagesUseCase {
  Future<Either<Failure, ChatMessagesResponseEntity>> call(
    GetChatMessagesRequest request,
  );
}

class GetChatMessagesUseCaseImpl implements GetChatMessagesUseCase {
  final ChatRepository _repository;

  GetChatMessagesUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, ChatMessagesResponseEntity>> call(
    GetChatMessagesRequest request,
  ) async {
    return await _repository.getMessages(
      channelId: request.channelId,
      before: request.before,
      after: request.after,
      limit: request.limit,
    );
  }
}
