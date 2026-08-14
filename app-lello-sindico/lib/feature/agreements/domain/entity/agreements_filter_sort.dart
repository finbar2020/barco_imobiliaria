import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';

class AgreementsFilterSort {
  String filterUnitOrName;
  String filterPaymentMethodKey;
  String sortNameKey;
  String sortUnitKey;
  String sortDueDateKey;
  String sortProposalDateKey;

  AgreementsFilterSort({
    this.filterUnitOrName = "",
    this.filterPaymentMethodKey = "",
    this.sortNameKey = "",
    this.sortUnitKey = "",
    this.sortDueDateKey = "",
    this.sortProposalDateKey = "",
  });

  void changeValue(String key) {
    switch (key) {
      case (AgreementsFilterSortKeys.nameAtoZ):
        sortNameKey =
            changeKeyValue(sortNameKey, AgreementsFilterSortKeys.nameAtoZ);
        break;
      case (AgreementsFilterSortKeys.nameZtoA):
        sortNameKey =
            changeKeyValue(sortNameKey, AgreementsFilterSortKeys.nameZtoA);
        break;
      case (AgreementsFilterSortKeys.unitCrescent):
        sortUnitKey =
            changeKeyValue(sortUnitKey, AgreementsFilterSortKeys.unitCrescent);
        break;
      case (AgreementsFilterSortKeys.unitDecrescent):
        sortUnitKey = changeKeyValue(
            sortUnitKey, AgreementsFilterSortKeys.unitDecrescent);
        break;
      case (AgreementsFilterSortKeys.dueDateCrescent):
        sortDueDateKey = changeKeyValue(
            sortDueDateKey, AgreementsFilterSortKeys.dueDateCrescent);
        break;
      case (AgreementsFilterSortKeys.dueDateDecrescent):
        sortDueDateKey = changeKeyValue(
            sortDueDateKey, AgreementsFilterSortKeys.dueDateDecrescent);
        break;
      case (AgreementsFilterSortKeys.proposalDateCrescent):
        sortProposalDateKey = changeKeyValue(
            sortProposalDateKey, AgreementsFilterSortKeys.proposalDateCrescent);
        break;
      case (AgreementsFilterSortKeys.proposalDateDecrescent):
        sortProposalDateKey = changeKeyValue(sortProposalDateKey,
            AgreementsFilterSortKeys.proposalDateDecrescent);
        break;
      case (AgreementsFilterSortKeys.billet):
        filterPaymentMethodKey = changeKeyValue(
            filterPaymentMethodKey, AgreementsFilterSortKeys.billet);
        break;
      case (AgreementsFilterSortKeys.credit):
        filterPaymentMethodKey = changeKeyValue(
            filterPaymentMethodKey, AgreementsFilterSortKeys.credit);
        break;
    }
  }

  String changeKeyValue(String key, String value) {
    if (key == value) {
      return "";
    } else {
      return value;
    }
  }

  bool isKeyChecked(String filterSortKeys) {
    switch (filterSortKeys) {
      case (AgreementsFilterSortKeys.nameAtoZ):
        return (sortNameKey == AgreementsFilterSortKeys.nameAtoZ);
      case (AgreementsFilterSortKeys.nameZtoA):
        return (sortNameKey == AgreementsFilterSortKeys.nameZtoA);
      case (AgreementsFilterSortKeys.unitCrescent):
        return (sortUnitKey == AgreementsFilterSortKeys.unitCrescent);
      case (AgreementsFilterSortKeys.unitDecrescent):
        return (sortUnitKey == AgreementsFilterSortKeys.unitDecrescent);
      case (AgreementsFilterSortKeys.dueDateCrescent):
        return (sortDueDateKey == AgreementsFilterSortKeys.dueDateCrescent);
      case (AgreementsFilterSortKeys.dueDateDecrescent):
        return (sortDueDateKey == AgreementsFilterSortKeys.dueDateDecrescent);
      case (AgreementsFilterSortKeys.proposalDateCrescent):
        return (sortProposalDateKey ==
            AgreementsFilterSortKeys.proposalDateCrescent);
      case (AgreementsFilterSortKeys.proposalDateDecrescent):
        return (sortProposalDateKey ==
            AgreementsFilterSortKeys.proposalDateDecrescent);
      case (AgreementsFilterSortKeys.billet):
        return (filterPaymentMethodKey == AgreementsFilterSortKeys.billet);
      case (AgreementsFilterSortKeys.credit):
        return (filterPaymentMethodKey == AgreementsFilterSortKeys.credit);
    }
    return false;
  }

