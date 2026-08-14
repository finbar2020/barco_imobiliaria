import 'package:essentials/configs/environment.dart';

class ProductionEnvironment extends Environment {
  ProductionEnvironment()
      : super(
            isProduction: true,
            name: "Produção",
            apiUrl: "https://morarapp.lellocondominios.com.br/api/v4");
}
