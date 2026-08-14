import 'package:essentials/configs/environment.dart';

class StagingEnvironment extends Environment {
  StagingEnvironment()
      : super(
            isProduction: false,
            name: "Staging",
            apiUrl: "http://sindicoapp-qa.lellocondominios.com.br/api/v4");
}
