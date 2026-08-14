import 'package:essentials/configs/environment.dart';

class DevelopmentProj1Environment extends Environment {
  DevelopmentProj1Environment()
      : super(
          isProduction: false,
          name: "Devproj01",
          apiUrl: "http://sindicoapp-devproj01.lellocondominios.com.br/api/v4",
        );
}
