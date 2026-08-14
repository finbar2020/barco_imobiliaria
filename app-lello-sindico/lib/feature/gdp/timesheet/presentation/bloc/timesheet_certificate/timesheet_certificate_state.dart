import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';

abstract class TimesheetCertificateState extends Equatable {
  const TimesheetCertificateState();

  @override
  List<Object?> get props => [];
}

class TimesheetCertificateLoadingState extends TimesheetCertificateState {
  const TimesheetCertificateLoadingState();
}

class TimesheetCertificateLoadedState extends TimesheetCertificateState {
  final List<TimesheetOccurrenceCertificateEntity> list;
  final bool getArchiveFailed;
  final File? file;
  final String? filename;

  const TimesheetCertificateLoadedState({
    required this.list,
    this.getArchiveFailed = false,
    this.file,
    this.filename,
  });

  @override
  List<Object?> get props => [list, getArchiveFailed, file, filename];
}

class TimesheetCertificateFailedState extends TimesheetCertificateState {
  const TimesheetCertificateFailedState();
}
