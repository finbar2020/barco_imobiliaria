import 'dart:io';

import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';

abstract class TimesheetCertificateState {
  TimesheetCertificateState();
}

class TimesheetCertificateLoadingState extends TimesheetCertificateState {
  TimesheetCertificateLoadingState();
}

class TimesheetCertificateLoadedState extends TimesheetCertificateState {
  final List<TimesheetOccurrenceCertificateEntity> list;
  final bool getArchiveFailed;
  final File? file;
  final String? filename;
  TimesheetCertificateLoadedState({
    required this.list,
    this.getArchiveFailed = false,
    this.file,
    this.filename,
  });
}

class TimesheetCertificateFailedState extends TimesheetCertificateState {
  TimesheetCertificateFailedState() : super();
}
