import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_stauts_biometric_enum.dart';

class AccessControl {
  String? idGest;
  String? business;
  String? document;
  String? typeDocument;
  String? foreignDocument;
  String? name;
  dynamic type;
  String? phone;
  StatusBiometric? statusBiometric;
  List<AccessControlGestUnits> gestUnits;
  String? notificationParameter;

  AccessControl({
    this.idGest,
    this.business,
    this.document,
    this.typeDocument,
    this.foreignDocument,
    this.name,
    this.gestUnits = const [],
    this.type,
    this.phone,
    this.statusBiometric,
    this.notificationParameter,
  });

  bool get prestador => type == "SERVICE";

  String? get documentFormatted {
    if (document != null) {
      String result = document!.replaceAll(RegExp('[^A-Za-z0-9]'), '');
      return result;
    } else if (foreignDocument != null) {
      String result = foreignDocument!.replaceAll(RegExp('[^A-Za-z0-9]'), '');
      return result;
    } else {
      return null;
    }
  }

  String? get typeDocumentFormatted {
    if (typeDocument != null) {
      String result = typeDocument!;
      if (result != "RNE") {
        return "Passaporte";
      }
      return result;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return 'AccessControl(idGest: $idGest, business: $business, document: $document, name: $name, gestUnits: $gestUnits)';
  }
}
