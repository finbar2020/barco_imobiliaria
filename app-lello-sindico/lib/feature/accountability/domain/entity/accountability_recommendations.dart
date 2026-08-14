import 'package:essentials/essentials.dart';

class AccountabilityRecommendations {
  String? name;
  String? date;
  bool? isUser;
  AccountabilityRecommendations({
    this.name,
    this.date,
    this.isUser,
  });

  String? get dateFormatted {
    if (date != null) {
      var dateFormat = DateFormat("dd/MM/yyyy HH:mm");
      var dateForm = dateFormat.parse(date!);
      return dateFormat.format(dateForm).replaceAll(" ", " às ");
    }

    return null;
  }
}
