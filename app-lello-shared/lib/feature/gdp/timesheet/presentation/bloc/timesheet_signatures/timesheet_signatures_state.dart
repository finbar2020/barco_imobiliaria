import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

abstract class TimesheetSignaturesState extends Equatable {
  final List<TimesheetSignature> signatures;
  final List<TimesheetSignature> listSign;
  TimesheetFilter? query;

  final String? condominiumId;
  DateTime? selectedMonth;

  TimesheetSignaturesState(this.signatures, this.listSign, this.query,
      this.condominiumId, this.selectedMonth);

  @override
  List<Object?> get props =>
      [signatures, listSign, query, condominiumId, selectedMonth];
}

class TimesheetSignaturesLoadingState extends TimesheetSignaturesState {
  TimesheetSignaturesLoadingState(
      List<TimesheetSignature>? signatures,
      List<TimesheetSignature> listSign,
      TimesheetFilter? query,
      String? condominiumId,
      DateTime? selectedMonth)
      : super(signatures ?? [], listSign, query, condominiumId, selectedMonth);
}

class TimesheetSignaturesLoadFailedState extends TimesheetSignaturesState {
  final Failure error;

  TimesheetSignaturesLoadFailedState(
      List<TimesheetSignature> signatures,
      List<TimesheetSignature> listSign,
      TimesheetFilter query,
      String condominiumId,
      DateTime? selectedMonth,
      this.error)
      : super(signatures, listSign, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetSignaturesLoadedState extends TimesheetSignaturesState {
  final bool donePaging;

  TimesheetSignaturesLoadedState(
      List<TimesheetSignature> signatures,
      List<TimesheetSignature> listSign,
      TimesheetFilter query,
      String condominiumId,
      DateTime? selectedMonth,
      this.donePaging)
      : super(signatures, listSign, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}

class TimesheetSigningState extends TimesheetSignaturesState {
  TimesheetSigningState(
      List<TimesheetSignature> signatures,
      List<TimesheetSignature> listSign,
      TimesheetFilter query,
      String condominiumId,
      DateTime? selectedMonth)
      : super(signatures, listSign, query, condominiumId, selectedMonth);
}

class TimesheetSignFailedState extends TimesheetSignaturesState {
  final Failure error;

  TimesheetSignFailedState(
      List<TimesheetSignature> signatures,
      List<TimesheetSignature> listSign,
      TimesheetFilter query,
      String condominiumId,
      DateTime? selectedMonth,
      this.error)
      : super(signatures, listSign, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, error];
}

class TimesheetSignedState extends TimesheetSignaturesState {
  final bool donePaging;

  TimesheetSignedState(
      List<TimesheetSignature> signatures,
      List<TimesheetSignature> listSign,
      TimesheetFilter query,
      String condominiumId,
      DateTime? selectedMonth,
      this.donePaging)
      : super(signatures, listSign, query, condominiumId, selectedMonth);

  @override
  List<Object?> get props => [...super.props, donePaging];
}
