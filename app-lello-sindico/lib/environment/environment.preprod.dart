import 'package:essentials/configs/environment.dart';

class PreProductionEnvironment extends Environment {
  PreProductionEnvironment()
      : super(
            isProduction: false,
            name: "Pre-Production",
            apiUrl:
                "https://sindicoapp-preprod.lellocondominios.com.br/api/v4");
}
