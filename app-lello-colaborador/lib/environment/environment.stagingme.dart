import 'package:essentials/configs/environment.dart';

//TODO: Inserir apiUrl correta para este environment
class StagingMeEnvironment extends Environment {
  StagingMeEnvironment()
      : super(
            name: "Homologação ME",
            isProduction: false,
            apiUrl:
                "http://colaboradorapp-hmgme.lellocondominios.com.br/api/v4");
}
