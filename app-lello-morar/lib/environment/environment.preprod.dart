import 'package:essentials/configs/environment.dart';

class PreProductionEnvironment extends Environment {
  PreProductionEnvironment()
      : super(
            isProduction: false,
            name: "Pre-Prod",
            apiUrl: "https://morarapp-preprod.lellocondominios.com.br/api/v4");
}
