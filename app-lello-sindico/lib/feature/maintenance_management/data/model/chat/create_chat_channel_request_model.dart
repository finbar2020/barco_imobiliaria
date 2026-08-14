import 'package:json_annotation/json_annotation.dart';

part 'create_chat_channel_request_model.g.dart';

/// Request para criar um canal de chat
@JsonSerializable(includeIfNull: false)
class CreateChatChannelRequestModel {
  final String taskId;
  final String? name;

  const CreateChatChannelRequestModel({
    required this.taskId,
    this.name,
  });

  factory CreateChatChannelRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateChatChannelRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatChannelRequestModelToJson(this);
}

/// Response de criação de canal
/// A API retorna apenas o ID do canal criado como string no campo "data"
@JsonSerializable()
class CreateChatChannelResponseModel {
  final String channelId;

  const CreateChatChannelResponseModel({
    required this.channelId,
  });

  /// Factory que aceita tanto string direta quanto objeto
  factory CreateChatChannelResponseModel.fromJson(dynamic json) {
    if (json is String) {
      // Se a resposta for uma string direta, é o channelId
      return CreateChatChannelResponseModel(channelId: json);
    } else if (json is Map<String, dynamic>) {
      // Se for um objeto, tenta pegar o channelId de diferentes campos
      // Primeiro tenta 'data' (resposta da API), depois 'channelId' ou 'id'
      final channelId = json['data'] as String? ?? 
                       json['channelId'] as String? ?? 
                       json['id'] as String?;
      
      if (channelId == null) {
        throw FormatException('channelId, id ou data não encontrado no JSON: $json');
      }
      return CreateChatChannelResponseModel(channelId: channelId);
    }
    throw FormatException('Formato inválido para CreateChatChannelResponseModel. Tipo: ${json.runtimeType}, Valor: $json');
  }

  Map<String, dynamic> toJson() => _$CreateChatChannelResponseModelToJson(this);
}