  List<Agreement> filterSortList(List<Agreement> agreements) {
    List<Agreement> agreementsFiltered = agreements;
    //Filters
    if (thereIsFilter()) {
      agreementsFiltered = [];
      if (filterUnitOrName.isNotEmpty) {
        agreements.forEach((e) {
          if ((e.unit ?? "").contains(filterUnitOrName) ||
              (e.unitOwner ?? "")
                  .toLowerCase()
                  .contains(filterUnitOrName.toLowerCase())) {
            agreementsFiltered.add(e);
          }
        });
      }
      if (filterPaymentMethodKey.isNotEmpty) {
        agreements.forEach((e) {
          if (filterPaymentMethodKey == AgreementsFilterSortKeys.billet &&
              e.paymentMethod == PaymentMethod.billet) {
            agreementsFiltered.add(e);
          }
          if (filterPaymentMethodKey == AgreementsFilterSortKeys.credit &&
              e.paymentMethod == PaymentMethod.credit) {
            agreementsFiltered.add(e);
          }
        });
      }
    }
    //Sorts
    if (sortNameKey.isNotEmpty) {
      agreementsFiltered.forEach((e) {
        if (sortNameKey == AgreementsFilterSortKeys.nameAtoZ) {
          agreementsFiltered
              .sort((a, b) => (a.unitOwner ?? "").compareTo(b.unitOwner ?? ""));
        }
        if (sortNameKey == AgreementsFilterSortKeys.nameZtoA) {
          agreementsFiltered
              .sort((a, b) => (b.unitOwner ?? "").compareTo(a.unitOwner ?? ""));
        }
      });
    }
    if (sortUnitKey.isNotEmpty) {
      agreementsFiltered.forEach((e) {
        if (sortUnitKey == AgreementsFilterSortKeys.unitCrescent) {
          agreementsFiltered
              .sort((a, b) => (a.unit ?? "").compareTo(b.unit ?? ""));
        }
        if (sortUnitKey == AgreementsFilterSortKeys.unitDecrescent) {
          agreementsFiltered
              .sort((a, b) => (b.unit ?? "").compareTo(a.unit ?? ""));
        }
      });
    }
    if (sortProposalDateKey.isNotEmpty) {
      agreementsFiltered.forEach((e) {
        if (sortProposalDateKey ==
            AgreementsFilterSortKeys.proposalDateCrescent) {
          agreementsFiltered.sort((a, b) =>
              (a.lastInstallmentDate ?? DateTime.now())
                  .compareTo(b.lastInstallmentDate ?? DateTime.now()));
        }
        if (sortProposalDateKey ==
            AgreementsFilterSortKeys.proposalDateDecrescent) {
          agreementsFiltered.sort((a, b) =>
              (b.lastInstallmentDate ?? DateTime.now())
                  .compareTo(a.lastInstallmentDate ?? DateTime.now()));
        }
      });
    }
    if (sortDueDateKey.isNotEmpty) {
      agreementsFiltered.forEach((e) {
        if (sortDueDateKey == AgreementsFilterSortKeys.dueDateCrescent) {
          agreementsFiltered.sort((a, b) =>
              (a.lastInstallmentDate ?? DateTime.now())
                  .compareTo(b.lastInstallmentDate ?? DateTime.now()));
        }
        if (sortDueDateKey == AgreementsFilterSortKeys.dueDateDecrescent) {
          agreementsFiltered.sort((a, b) =>
              (b.lastInstallmentDate ?? DateTime.now())
                  .compareTo(a.lastInstallmentDate ?? DateTime.now()));
        }
      });
    }
    return agreementsFiltered;
  }

  bool thereIsFilter() {
    if (filterUnitOrName.isNotEmpty || filterPaymentMethodKey.isNotEmpty) {
      return true;
    }
    return false;
  }
}

class AgreementsFilterSortKeys {
  static const String nameAtoZ = "agreements_filter_name_a_z";
  static const String nameZtoA = "agreements_filter_name_z_a";
  static const String unitCrescent = "agreements_filter_unit_crescent";
  static const String unitDecrescent = "agreements_filter_unit_decrescent";
  static const String dueDateCrescent =
      "agreements_filter_agreement_due_crescent";
  static const String dueDateDecrescent =
      "agreements_filter_agreement_due_decrescent";
  static const String proposalDateCrescent =
      "agreements_filter_agreement_proposal_crescent";
  static const String proposalDateDecrescent =
      "agreements_filter_agreement_proposal_decrescent";
  static const String billet = "agreements_filter_payment_method_billet";
  static const String credit = "agreements_filter_payment_method_credit_card";
}
