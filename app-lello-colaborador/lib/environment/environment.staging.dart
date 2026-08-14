import 'package:essentials/configs/environment.dart';

//TODO: Inserir apiUrl correta para este environment
class StagingEnvironment extends Environment {
  StagingEnvironment()
      : super(
            name: "Homologação",
            isProduction: false,
            apiUrl: "http://colaboradorapp-qa.lellocondominios.com.br/api/v4");
}
