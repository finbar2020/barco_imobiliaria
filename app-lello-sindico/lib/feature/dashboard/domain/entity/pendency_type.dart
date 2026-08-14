import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';

enum PendencyType { payment, notification, pendency, alert, informative }

String pendencyTypeToString(BuildContext context, PendencyType status) {
  switch (status) {
    case PendencyType.pendency:
      return getString(context, "pendency_type_pendency");
    case PendencyType.notification:
      return getString(context, "pendency_type_notification");
    case PendencyType.alert:
      return getString(context, "pendency_type_alert");
    case PendencyType.payment:
      return getString(context, "pendency_type_payment");
    case PendencyType.informative:
      return getString(context, "pendency_type_informative");
  }
}

PendencyType stringToPendencyType(String type) {
  switch (type) {
    case "pendency":
      return PendencyType.pendency;
    case "notification":
      return PendencyType.notification;
    case "alert":
      return PendencyType.alert;
    case "payment":
      return PendencyType.payment;
    case "informative":
      return PendencyType.informative;
    default:
      return PendencyType.informative;
  }
}
