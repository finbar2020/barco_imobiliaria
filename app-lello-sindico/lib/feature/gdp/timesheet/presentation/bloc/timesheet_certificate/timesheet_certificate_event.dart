import 'dart:io';

import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';

abstract class TimesheetCertificateEvent {}

class TimesheetCertificateLoadingEvent extends TimesheetCertificateEvent {
  TimesheetCertificateLoadingEvent();
}

class TimesheetCertificateLoadedEvent extends TimesheetCertificateEvent {
  final List<TimesheetOccurrenceCertificateEntity> list;
  final bool getArchiveFailed;
  final File? pdf;
  final String? filename;
  TimesheetCertificateLoadedEvent({
    required this.list,
    this.getArchiveFailed = false,
    this.pdf,
    this.filename,
  });
}

class TimesheetCertificateFailedEvent extends TimesheetCertificateEvent {
  TimesheetCertificateFailedEvent();
}
