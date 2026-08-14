import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

class ResinNewBankAccountFormData {
  ResinPerson? selectedPerson;
  ResinBank? selectedBank;
  ResinBankAccountType? accountType;
  final TextEditingController agencyController;
  final TextEditingController accountController;
  final TextEditingController digitController;
  ResinNewBankAccountFormData({
    required this.agencyController,
    required this.accountController,
    required this.digitController,
    this.selectedPerson,
    this.selectedBank,
    this.accountType,
  });
}
