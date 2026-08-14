import 'package:essentials/app_localization.dart';
import 'package:flutter/material.dart';

enum ComfortFilterRequestStatus { all, sended, canceled, resent }

extension ComfortFilterRequestStatusExtension on ComfortFilterRequestStatus {
  static ComfortFilterRequestStatus stringToEnumStatus(
      BuildContext context, String? value) {
    if (value == getString(context, "comfort_request_filter_status_all")) {
      return ComfortFilterRequestStatus.all;
    } else if (value ==
        getString(context, "comfort_request_filter_status_sent")) {
      return ComfortFilterRequestStatus.sended;
    } else if (value ==
        getString(context, "comfort_request_filter_status_resent")) {
      return ComfortFilterRequestStatus.resent;
    } else {
      return ComfortFilterRequestStatus.canceled;
    }
  }

  static String? enumToStringStatus(
      BuildContext context, ComfortFilterRequestStatus? value) {
    switch (value) {
      case ComfortFilterRequestStatus.all:
        return getString(context, "comfort_request_filter_status_all");
      case ComfortFilterRequestStatus.sended:
        return getString(context, "comfort_request_filter_status_sent");
      case ComfortFilterRequestStatus.resent:
        return getString(context, "comfort_request_filter_status_resent");
      case ComfortFilterRequestStatus.canceled:
        return getString(context, "comfort_request_filter_status_canceled");
      default:
        return null;
    }
  }
}
