import 'package:essentials/configs/environment.dart';

class ProductionEnvironment extends Environment {
  ProductionEnvironment()
      : super(
            isProduction: true,
            name: "Production",
            apiUrl: "https://sindicoapp.lellocondominios.com.br/api/v4");
}
