import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';

class ComfortCompletedRequest {
  String idRequest;
  DateTime dateRequest;
  double? rating;
  bool purchased;
  String imageHash;
  String idPartner;
  ComfortPartner partner;
  bool isCanCancel;
  bool isCanResend;
  DateTime? resendDate;
  String? comment;
  ComfortRequestMessageType? messageType;
  ComfortRequestStatus status;
  DateTime? messageDate;
  DateTime? canceledDate;

  bool isExpanded = false;

  ComfortCompletedRequest({
    required this.idRequest,
    required this.dateRequest,
    required this.rating,
    required this.purchased,
    required this.imageHash,
    required this.idPartner,
    required this.partner,
    required this.isCanCancel,
    required this.isCanResend,
    required this.resendDate,
    required this.comment,
    required this.messageType,
    required this.status,
    required this.messageDate,
    required this.canceledDate,
  });

  String? get getRequestDateFormatted {
    final dateFormat = new DateFormat('dd/MM/yyyy');
    return dateFormat.format(dateRequest);
  }

  String get statusText {
    switch (status) {
      case ComfortRequestStatus.sended:
        return "comfort_request_status_sended";
      case ComfortRequestStatus.achived:
        return "comfort_request_status_achived";
      case ComfortRequestStatus.canceled:
        return "comfort_request_status_canceled";
      case ComfortRequestStatus.resent:
        return "comfort_request_status_resent";
    }
  }

  Color statusColor(ThemeData theme) {
    switch (status) {
      case ComfortRequestStatus.sended:
        return Colors.green;
      case ComfortRequestStatus.achived:
        return Colors.grey;
      case ComfortRequestStatus.canceled:
        return Colors.red;
      case ComfortRequestStatus.resent:
        return Colors.orange;
    }
  }

  static String getMessageTypeString(
      BuildContext context, ComfortRequestMessageType? messageType) {
    switch (messageType) {
      case ComfortRequestMessageType.doubt:
        return getString(context, "comfort_message_subject_doubt");
      case ComfortRequestMessageType.did_not_receive_return:
        return getString(
            context, "comfort_message_subject_did_not_receive_return");
      case ComfortRequestMessageType.other:
        return getString(context, "comfort_message_subject_other");
      case ComfortRequestMessageType.complaint:
        return getString(context, "comfort_message_subject_complaint");
      case ComfortRequestMessageType.suggestion:
        return getString(context, "comfort_message_subject_suggestion");
      default:
        return getString(context, "comfort_message_subject_doubt");
    }
  }
}
