import 'package:essentials/configs/environment.dart';

class Dev2Environment extends Environment {
  Dev2Environment()
      : super(
          name: "Devproj02",
          isProduction: false,
          apiUrl:
              "http://colaboradorapp-devproj02.lellocondominios.com.br/api/v4",
        );
}
