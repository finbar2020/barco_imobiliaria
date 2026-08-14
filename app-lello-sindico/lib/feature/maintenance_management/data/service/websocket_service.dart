import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../domain/repository/chat_repository.dart';
import '../../domain/entity/chat/chat_message_entity.dart';

/// Serviço de WebSocket para chat em tempo real
class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<ChatMessageEntity> _messagesController =
      StreamController<ChatMessageEntity>.broadcast();
  final StreamController<WebSocketConnectionStatus> _statusController =
      StreamController<WebSocketConnectionStatus>.broadcast();

  final Map<String, String> _subscribedChannels = {};
  bool _isConnected = false;
  bool _welcomeReceived = false;

  /// URL base do WebSocket
  static const String _baseUrlHomolog =
      'wss://lello-homolog.trackinglabapi.com.br/cable';
  static const String _baseUrlProd = 'wss://lello.trackinglabapi.com.br/cable';

  /// Stream de mensagens recebidas
  Stream<ChatMessageEntity> get messagesStream => _messagesController.stream;

  /// Stream de status da conexão
  Stream<WebSocketConnectionStatus> get connectionStatusStream =>
      _statusController.stream;

  /// Conecta ao WebSocket
  Future<void> connect({
    required String jwtToken,
    required String userId,
    bool isProduction = false,
  }) async {
    if (_isConnected) {
      return;
    }

    try {
      _statusController.add(WebSocketConnectionStatus.connecting);

      final baseUrl = isProduction ? _baseUrlProd : _baseUrlHomolog;
      final url = '$baseUrl?jwt_token=$jwtToken&x_user_id=$userId';

      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Aguarda breve intervalo para conexão estabelecer
      await Future.delayed(const Duration(milliseconds: 500));

      // Escuta mensagens do servidor
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      _isConnected = true;
      _statusController.add(WebSocketConnectionStatus.connected);
    } catch (e) {
      _statusController.add(WebSocketConnectionStatus.error);
      rethrow;
    }
  }

  /// Desconecta do WebSocket
  Future<void> disconnect() async {
    if (!_isConnected) {
      return;
    }

    // Cancela todas as inscrições antes de desconectar
    for (final channelId in _subscribedChannels.keys.toList()) {
      await unsubscribe(channelId);
    }

    await _channel?.sink.close(status.goingAway);
    _channel = null;
    _isConnected = false;
    _statusController.add(WebSocketConnectionStatus.disconnected);
  }

  /// Inscreve em um canal
  Future<void> subscribe({
    required String channelId,
    required String jwtToken,
  }) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }

    // Aguardar welcome se ainda não recebeu
    if (!_welcomeReceived) {
      for (var i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (_welcomeReceived) break;
      }
      if (!_welcomeReceived) {
        throw Exception('Welcome not received from server');
      }
    }

    // Cria identificador do canal
    final identifier = jsonEncode({
      'channel': 'GraphqlChannel',
      'channelId': channelId,
      'Authorization': 'Bearer $jwtToken',
      'request-subdomain': 'lello',
    });

    // Comando de subscribe
    final subscribeCommand = jsonEncode({
      'command': 'subscribe',
      'identifier': identifier,
    });

    _channel!.sink.add(subscribeCommand);

    // Aguarda breve intervalo para o servidor processar
    await Future.delayed(const Duration(milliseconds: 500));

    // Comando de message com GraphQL subscription
    final messageCommand = jsonEncode({
      'command': 'message',
      'identifier': identifier,
      'data': jsonEncode({
        'query': '''
          subscription NewMessageChannel {
            newMessageChannel {
              message {
                id
                content
                createdAt
                channelId
                authorId
                messageType
                author {
                  id
                  name
                  email
                }
                attachment {
                  id
                  name
                  url
                }
              }
            }
          }
        ''',
        'variables': {'chatChannelId': channelId},
        'operationName': 'NewMessageChannel',
        'action': 'execute',
      }),
    });

    _channel!.sink.add(messageCommand);
    _subscribedChannels[channelId] = identifier;
  }

  /// Envia uma mensagem via WebSocket
  Future<void> sendMessage({
    required String channelId,
    required String content,
    required String jwtToken,
  }) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }

    print('📤 Enviando mensagem via WebSocket para canal: $channelId');

    final identifier = jsonEncode({
      'channel': 'GraphqlChannel',
      'channelId': channelId,
      'Authorization': 'Bearer $jwtToken',
      'request-subdomain': 'lello',
    });

    // Comando para enviar mensagem via GraphQL mutation
    final sendMessageCommand = jsonEncode({
      'command': 'message',
      'identifier': identifier,
      'data': jsonEncode({
        'query': '''
          mutation SendMessage(\$channelId: ID!, \$content: String!) {
            sendMessage(channelId: \$channelId, content: \$content) {
              id
              content
              createdAt
              channelId
              authorId
              messageType
              author {
                id
                name
                email
              }
            }
          }
        ''',
        'variables': {
          'channelId': channelId,
          'content': content,
        },
        'operationName': 'SendMessage',
        'action': 'execute',
      }),
    });

    _channel!.sink.add(sendMessageCommand);
    print('✅ Mensagem enviada via WebSocket');
  }

  /// Cancela inscrição de um canal
  Future<void> unsubscribe(String channelId) async {
    if (!_isConnected || !_subscribedChannels.containsKey(channelId)) {
      return;
    }

    final identifier = _subscribedChannels[channelId]!;

    final unsubscribeCommand = jsonEncode({
      'command': 'unsubscribe',
      'identifier': identifier,
    });

    _channel!.sink.add(unsubscribeCommand);
    _subscribedChannels.remove(channelId);

    print('🔌 Unsubscribe do canal: $channelId');

    // Se não há mais canais subscritos, desconectar
    if (_subscribedChannels.isEmpty) {
      print('🔌 Nenhum canal ativo, fechando conexão WebSocket');
      await disconnect();
    }
  }

  /// Trata mensagens recebidas do servidor
  void _handleMessage(dynamic data) {
    try {
      print('📨 WebSocket recebeu: $data');
      final json = jsonDecode(data as String) as Map<String, dynamic>;

      // Ignora mensagens de ping
      if (json['type'] == 'ping') {
        return;
      }

      // Trata mensagem de disconnect
      if (json['type'] == 'disconnect') {
        final reason = json['reason'] ?? 'unknown';
        print('❌ WebSocket disconnect - Razão: $reason');
        _handleDisconnect();
        return;
      }

      // Trata mensagem de welcome
      if (json['type'] == 'welcome') {
        print('✅ WebSocket: Welcome recebido!');
        _welcomeReceived = true;
        return;
      }

      if (json['type'] == 'confirm_subscription') {
        print('✅ WebSocket: Subscription confirmada');
        return;
      }

      if (json['type'] == 'reject_subscription') {
        print('❌ WebSocket: Subscription rejeitada');
        return;
      }

      // Processa mensagem de chat
      if (json.containsKey('message')) {
        final message = json['message'];

        // Verifica se message é um Map
        if (message is! Map<String, dynamic>) {
          return;
        }

        if (message.containsKey('result')) {
          final result = message['result'];

          // Ignora se result for null
          if (result == null) {
            return;
          }

          // Verifica se result é um Map
          if (result is! Map<String, dynamic>) {
            return;
          }

          if (result.containsKey('data')) {
            final resultData = result['data'] as Map<String, dynamic>;

            if (resultData.containsKey('newMessageChannel')) {
              final newMessageData =
                  resultData['newMessageChannel'] as Map<String, dynamic>;

              if (newMessageData.containsKey('message')) {
                final messageData =
                    newMessageData['message'] as Map<String, dynamic>;

                // Converte para entity e emite no stream
                final messageEntity = _parseMessage(messageData);
                print('📬 Nova mensagem recebida: ${messageEntity.id}');
                _messagesController.add(messageEntity);
              }
            }
          }
        }
      }
    } catch (e) {
      print('❌ Erro ao processar mensagem WebSocket: $e');
    }
  }

  /// Parse de mensagem do JSON para Entity
  ChatMessageEntity _parseMessage(Map<String, dynamic> json) {
    return ChatMessageEntity(
      id: json['id'] as String,
      content: json['content'] as String?, // ✅ Nullable para mensagens de anexo
      channelId: json['channelId'] as String,
      authorId: json['authorId'] as String,
      messageType: json['messageType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: ChatAuthorEntity(
        id: json['author']['id'] as String,
        name: json['author']['name'] as String,
        email: json['author']['email'] as String,
      ),
      attachment: json['attachment'] != null
          ? ChatAttachmentEntity(
              id: json['attachment']['id'] as String,
              name: json['attachment']['name'] as String,
              url: json['attachment']['url'] as String,
              attachmentType: json['attachment']['attachmentType']
                  as String?, // ✅ Adicionado
              fileSize:
                  json['attachment']['fileSize'] as String?, // ✅ Adicionado
            )
          : null,
      isUnread: true, // Nova mensagem sempre começa como não lida
    );
  }

  /// Trata erros da conexão
  void _handleError(dynamic error) {
    print('❌ WebSocket error: $error');
    _statusController.add(WebSocketConnectionStatus.error);
  }

  /// Trata desconexão
  void _handleDisconnect() {
    print('🔌 WebSocket desconectado');
    _isConnected = false;
    _welcomeReceived = false;
    _subscribedChannels.clear();
    _statusController.add(WebSocketConnectionStatus.disconnected);
  }

  /// Dispose dos recursos
  void dispose() {
    disconnect();
    _messagesController.close();
    _statusController.close();
  }
}
