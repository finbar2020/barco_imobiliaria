import 'package:essentials/configs/environment.dart';

class StagingMeEnvironment extends Environment {
  StagingMeEnvironment()
      : super(
            isProduction: false,
            name: "StagingMe",
            apiUrl: "http://sindicoapp-hmgme.lellocondominios.com.br/api/v4");
}
