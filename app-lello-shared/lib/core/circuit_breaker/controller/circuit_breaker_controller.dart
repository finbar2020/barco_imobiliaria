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

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _snapshotsSubscription;

  void _createStreamdatabase() {
    try {
      var colection = database.collection(
          environment.isProduction ? "circuit_break" : "circuit_break_homolog");
      _snapshotsSubscription = colection.snapshots().listen((event) {
        if (ruleStream.isClosed) return;
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
    _snapshotsSubscription?.cancel();
    _snapshotsSubscription = null;
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

    if (minVersion.isNotEmpty &&
        _compareVersions(currentVersion, minVersion) < 0) {
      return false;
    }

    if (maxVersion.isNotEmpty &&
        _compareVersions(currentVersion, maxVersion) > 0) {
      return false;
    }

    return true;
  }

  /// Compara duas versões segmento a segmento, tratando segmentos ausentes
  /// como 0 (`2.0` equivale a `2.0.0`).
  /// Devolve negativo se [a] < [b], 0 se iguais e positivo se [a] > [b].
  int _compareVersions(String a, String b) {
    final aParts = a.split('.');
    final bParts = b.split('.');
    final length = aParts.length > bParts.length ? aParts.length : bParts.length;

    for (int i = 0; i < length; i++) {
      final aPart = i < aParts.length ? int.parse(aParts[i]) : 0;
      final bPart = i < bParts.length ? int.parse(bParts[i]) : 0;

      if (aPart != bPart) return aPart < bPart ? -1 : 1;
    }

    return 0;
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
