import 'package:json_annotation/json_annotation.dart';

part 'filter_chat_channels_request_model.g.dart';

/// Request para filtrar canais de chat
@JsonSerializable()
class FilterChatChannelsRequestModel {
  final String? dtStart;
  final String? untilDate;
  final String? display;
  final String? dayCurrent;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? status;
  final List<String>? typeTask;

  const FilterChatChannelsRequestModel({
    this.dtStart,
    this.untilDate,
    this.display,
    this.dayCurrent,
    this.responsibleIds,
    this.assetIds,
    this.status,
    this.typeTask,
  });

  factory FilterChatChannelsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FilterChatChannelsRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterChatChannelsRequestModelToJson(this);
}
