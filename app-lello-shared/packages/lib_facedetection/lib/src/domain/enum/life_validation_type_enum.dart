import 'dart:math';

enum LifeValidationTypeEnum {
  right,
  left,
  down,
  up,
  smile,
  blink,
}

class LifeValidationTypeEnumUtils {
  static List<LifeValidationTypeEnum> generateRandom(int n) {
    var rnd = Random();
    return List.generate(
        n,
        (i) => LifeValidationTypeEnum
            .values[rnd.nextInt(LifeValidationTypeEnum.values.length)]);
  }

  static List<LifeValidationTypeEnum> generateRandomUnique(
      int n, List<LifeValidationTypeEnum> actionsLifeValidation) {
    if (actionsLifeValidation.isEmpty) return [];

    var list = List<LifeValidationTypeEnum>.from(actionsLifeValidation)
      ..shuffle();
    return list.take(n.clamp(0, list.length)).toList();
  }
}
