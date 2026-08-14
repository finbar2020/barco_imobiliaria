import 'package:essentials/configs/environment.dart';

class Dev1Environment extends Environment {
  Dev1Environment()
      : super(
          name: "Devproj01",
          isProduction: false,
          apiUrl:
              "http://colaboradorapp-devproj01.lellocondominios.com.br/api/v4",
        );
}
