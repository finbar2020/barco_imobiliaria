import 'package:essentials/configs/environment.dart';

class DevelopmentProj3Environment extends Environment {
  DevelopmentProj3Environment()
      : super(
          isProduction: false,
          name: "Devproj03",
          apiUrl: "http://sindicoapp-devproj03.lellocondominios.com.br/api/v4",
        );
}
