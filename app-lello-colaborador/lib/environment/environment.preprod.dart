import 'package:essentials/configs/environment.dart';

//TODO: Inserir apiUrl correta para este environment
class PreProductionEnvironment extends Environment {
  PreProductionEnvironment()
      : super(
            name: "PreProduction",
            isProduction: true,
            apiUrl:
                "https://colaboradorapp-preprod.lellocondominios.com.br/api/v4");
}
