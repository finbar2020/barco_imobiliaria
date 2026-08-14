import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';

abstract class TimesheetCertificateEvent extends Equatable {
  const TimesheetCertificateEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetCertificateLoadingEvent extends TimesheetCertificateEvent {
  const TimesheetCertificateLoadingEvent();
}

class TimesheetCertificateLoadedEvent extends TimesheetCertificateEvent {
  final List<TimesheetOccurrenceCertificateEntity> list;
  final bool getArchiveFailed;
  final File? pdf;
  final String? filename;

  const TimesheetCertificateLoadedEvent({
    required this.list,
    this.getArchiveFailed = false,
    this.pdf,
    this.filename,
  });

  @override
  List<Object?> get props => [list, getArchiveFailed, pdf, filename];
}

class TimesheetCertificateFailedEvent extends TimesheetCertificateEvent {
  const TimesheetCertificateFailedEvent();
}
