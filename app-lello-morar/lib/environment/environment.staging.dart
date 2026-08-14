import 'package:essentials/configs/environment.dart';

class StagingEnvironment extends Environment {
  StagingEnvironment()
      : super(
            isProduction: false,
            name: "Homologação",
            apiUrl: "http://morarapp-qa.lellocondominios.com.br/api/v4");
}
