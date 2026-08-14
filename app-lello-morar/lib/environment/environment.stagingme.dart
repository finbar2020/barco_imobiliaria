import 'package:essentials/configs/environment.dart';

class StagingMeEnvironment extends Environment {
  StagingMeEnvironment()
      : super(
            isProduction: false,
            name: "Homologação ME",
            apiUrl: "http://morarapp-hmgme.lellocondominios.com.br/api/v4");
}
