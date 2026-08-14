import 'dart:io';

class EmployeeReferralEntity {
  String? description;
  String? city;
  String? region;
  File? file;
  String? fileTempHash;
  String? filePath;
  bool hasRegion;
  List<String> regions;

  EmployeeReferralEntity(
      {this.description,
      this.city,
      this.region,
      this.file,
      this.fileTempHash,
      this.filePath,
      this.hasRegion = false,
      this.regions = const []});

  bool get isValid {
    if (description == null || description == "") {
      return false;
    }

    if (city == null || city == "") {
      return false;
    }

    if (file == null) {
      return false;
    }

    return true;
  }

  bool get isRegionValid {
    if (region == null && hasRegion) {
      return false;
    }
    if (region != null && !hasRegion) {
      return false;
    }
    return true;
  }
}
