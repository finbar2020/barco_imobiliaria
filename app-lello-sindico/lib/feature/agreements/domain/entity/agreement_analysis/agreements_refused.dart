import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreement_analysis_type.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';

class AgreementsRefused {
  int agreementsReprovedQtd;
  List<AgreementsAnalysisElement> reportReprovedReason;
  List<AgreementsAnalysisElement> reportInstallments;
  List<AgreementsAnalysisElement> reportDueDate;

  AgreementsRefused({
    required this.agreementsReprovedQtd,
    required this.reportReprovedReason,
    required this.reportInstallments,
    required this.reportDueDate,
  });

  List<AgreementsAnalysisElement> get getReportDueDateSorted {
    List<AgreementsAnalysisElement> sortedList = reportDueDate;
    sortedList.sort((a, b) {
      int first = int.tryParse(a.description) ?? 0;
      int second = int.tryParse(b.description) ?? 0;
      return first.compareTo(second);
    });
    return sortedList;
  }

  List<AgreementsAnalysisElement> get getReportInstallmentsSorted {
    List<AgreementsAnalysisElement> installmentsList = reportInstallments;
    installmentsList.sort((a, b) {
      int first = int.tryParse(a.description) ?? 0;
      int second = int.tryParse(b.description) ?? 0;
      return first.compareTo(second);
    });

    return installmentsList;
  }

  List<AgreementsAnalysisElement> getReportReprovedReasonChart(
      BuildContext context) {
    List<AgreementsAnalysisElement> reasonList = reportReprovedReason;
    reasonList.forEach((element) {
      int percentage = element.percentage.toInt();
      int value = element.value.toInt();
      String description = element.description;
      element.legend =
          "$value - $percentage\%\n${getString(context, AgreementAnalysisType.getTypeKey(description))}";
    });
    return reasonList;
  }
}
