import 'package:morar/feature/me/data/model/unity_model.dart';

class Unity extends UnityModel {
  Unity({
    String? id,
    String? notification_context,
    String? title,
    bool? rented,
    bool? compliant,
    bool? agreement,
    bool? term_home_to_go,
  }) : super(
          id: id,
          notificationContext: notification_context,
          title: title,
          rented: rented,
          compliant: compliant,
          agreement: agreement,
          termHomeToGo: term_home_to_go,
        );

  String get namedTitle {
    double? nameTitleDouble = double.tryParse(title ?? "1");
    if (nameTitleDouble == null) {
      return (title ?? "1");
    } else {
      return nameTitleDouble.toStringAsFixed(0);
    }
  }
}
