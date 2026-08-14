import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import '../../repository/chat_repository.dart';

/// Request para conectar ao WebSocket
class ConnectWebSocketRequest {
  final String jwtToken;
  final String userId;

  const ConnectWebSocketRequest({
    required this.jwtToken,
    required this.userId,
  });
}

/// Use case para conectar ao WebSocket
abstract class ConnectWebSocketUseCase {
  Future<Either<Failure, void>> call(ConnectWebSocketRequest request);
}

class ConnectWebSocketUseCaseImpl implements ConnectWebSocketUseCase {
  final ChatRepository _repository;

  ConnectWebSocketUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, void>> call(ConnectWebSocketRequest request) async {
    return await _repository.connectWebSocket(
      jwtToken: request.jwtToken,
      userId: request.userId,
    );
  }
}
