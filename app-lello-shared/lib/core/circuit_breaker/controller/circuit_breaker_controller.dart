import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';

class CircuitBreakerController {
  static const CircuitBreakerSituationEnum DAFAULT_ACTION =
      CircuitBreakerSituationEnum.display;

  bool opacityValue = false;
  String disableMessage = "";
  final FirebaseFirestore database;
  final dynamic sessionBloc;
  final Environment environment;

  CircuitBreakerController({
    required this.database,
    required this.sessionBloc,
    required this.environment,
  }) {
    _createStreamdatabase();
  }

  void _createStreamdatabase() {
    try {
      var colection = database.collection(
          environment.isProduction ? "circuit_break" : "circuit_break_homolog");
      colection.snapshots().listen((event) {
        listCircuitRules = event.docs
            .map<CircuitItemRule>((e) => CircuitItemRule.fromMap(e))
            .toList();
        ruleStream.add(listCircuitRules);
      });
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'Error on firestore for circuit_break',
      );
    }
  }

  //Dispose
  void dispose() {
    ruleStream.close();
  }

  List<CircuitItemRule> listCircuitRules = [];
  final StreamController<List<CircuitItemRule>> ruleStream =
      StreamController<List<CircuitItemRule>>.broadcast();

  CircuitItemRule? getRule(
      {required String applicationRbac, required String? reference}) {
    if (!listCircuitRules.any((element) => element.name == applicationRbac))
      return null;

    var ruleReference = listCircuitRules.where((element) =>
        element.name == applicationRbac &&
        checkReferenceNotInList(
          list: element.excludedReferenceContext,
          reference: reference,
        ) &&
        checkReferenceInList(
          list: element.includedReferenceContext,
          reference: reference,
        ) &&
        isAppVersionInRange(
          minVersion: element.minimumVersion ?? "",
          maxVersion: element.maximumVersion ?? "",
        ));

    return ruleReference.isEmpty ? null : ruleReference.first;
  }

//Determine if current app version are in range to apply circuit breaker
  bool isAppVersionInRange({
    required String minVersion,
    required String maxVersion,
  }) {
    try {
      final versionInRange = checkVersionInRange(
        currentVersion: AppInfo.instance.packageInfo.version,
        minVersion: minVersion,
        maxVersion: maxVersion,
      );
      return versionInRange;
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'Error checking app version range',
      );
    }
    return false; // Return false if there's an error or the version couldn't be obtained
  }

  bool checkVersionInRange({
    required String currentVersion,
    required String minVersion,
    required String maxVersion,
  }) {
    if (minVersion.isEmpty && maxVersion.isEmpty) return true;

    if (minVersion.isEmpty && maxVersion.isNotEmpty) {
      final currentVersionParts = currentVersion.split('.');
      final maxVersionParts = maxVersion.split('.');

      for (int i = 0;
          i < currentVersionParts.length && i < maxVersionParts.length;
          i++) {
        final currentPart = int.parse(currentVersionParts[i]);
        final maxPart = int.parse(maxVersionParts[i]);

        if (currentPart < maxPart) {
          return true;
        } else if (currentPart > maxPart) {
          return false;
        }
      }
      // Retorna versões iguais como true
      return currentVersionParts.length <= maxVersionParts.length;
    } else if (minVersion.isNotEmpty && maxVersion.isEmpty) {
      final currentVersionParts = currentVersion.split('.');
      final minVersionParts = minVersion.split('.');

      for (int i = 0;
          i < currentVersionParts.length && i < minVersionParts.length;
          i++) {
        final currentPart = int.parse(currentVersionParts[i]);
        final minPart = int.parse(minVersionParts[i]);

        if (currentPart > minPart) {
          return true;
        } else if (currentPart < minPart) {
          return false;
        }
      }
      // Retorna versões iguais como true
      return currentVersionParts.length <= minVersionParts.length;
    } else {
      //minVersion e maxVersion não vazias
      final currentVersionParts = currentVersion.split('.');
      final minVersionParts = minVersion.split('.');
      final maxVersionParts = maxVersion.split('.');

      var minLength = currentVersionParts.length;
      if (minVersionParts.isNotEmpty && minVersionParts.length < minLength) {
        minLength = minVersionParts.length;
      }
      if (maxVersionParts.isNotEmpty && maxVersionParts.length < minLength) {
        minLength = maxVersionParts.length;
      }

      for (int i = 0; i < minLength; i++) {
        final currentPart = int.parse(currentVersionParts[i]);
        final minPart = int.parse(minVersionParts[i]);
        final maxPart = int.parse(maxVersionParts[i]);

        if (currentPart < minPart || currentPart > maxPart) {
          return false;
        } else if (currentPart > minPart || currentPart < maxPart) {
          return true;
        }
      }

      return true; // As versões são iguais
    }
  }

  bool checkReferenceInList(
      {required List<String>? list, required String? reference}) {
    if (list == null || list.isEmpty) {
      return true;
    }

    if (reference == null || reference.isEmpty) {
      return false;
    }
    final excludedReferences = list.map<int>((value) {
      final cleanedValue = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleanedValue) ?? 0;
    }).toList();

    final cleanedReference = reference.replaceAll(RegExp(r'^0+'), '');

    final referenceValue = int.tryParse(cleanedReference) ?? 0;
    return excludedReferences.contains(referenceValue);
  }

  bool checkReferenceNotInList(
      {required List<String>? list, required String? reference}) {
    if (list == null || list.isEmpty) {
      return true;
    }

    if (reference == null || reference.isEmpty) {
      return false;
    }
    final excludedReferences = list.map<int>((value) {
      final cleanedValue = value.toString().replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleanedValue) ?? 0;
    }).toList();

    final cleanedReference = reference.replaceAll(RegExp(r'^0+'), '');

    final referenceValue = int.tryParse(cleanedReference) ?? 0;
    return !excludedReferences.contains(referenceValue);
  }

  CircuitBreakerSituationEnum convertStringToEnum(
      {required String? situation}) {
    switch (situation) {
      case 'disabled':
        return CircuitBreakerSituationEnum.disabled;
      case 'hide':
        return CircuitBreakerSituationEnum.hide;
      default:
        throw Exception(
            'Invalid CircuitBreakerSituationEnum value: $situation');
    }
  }

  bool checkVisible({
    required String applicationRbac,
    required String reference,
    bool hasHortaCheck = false,
  }) {
    var itemRule =
        getRule(applicationRbac: applicationRbac, reference: reference);
    if (itemRule?.situation == CircuitBreakerSituationEnum.hide ||
        !sessionBloc.checkRback(applicationRbac)) return false;

    if (hasHortaCheck) {
      var horta = sessionBloc.getHortaRemoteConfig();
      return horta != null ? true : false;
    }

    return true;
  }
}
