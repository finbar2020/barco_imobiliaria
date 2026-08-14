import 'package:essentials/configs/environment.dart';

class Dev3Environment extends Environment {
  Dev3Environment()
      : super(
          name: "Devproj03",
          isProduction: false,
          apiUrl:
              "http://colaboradorapp-devproj03.lellocondominios.com.br/api/v4",
        );
}
