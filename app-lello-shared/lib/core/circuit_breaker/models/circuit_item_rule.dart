//part 'circuit_item_rule.g.dart';

//@JsonSerializable()
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';

class CircuitItemRule {
  final String name;
  final String? disabledMessage;
  final List<String>? excludedReferenceContext;
  final List<String>? includedReferenceContext;
  final String? minimumVersion;
  final String? maximumVersion;
  final CircuitBreakerSituationEnum? situation;
  CircuitItemRule(
      {required this.name,
      required this.disabledMessage,
      required this.excludedReferenceContext,
      required this.includedReferenceContext,
      required this.maximumVersion,
      required this.minimumVersion,
      required this.situation});

  factory CircuitItemRule.fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>> e) {
    try {
      return CircuitItemRule(
          name: e["name"] ?? "",
          disabledMessage: e["disabledMessage"] ?? "",
          excludedReferenceContext:
              ((e["excludedReferenceContext"] ?? []) as List<dynamic>)
                  .map((e) => e.toString())
                  .toList(),
          includedReferenceContext:
              ((e["includedReferenceContext"] ?? []) as List<dynamic>)
                  .map((e) => e.toString())
                  .toList(),
          minimumVersion: e["minimumVersion"] ?? "",
          maximumVersion: e["maximumVersion"] ?? "",
          situation: stringToEnum(
              CircuitBreakerSituationEnum.values, e["situation"] ?? "display"));
      // Captura ampla: além de `Exception`, campo ausente lança `StateError` e
      // campo com tipo inesperado lança `TypeError` (ambos `Error`).
    } catch (_) {
      return CircuitItemRule(
        disabledMessage: null,
        excludedReferenceContext: null,
        maximumVersion: null,
        minimumVersion: null,
        situation: null,
        includedReferenceContext: null,
        name: "",
      );
    }
  }

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  // factory CircuitItemRule.fromJson(Map<String, dynamic> json) =>
  //     _$CircuitItenRuleFromJson(json);

  // /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$CircuitItenRuleToJson(this);
}
