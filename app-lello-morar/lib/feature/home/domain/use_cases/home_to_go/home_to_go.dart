import 'package:essentials/essentials.dart';

abstract class HomeToGo extends UseCase<String, HomeToGoParams> {}

class HomeToGoParams {
  final String unitId;

  HomeToGoParams({required this.unitId});
}
