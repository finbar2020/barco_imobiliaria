import 'package:essentials/configs/environment.dart';

class DevelopmentProj2Environment extends Environment {
  DevelopmentProj2Environment()
      : super(
          isProduction: false,
          name: "Devproj02",
          apiUrl: "http://sindicoapp-devproj02.lellocondominios.com.br/api/v4",
        );
}
