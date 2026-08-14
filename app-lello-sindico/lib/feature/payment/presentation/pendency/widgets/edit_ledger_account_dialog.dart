import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/accounting_account_type.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/chosen_ledger_account_dialog.dart';

class EditLedgerAccountDialog extends StatefulWidget {
  final SupplierLedgerAccountsEntity supplierLedgerAccounts;
  final PaymentInstallmentLedgerAccount? ledgerAccount;
  final Function(LedgerAccountEntity?) onChange;

  const EditLedgerAccountDialog({
    super.key,
    required this.supplierLedgerAccounts,
    required this.ledgerAccount,
    required this.onChange,
  });

  @override
  _EditLedgerAccountDialogState createState() =>
      _EditLedgerAccountDialogState();

  static Future<void> show({
    required BuildContext context,
    required SupplierLedgerAccountsEntity supplierLedgerAccounts,
    required PaymentInstallmentLedgerAccount? ledgerAccount,
    required Function(LedgerAccountEntity?) onChange,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EditLedgerAccountDialog(
          supplierLedgerAccounts: supplierLedgerAccounts,
          ledgerAccount: ledgerAccount,
          onChange: onChange,
        );
      },
    );
  }
}

class _EditLedgerAccountDialogState extends State<EditLedgerAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  List<LedgerAccountEntity?> ledgerAccountDropdownItems = [];
  List<LedgerAccountType> accountingLedgerTypes = getLedgerAccountTypes();
  LedgerAccountType? selectedLedgerAccountType;
  LedgerAccountEntity? selectedLedgerAccount;
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();

  @override
  void initState() {
    super.initState();
    _initializeSelectedAccount();
    log(accountingLedgerTypes.map((e) => e.toString()).toList().join(', '));
  }

  void _initializeSelectedAccount() {
    // Itera sobre todos os tipos de ledger accounts
    for (var type in accountingLedgerTypes) {
      // Obtém a lista de ledger accounts para o tipo atual
      var accounts = _getLedgerAccountsByType(type);

      // Itera sobre cada ledger account na lista
      for (var account in accounts) {
        // Verifica se o nome corresponde
        bool nameMatches = account?.name == widget.ledgerAccount?.name;

        // Verifica se o shortCode corresponde (apenas se não for nulo ou 0)
        bool shortCodeMatches = widget.ledgerAccount?.shortCode == null ||
            account?.id == widget.ledgerAccount?.shortCode;

        // Se o nome corresponder e o shortCode for nulo/0 ou corresponder, seleciona o account
        if (nameMatches && shortCodeMatches) {
          setState(() {
            selectedLedgerAccountType = type;
            selectedLedgerAccount = account;
          });
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var labelStyle = LelloTextStyles.bodyBold(theme)!.copyWith(
      color: LelloTheme.palleteOf(theme).text(),
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 8,
        right: 8,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                getString(
                    context, "payment_pendency_ledger_account_dialog_title"),
                style: LelloTextStyles.titleSmall(theme)),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "payments_ledger_account_type_label"),
                style: labelStyle),
            SizedBox(height: Dimens.spacing),
            _buildLedgerAccountTypeDropdown(theme),
            SizedBox(height: Dimens.spacingMedium),
            if (selectedLedgerAccountType != null)
              _buildLedgerAccountDropdownFromSelectedType(
                  theme, selectedLedgerAccountType!),
            SizedBox(height: Dimens.spacingMedium),
            _buildAllLedgerAccountsCheckbox(theme, selectedLedgerAccountType),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  onPressed: selectedLedgerAccount != null
                      ? () {
                          showDialog(
                              context: context,
                              builder: (context) => ChosenLedgerAccountDialog(
                                    ledgerAccount: selectedLedgerAccount!,
                                    ledgerAccountType:
                                        selectedLedgerAccountType!,
                                    onConfirm: () {
                                      widget.onChange(selectedLedgerAccount);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    onCancel: () => Navigator.of(context).pop(),
                                  ));
                        }
                      : null,
                  text: getString(context, "save"),
                ),
                SizedBox(height: Dimens.spacingSmall),
                InvertedPrimaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(getString(context, "cancel")),
                ),
                SizedBox(height: Dimens.spacingMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerAccountTypeDropdown(ThemeData theme) {
    return DropdownButtonFormField<LedgerAccountType>(
      value: selectedLedgerAccountType,
      items: accountingLedgerTypes.map((type) {
        return DropdownMenuItem<LedgerAccountType>(
          value: type,
          child: Text(ledgerAccountTypeToString(type)),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedLedgerAccountType = value;
          selectedLedgerAccount = null;
        });
      },
      hint: Text(getString(context, "payments_ledger_account_type_hint")),
    );
  }

  Widget _buildLedgerAccountDropdownFromSelectedType(
      ThemeData theme, LedgerAccountType ledgerAccountType) {
    ledgerAccountDropdownItems = _getLedgerAccountsByType(ledgerAccountType);

    return DropdownButtonFormField<LedgerAccountEntity>(
      isExpanded: true,
      items: ledgerAccountDropdownItems.map((account) {
        return DropdownMenuItem<LedgerAccountEntity>(
          value: account,
          child: Text(
              '${account?.shortCode ?? getString(context, 'payment_not_available')} - ${account?.name ?? getString(context, 'payment_no_name')}'),
        );
      }).toList(),
      value: selectedLedgerAccount,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.spacingSmall),
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedLedgerAccount = value;
        });
      },
      hint: Text(getString(context, "payments_ledger_account_select_hint")),
    );
  }

  List<LedgerAccountEntity?> _getLedgerAccountsByType(
      LedgerAccountType ledgerAccountType) {
    switch (ledgerAccountType) {
      case LedgerAccountType.extraordinary:
        return widget.supplierLedgerAccounts.extraordinary;
      case LedgerAccountType.ordinary:
        return widget.supplierLedgerAccounts.ordinary;
      case LedgerAccountType.all:
        return widget.supplierLedgerAccounts.all;
      default:
        return [];
    }
  }

  Widget _buildAllLedgerAccountsCheckbox(
      ThemeData theme, LedgerAccountType? type) {
    if (type == LedgerAccountType.extraordinary || type == null) {
      return Container();
    }
    if (type == LedgerAccountType.ordinary &&
        ledgerAccountDropdownItems.isEmpty) {
      selectedLedgerAccountType = LedgerAccountType.all;
    }
    return Row(
      children: [
        Checkbox(
          value: selectedLedgerAccountType == LedgerAccountType.all,
          onChanged: (value) {
            if (ledgerAccountDropdownItems.isNotEmpty || value == true) {
              setState(() {
                selectedLedgerAccountType =
                    value! ? LedgerAccountType.all : LedgerAccountType.ordinary;
                selectedLedgerAccount = null;
                widget.onChange(selectedLedgerAccount);
              });
            }
          },
        ),
        Text(getString(context, "payments_ledger_account_show_all_accounts"),
            style: LelloTextStyles.subtitleBold(theme)),
      ],
    );
  }
}
