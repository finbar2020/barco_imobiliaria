import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../../entity/chat/chat_channel_entity.dart';
import '../../repository/chat_repository.dart';

/// Request para buscar canais de chat com paginação
class GetChatChannelsRequest {
  final String? dtStart;
  final String? untilDate;
  final String? display;
  final String? dayCurrent;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? status;
  final List<String>? typeTask;
  final int? first;
  final String? after;
  final String? before;
  final int? last;

  const GetChatChannelsRequest({
    this.dtStart,
    this.untilDate,
    this.display,
    this.dayCurrent,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.status,
    this.typeTask,
    this.first,
    this.after,
    this.before,
    this.last,
  });
}

/// Use case para buscar canais de chat com paginação
abstract class GetChatChannelsUseCase {
  Future<Either<Failure, ChatChannelsResponseEntity>> call(
    GetChatChannelsRequest request,
  );
}

class GetChatChannelsUseCaseImpl implements GetChatChannelsUseCase {
  final ChatRepository _repository;

  GetChatChannelsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, ChatChannelsResponseEntity>> call(
    GetChatChannelsRequest request,
  ) async {
    return await _repository.getChannels(
      dtStart: request.dtStart,
      untilDate: request.untilDate,
      display: request.display,
      dayCurrent: request.dayCurrent,
      responsibleIds: request.responsibleIds,
      assetIds: request.assetIds,
      localIds: request.localIds,
      status: request.status,
      typeTask: request.typeTask,
      first: request.first,
      after: request.after,
      before: request.before,
      last: request.last,
    );
  }
}
