import 'package:essentials/configs/environment.dart';

class CustomEnvironment extends Environment {
  CustomEnvironment({required super.apiUrl})
      : super(isProduction: false, name: "Staging");
}
