//TODO: Inserir apiUrl correta para este environment
import 'package:essentials/configs/environment.dart';

class ProductionEnvironment extends Environment {
  ProductionEnvironment()
      : super(
            name: "Production",
            isProduction: true,
            apiUrl: "https://colaboradorapp.lellocondominios.com.br/api/v4");
}
