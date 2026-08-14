import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../../entity/chat/chat_message_entity.dart';
import '../../repository/chat_repository.dart';

/// Request para enviar mensagem
class SendChatMessageRequest {
  final String channelId;
  final String content;
  final String? attachmentId;

  const SendChatMessageRequest({
    required this.channelId,
    required this.content,
    this.attachmentId,
  });
}

/// Use case para enviar mensagem no chat
abstract class SendChatMessageUseCase {
  Future<Either<Failure, ChatMessageEntity>> call(
    SendChatMessageRequest request,
  );
}

class SendChatMessageUseCaseImpl implements SendChatMessageUseCase {
  final ChatRepository _repository;

  SendChatMessageUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(
    SendChatMessageRequest request,
  ) async {
    return await _repository.sendMessage(
      channelId: request.channelId,
      content: request.content,
      attachmentId: request.attachmentId,
    );
  }
}
