import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';

class AgreementsFinished {
  int agreementsPerformedAutomaticallyQtd;
  int agreementsManuallyApprovedQtd;
  List<AgreementsAnalysisElement> reportPaymentMethod;
  List<AgreementsAnalysisElement> reportInstallments;
  List<AgreementsAnalysisElement> reportDueDate;

  AgreementsFinished({
    required this.agreementsPerformedAutomaticallyQtd,
    required this.agreementsManuallyApprovedQtd,
    required this.reportPaymentMethod,
    required this.reportInstallments,
    required this.reportDueDate,
  });

  int get getTotal {
    return agreementsPerformedAutomaticallyQtd + agreementsManuallyApprovedQtd;
  }

  bool get isEmpty {
    if (agreementsPerformedAutomaticallyQtd == 0 &&
        agreementsManuallyApprovedQtd == 0 &&
        reportPaymentMethod.isEmpty &&
        reportInstallments.isEmpty &&
        reportDueDate.isEmpty) {
      return true;
    }
    return false;
  }

  List<AgreementsAnalysisElement> get getReportDueDateSorted {
    List<AgreementsAnalysisElement> sortedList = reportDueDate;
    sortedList.sort((a, b) {
      int first = int.tryParse(a.description) ?? 0;
      int second = int.tryParse(b.description) ?? 0;
      return first.compareTo(second);
    });
    return sortedList;
  }

  List<AgreementsAnalysisElement> getReportInstallmentsForChart(
      BuildContext context) {
    List<AgreementsAnalysisElement> installmentsList = reportInstallments;
    installmentsList.sort((a, b) {
      int first = int.tryParse(a.description) ?? 0;
      int second = int.tryParse(b.description) ?? 0;
      return first.compareTo(second);
    });
    installmentsList.forEach((element) {
      int percentage = element.percentage.toInt();
      int value = element.value.toInt();
      int description = int.tryParse(element.description) ?? 0;
      element.legend =
          "$value - $percentage\%\n${getString(context, 'agreements_analysis_paid_in')} ${description}x";
    });

    return installmentsList;
  }
}
